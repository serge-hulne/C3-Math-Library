# Project Context

## What This Is

A math library written in C3 (version 0.7.8+), located at:
`/Users/sergehulne/Documents/code1/C3/tests/4tran/4tran_1/c3_math_lib/`

It compiles and runs successfully with `c3c build mathlib_example`.

## Source Files

| File | Module | Purpose |
|---|---|---|
| `math_core.c3` | `mathlib::core` | Constants (PI, E, etc.), abs, min, max, clamp, lerp, sign |
| `trig.c3` | `mathlib::trig` | sin, cos, tan, asin, acos, atan, atan2, sinh, cosh, etc. (extern wrappers around libc) |
| `power.c3` | `mathlib::power` | sqrt, cbrt, pow, exp, log, log10, log2, etc. (extern wrappers around libc) + powi, nthroot |
| `types.c3` | `mathlib::types` | `distinct Double = double` and `distinct Float = float` with `^` power operator |
| `vector.c3` | `mathlib::vector` | Vec2, Vec3, Vec4 structs with operator overloading (+, -, *, /, ^) and member functions |
| `matrix.c3` | `mathlib::matrix` | Mat2, Mat3, Mat4 (column-major), transforms, perspective, ortho, look_at |
| `matnm.c3` | `mathlib::matnm` | Arbitrary NxM heap-allocated matrices, LU decomposition, inverse, rank, solver, ^ element-wise power |
| `complex.c3` | `mathlib::complex` | Complex number arithmetic (+,-,*,/,^), polar form, transcendental functions |
| `quaternion.c3` | `mathlib::quaternion` | Quaternion algebra, axis-angle, Euler, SLERP, vector rotation |
| `statistics.c3` | `mathlib::stats` | mean, median, mode, variance, std_dev, percentile, correlation |
| `example.c3` | `example` | Demo program exercising all modules |
| `project.json` | — | Build config with target `mathlib_example` |

## Key API Conventions (C3 Constraints)

C3 does not support static methods. The first parameter of a `Type.method()` must be `Type` or `Type*`. Therefore:

- **Constructors** are module-level functions, not type methods:
  - `vector::vec3(x, y, z)` not `Vec3.new(x, y, z)`
  - `matrix::mat4_identity()` not `Mat4.identity()`
  - `matrix::mat4_translate(v)` not `Mat4.translate(v)`
  - `complex::complex_new(r, i)` not `Complex.new(r, i)`
  - `quaternion::quat_identity()` not `Quaternion.identity()`
  - `quaternion::quat_from_axis_angle(axis, angle)` not `Quaternion.from_axis_angle(...)`
  - `quaternion::quat_slerp(q1, q2, t)` not `Quaternion.slerp(...)`
  - `matnm::matnm_new(rows, cols)` not `MatNM.new(rows, cols)`
  - `matnm::matnm_identity(n)` not `MatNM.identity(n)`
  - `matnm::matnm_solve(a, b)` not `MatNM.solve(a, b)`
  - `matnm::matnm_free(&m)` — must free heap-allocated MatNM instances
  - `mem::free(slice)` — must free `double[]` returned by `get_row()`/`get_col()`

- **Instance methods** (first param is self) remain as type methods:
  - `v.length()`, `v.normalize()`, `q.rotate(v)`, `m.determinant()`, etc.
  - Two-arg methods on the type also work: `Vec3.dot(v1, v2)`, `Vec3.cross(v1, v2)`

- **Struct initializer syntax** requires parentheses: `(Vec3){ x, y, z }` not `Vec3 { x, y, z }`

- **Array-field struct init** uses positional: `return { { 1, 0, 0, 1 } };` not `Mat2 { .m = { ... } }`

- **Unqualified extern calls** don't work across modules. Must use `power::sqrt(...)`, `trig::sin(...)`, etc.

## Build & Run

```bash
c3c build mathlib_example
./out/mathlib_example
```

## What Was Fixed (Session History)

The library was generated with several C3 language errors. All were fixed:

1. `project.json` — removed invalid `libraries` key, fixed `dependencies` to array, listed all source files
2. `matrix.c3` — replaced `MatN { .m = {...}}` with `{ {...} }`, converted static-like methods to module-level functions, prefixed trig/power calls
3. `vector.c3` — converted `Vec2.new`/`Vec3.new`/`Vec4.new` to `vec2()`/`vec3()`/`vec4()`, prefixed `sqrt` with `power::`
4. `complex.c3` — converted constructors and transcendental functions to module-level, prefixed all math calls
5. `quaternion.c3` — same pattern, converted constructors/slerp to module-level functions
6. `statistics.c3` — prefixed `sqrt` with `power::`
7. `example.c3` — updated all call sites
8. All `.md` docs — updated to reflect new API

## Session: Added Arbitrary NxM Matrix Support (2026-02-11)

Added a new `matnm.c3` module (`mathlib::matnm`) providing a general-purpose heap-allocated `MatNM` type for arbitrary NxM matrices, coexisting alongside the fixed-size Mat2/Mat3/Mat4.

### What was added

1. **`matnm.c3`** (new file) — Full MatNM implementation:
   - `MatNM` struct with `rows`, `cols`, and column-major `double[] data` (heap-allocated)
   - Constructors: `matnm_new`, `matnm_identity`, `matnm_from_data`, `matnm_free`
   - Element access: `get`, `set`, `get_row`, `get_col` (last two return heap-allocated `double[]`)
   - Arithmetic with operator overloading: `add(+)`, `sub(-)`, `neg(-)`, `mul(*)`, `scale`
   - Matrix operations: `transpose`, `trace`, `determinant`, `inverse`, `frobenius_norm`
   - Decomposition: `lu_decompose` (partial pivoting, returns `LUResult` with L, U, sign), `row_echelon`, `rank`
   - Linear solver: `matnm_solve(a, b)` — solves Ax = b
   - Conversion to/from fixed-size: `matnm_from_mat2/3/4`, `matnm_to_mat2/3/4`

2. **`project.json`** — Added `matnm.c3` to sources list

3. **`example.c3`** — Added `demonstrate_matnm()` function covering:
   - Matrix creation, element access, row/column extraction
   - Arithmetic (+, -, *), transpose, trace, determinant, Frobenius norm
   - Inverse with verification (m * inv(m) = I)
   - LU decomposition, rank
   - Non-square (2x3) matrix operations
   - Mat4 round-trip conversion
   - Linear system solving
   - Proper memory cleanup for all MatNM instances and `get_row`/`get_col` slices

4. **All `.md` docs** — Updated README.md, GETTING_STARTED.md, QUICK_REFERENCE.md, and context.md with MatNM API reference, usage examples, and memory management guidance

### C3 syntax lessons learned during implementation

- Named struct initializers (`MatNM { .rows = x, .cols = y }`) don't work — must use explicit field assignment
- Empty slice assignment: use `m.data = {}` not `m.data = double[]{}`
- `mem::new_array(double, n)` for heap allocation, `mem::free(slice)` for deallocation
- `std::math::sqrt` available via `import std::math` for non-module-level math calls

### Memory management notes

- Every `MatNM` returned by constructors, arithmetic, transpose, inverse, etc. is a new heap allocation — caller must free with `matnm::matnm_free()`
- `LUResult` contains two MatNM fields (`l` and `u`) — both must be freed separately
- `get_row()` and `get_col()` return heap-allocated `double[]` — caller must free with `mem::free()`

## Session: Added ^ Power Operator (2026-03-06)

Added the `^` power operator across all user-defined types and new distinct scalar types.

### What was added

1. **`types.c3`** (new file) — `mathlib::types` module:
   - `distinct Double = double` with `Double.pow(base, double exp) @operator(^)`
   - `distinct Float = float` with `Float.pow(base, float exp) @operator(^)`
   - Second param is the primitive type (not distinct) so literals work naturally: `x ^ 2.0`

2. **`vector.c3`** — added `@operator(^)` to Vec2, Vec3, Vec4:
   - Element-wise power: `v ^ exp` raises each component to `exp` (a `double`)

3. **`complex.c3`** — added `@operator(^)` to Complex:
   - Complex exponentiation: `c1 ^ c2` calls `complex_pow(c1, c2)` = `e^(c2 * ln(c1))`
   - Both operands are `Complex`; wrap real exponents with `complex_new(exp, 0.0)`

4. **`matnm.c3`** — added `@operator(^)` to MatNM:
   - Element-wise power: `m ^ exp` (also covers arbitrary-length Nx1 vectors)
   - Returns a new heap-allocated MatNM — caller must free with `matnm_free()`

5. **`project.json`** — added `types.c3` to sources

6. **`example.c3`** — added `demonstrate_power_operator()`:
   - Covers `Double`, `Float`, `Vec2`, `Vec3`, `Vec4`, `Complex`, `MatNM`, 5-element vector

7. **All `.md` docs** — updated README.md, GETTING_STARTED.md, QUICK_REFERENCE.md, context.md

### Design decisions

- C3 does not allow operator overloading on built-in primitive types — hence `distinct` types
- `distinct` types require explicit cast to/from primitive: `(Double)2.0`, `(double)myDouble`
- For Vec/MatNM, the exponent is `double` (not the struct type) — mirrors the `*` scalar pattern
- For Complex, both operands are `Complex` — the general mathematical definition
- `^` was unused in all existing source files (only appeared in comments)

## Possible Next Steps

- Add unit tests (`test.c3`)
- Add more statistical functions (skewness, kurtosis)
- Add numerical methods (integration, root finding)
- Add FFT or random number generation
- Add eigenvalue/eigenvector decomposition to MatNM
- Add sparse matrix support
- Package as a reusable C3 library
