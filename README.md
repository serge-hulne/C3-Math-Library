# C3 Mathematics Library

A comprehensive mathematics library for the C3 programming language (version 0.7+), providing linear algebra, trigonometry, statistics, and scientific computing functions.

## Features

### Core Mathematics (`mathlib::core`)
- Mathematical constants (PI, E, SQRT2, GOLDEN_RATIO)
- Degree/Radian conversion
- Absolute value, min, max, clamp
- Sign function, square, cube
- Linear interpolation (lerp)
- Range mapping
- Fast inverse square root (Quake III algorithm)

### Trigonometry (`mathlib::trig`)
- Standard trig functions: sin, cos, tan
- Inverse functions: asin, acos, atan, atan2
- Hyperbolic functions: sinh, cosh, tanh
- Inverse hyperbolic: asinh, acosh, atanh
- Extended functions: cot, sec, csc, haversine
- Angle normalization utilities

### Power & Exponentials (`mathlib::power`)
- Power functions: pow, powi (optimized for integers)
- Roots: sqrt, cbrt, nthroot
- Exponentials: exp, expm1
- Logarithms: log, log10, log2, log1p, logb
- Hypot (overflow-safe distance)
- Power-of-2 utilities

### Scalar Types with Power Operator (`mathlib::types`)
- `distinct Double = double` and `distinct Float = float`
- `^` power operator: `x ^ 2.0`, `x ^ 0.5` — analogous to `**` in Fortran/Python
- Explicit cast to/from primitives: `(Double)2.0`, `(double)myDouble`

### Vectors (`mathlib::vector`)
- Vec2, Vec3, Vec4 types
- Operator overloading (+, -, *, /, ^)
- Element-wise power: `v ^ exp` raises each component to `exp`
- Dot product and cross product
- Length, normalization, distance
- Linear interpolation (lerp)
- Reflection and perpendicular vectors
- Member function dot notation support

### Matrices (`mathlib::matrix`)
- Mat2, Mat3, Mat4 types (column-major)
- Matrix arithmetic (+, -, *)
- Identity and zero matrices
- Transpose and determinant
- Matrix inverse (Mat2)
- Vector transformation
- 3D transformations:
  - Translation, rotation (X, Y, Z axes)
  - Scaling (uniform and non-uniform)
  - Perspective and orthographic projection
  - Look-at matrix for cameras

### Statistics (`mathlib::stats`)
- Descriptive statistics: mean, median, mode
- Variance and standard deviation (population & sample)
- Min, max, sum, product
- Percentiles and quartiles
- Interquartile range (IQR)
- Covariance and correlation

### Complex Numbers (`mathlib::complex`)
- Complex arithmetic (+, -, *, /, ^)
- Complex power operator: `c1 ^ c2` computes `e^(c2 * ln(c1))`
- Magnitude and phase
- Polar coordinates
- Complex exponential and logarithm
- Complex power and square root
- Complex trigonometry (sin, cos, tan)
- Conjugate

### Quaternions (`mathlib::quaternion`)
- Quaternion arithmetic
- Axis-angle and Euler angle conversions
- Vector rotation
- Spherical linear interpolation (SLERP)
- Normalization and inverse
- Dot product
- Full 3D rotation support

### Arbitrary NxM Matrices (`mathlib::matnm`)
- Heap-allocated arbitrary NxM matrix type (column-major)
- Element access (get, set, get_row, get_col)
- Arithmetic with operator overloading (+, -, *, ^)
- Element-wise power: `m ^ exp` (also works for Nx1 vectors of arbitrary length)
- Scalar multiply
- Transpose, trace, Frobenius norm
- Determinant via LU decomposition
- Matrix inverse via Gaussian elimination
- LU decomposition with partial pivoting
- Row echelon form and rank computation
- Linear system solver (Ax = b)
- Conversion to/from fixed-size Mat2, Mat3, Mat4

## Installation

1. Copy the library files to your C3 project
2. Import the modules you need:

```c++
import mathlib::core;
import mathlib::types;   // For ^ power operator on scalars
import mathlib::vector;
import mathlib::matrix;
import mathlib::matnm;
// ... etc
```

## Usage Examples

### Basic Math

```c++
import mathlib::core;

fn void example() {
    double angle = core::deg_to_rad(45.0);
    double x = core::lerp(0.0, 100.0, 0.5);  // 50.0
    double y = core::clamp(150.0, 0.0, 100.0);  // 100.0
}
```

### Power Operator (^ )

```c++
import mathlib::types;
import mathlib::vector;
import mathlib::complex;
import mathlib::matnm;

fn void example() {
    // Scalar: use distinct Double or Float
    Double x = (Double)2.0;
    Double y = x ^ 10.0;           // 1024.0
    double raw = (double)y;

    // Vec3: element-wise power
    Vec3 v = vector::vec3(1.0, 2.0, 3.0);
    Vec3 sq = v ^ 2.0;             // (1.0, 4.0, 9.0)

    // Complex: full complex exponentiation
    Complex i = complex::complex_new(0.0, 1.0);
    Complex r = i ^ i;             // i^i = e^(-pi/2) ≈ 0.2079

    // MatNM: element-wise power (also works for Nx1 vectors)
    MatNM vec = matnm::matnm_new(4, 1);
    // ... fill elements ...
    MatNM sq_vec = vec ^ 2.0;
    matnm::matnm_free(&sq_vec);
}
```

### Vector Operations

```c++
import mathlib::vector;

fn void example() {
    Vec3 v1 = vector::vec3(1.0, 2.0, 3.0);
    Vec3 v2 = vector::vec3(4.0, 5.0, 6.0);

    Vec3 sum = v1 + v2;  // Using operator overloading
    Vec3 sq  = v1 ^ 2.0; // Element-wise power
    double dot = Vec3.dot(v1, v2);
    Vec3 cross = Vec3.cross(v1, v2);

    double len = v1.length();  // Member function
    Vec3 normalized = v1.normalize();
}
```

### Matrix Transformations

```c++
import mathlib::matrix;
import mathlib::vector;

fn void example() {
    // Create transformation matrices
    Mat4 translate = matrix::mat4_translate(vector::vec3(5.0, 0.0, 0.0));
    Mat4 rotate = matrix::mat4_rotate_z(core::deg_to_rad(45.0));
    Mat4 scale = matrix::mat4_scale_uniform(2.0);

    // Combine transformations
    Mat4 transform = translate * rotate * scale;

    // Transform a vector
    Vec4 v = vector::vec4(1.0, 0.0, 0.0, 1.0);
    Vec4 result = transform.transform(&v);
}
```

### Statistics

```c++
import mathlib::stats;

fn void example() {
    double[] data = { 1.0, 2.0, 3.0, 4.0, 5.0 };

    double avg = stats::mean(data);
    double std = stats::std_dev(data);
    double q1 = stats::percentile(data, 25.0);
}
```

### Complex Numbers

```c++
import mathlib::complex;

fn void example() {
    Complex c1 = complex::complex_new(3.0, 4.0);  // 3 + 4i
    Complex c2 = complex::complex_new(1.0, 2.0);  // 1 + 2i

    Complex sum = c1 + c2;
    Complex product = c1 * c2;

    double magnitude = c1.magnitude();
    double phase = c1.phase();
}
```

### Quaternions

```c++
import mathlib::quaternion;
import mathlib::vector;

fn void example() {
    // Create rotation: 90 degrees around Z-axis
    Vec3 axis = vector::vec3(0.0, 0.0, 1.0);
    Quaternion q = quaternion::quat_from_axis_angle(axis, core::deg_to_rad(90.0));

    // Rotate a vector
    Vec3 v = vector::vec3(1.0, 0.0, 0.0);
    Vec3 rotated = q.rotate(v);

    // Interpolate between rotations
    Quaternion q1 = quaternion::quat_identity();
    Quaternion q2 = quaternion::quat_from_euler(0.0, core::PI, 0.0);
    Quaternion interpolated = quaternion::quat_slerp(q1, q2, 0.5);
}
```

### Arbitrary NxM Matrices

```c++
import mathlib::matnm;

fn void example() {
    // Create a 3x3 matrix and set elements
    MatNM m = matnm::matnm_new(3, 3);
    m.set(0, 0, 1.0); m.set(0, 1, 2.0); m.set(0, 2, 3.0);
    m.set(1, 0, 0.0); m.set(1, 1, 4.0); m.set(1, 2, 5.0);
    m.set(2, 0, 1.0); m.set(2, 1, 0.0); m.set(2, 2, 6.0);

    // Identity and arithmetic
    MatNM id = matnm::matnm_identity(3);
    MatNM sum = m + id;
    MatNM product = m * id;

    // Transpose, determinant, inverse
    MatNM mt = m.transpose();
    double det = m.determinant();
    MatNM inv = m.inverse();

    // LU decomposition, rank
    LUResult lu = m.lu_decompose();
    usz rank = m.rank();

    // Solve Ax = b
    MatNM b = matnm::matnm_new(3, 1);
    b.set(0, 0, 1.0); b.set(1, 0, 2.0); b.set(2, 0, 3.0);
    MatNM x = matnm::matnm_solve(m, b);

    // Row and column extraction (heap-allocated, must be freed)
    double[] row0 = m.get_row(0);
    double[] col1 = m.get_col(1);
    // ... use row0 and col1 ...
    mem::free(row0);   // Free the extracted row slice
    mem::free(col1);   // Free the extracted column slice

    // Convert from/to fixed-size matrices
    Mat4 mat4id = matrix::mat4_identity();
    MatNM from4 = matnm::matnm_from_mat4(mat4id);
    Mat4 back = matnm::matnm_to_mat4(from4);

    // Free MatNM instances when done
    matnm::matnm_free(&m);
    matnm::matnm_free(&id);
    matnm::matnm_free(&sum);
    // ... etc
}
```

## Building

To build and run the example:

```bash
c3c build mathlib_example
./out/mathlib_example
```

## Module Structure

```
mathlib/
├── core         - Core mathematical functions and constants
├── trig         - Trigonometric functions
├── power        - Power and exponential functions
├── types        - Distinct scalar types (Float, Double) with ^ operator
├── vector       - 2D, 3D, and 4D vector types (^ element-wise power)
├── matrix       - 2x2, 3x3, and 4x4 matrix types
├── matnm        - Arbitrary NxM heap-allocated matrices (^ element-wise power)
├── stats        - Statistical functions
├── complex      - Complex number arithmetic (^ complex power)
└── quaternion   - Quaternion operations for 3D rotations
```

## Features of C3 Used

This library demonstrates several C3 features:

- **Module System**: Clean namespace organization
- **Operator Overloading**: Natural syntax for vector/matrix math, including `^` for power
- **Distinct Types**: `Double` and `Float` enable the `^` power operator on scalars
- **Member Functions**: Dot notation for method calls
- **External Functions**: Integration with C standard library (math.h)
- **Default Arguments**: Convenient function calls
- **Inline Functions**: Performance optimization hints

## API Convention

Constructor-like functions are module-level functions (not type methods), since C3 does not support static methods:

| Old (invalid) | New (correct) |
|---|---|
| `Vec3.new(x, y, z)` | `vector::vec3(x, y, z)` |
| `Mat4.identity()` | `matrix::mat4_identity()` |
| `Mat4.translate(v)` | `matrix::mat4_translate(v)` |
| `Complex.new(r, i)` | `complex::complex_new(r, i)` |
| `Quaternion.identity()` | `quaternion::quat_identity()` |
| `Quaternion.from_axis_angle(a, ang)` | `quaternion::quat_from_axis_angle(a, ang)` |
| `Quaternion.slerp(q1, q2, t)` | `quaternion::quat_slerp(q1, q2, t)` |
| `MatNM.new(r, c)` | `matnm::matnm_new(r, c)` |
| `MatNM.identity(n)` | `matnm::matnm_identity(n)` |
| `MatNM.solve(a, b)` | `matnm::matnm_solve(a, b)` |

Instance methods (that take `self`/`Type*` or `Type` as first param) remain as type methods:

```c++
v.length()          // OK - takes Vec3* self
v.normalize()       // OK - takes Vec3* self
Vec3.dot(v1, v2)    // OK - takes two Vec3 values
q.rotate(v)         // OK - takes Quaternion* self
```

## Requirements

- C3 Compiler version 0.7 or later
- C standard library (for math functions)

## License

This library is provided as-is for use in your C3 projects.

## Notes

- All matrices use **column-major** ordering (compatible with OpenGL)
- Angles are in **radians** unless specified otherwise
- Vector and quaternion operations that normalize return a new value
- Division by near-zero values returns safe defaults (identity, zero vector, etc.)
- Statistical functions may modify input arrays (e.g., median, percentile)
- MatNM instances are heap-allocated — always call `matnm::matnm_free()` when done
- `MatNM.get_row()` and `MatNM.get_col()` return heap-allocated `double[]` slices — free them with `mem::free()`

## Performance Considerations

- Use `power::powi()` instead of `power::pow()` for integer exponents (much faster)
- `Vec3.length_squared()` is faster than `Vec3.length()` when you only need comparison
- `Quaternion.magnitude_squared()` similarly avoids square root
- Inlined functions (marked `@inline`) provide optimization hints to the compiler
- Fast inverse square root is available for specific use cases

## See Also

- [C3 Language Documentation](https://c3-lang.org/)
- [C3 GitHub Repository](https://github.com/c3lang/c3c)
