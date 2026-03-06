# C3 Math Library - Quick Reference Guide

## Module Imports

```c++
import mathlib::core;        // Core functions and constants
import mathlib::trig;        // Trigonometry
import mathlib::power;       // Power and exponential functions
import mathlib::types;       // Distinct scalar types (Float, Double) with ^ operator
import mathlib::vector;      // Vector types and operations
import mathlib::matrix;      // Matrix types and operations
import mathlib::stats;       // Statistics
import mathlib::complex;     // Complex numbers
import mathlib::quaternion;  // Quaternions for 3D rotations
import mathlib::matnm;       // Arbitrary NxM matrices
```

## Constants (mathlib::core)

```c++
core::PI              // 3.14159265358979323846
core::E               // 2.71828182845904523536
core::SQRT2           // 1.41421356237309504880
core::SQRT3           // 1.73205080756887729352
core::GOLDEN_RATIO    // 1.61803398874989484820
core::EPSILON         // 1e-10
core::DEG_TO_RAD      // PI / 180.0
core::RAD_TO_DEG      // 180.0 / PI
```

## Quick Function Reference

### Core Math

```c++
core::abs(x)                    // Absolute value
core::min(a, b)                 // Minimum
core::max(a, b)                 // Maximum
core::clamp(x, min, max)        // Clamp value
core::sign(x)                   // Sign: -1, 0, or 1
core::square(x)                 // x squared
core::cube(x)                   // x cubed
core::lerp(a, b, t)            // Linear interpolation
core::approx_equal(a, b, eps)  // Fuzzy equality check
core::deg_to_rad(degrees)      // Convert degrees to radians
core::rad_to_deg(radians)      // Convert radians to degrees
```

### Trigonometry

```c++
trig::sin(x), trig::cos(x), trig::tan(x)           // Basic trig
trig::asin(x), trig::acos(x), trig::atan(x)        // Inverse trig
trig::atan2(y, x)                                    // Two-argument arctangent
trig::sinh(x), trig::cosh(x), trig::tanh(x)        // Hyperbolic
trig::asinh(x), trig::acosh(x), trig::atanh(x)     // Inverse hyperbolic
trig::cot(x), trig::sec(x), trig::csc(x)           // Extended trig
trig::haversine(x)                                   // Haversine
trig::normalize_angle(angle)                         // Normalize to [-pi, pi]
```

### Power & Exponential

```c++
power::sqrt(x)                // Square root
power::cbrt(x)                // Cube root
power::pow(base, exp)         // Power
power::powi(base, exp)        // Integer power (faster)
power::exp(x)                 // e^x
power::log(x)                 // Natural logarithm
power::log10(x)               // Base-10 logarithm
power::log2(x)                // Base-2 logarithm
power::logb(x, base)          // Arbitrary base logarithm
power::nthroot(x, n)          // Nth root
power::hypot(x, y)            // sqrt(x^2 + y^2) without overflow
```

### Power Operator ^ (mathlib::types)

C3 does not support operator overloading on primitive types. `mathlib::types`
provides `distinct` wrapper types that enable the `^` power operator — similar
to `**` in Fortran and Python.

```c++
// Scalar distinct types
Double x = (Double)2.0;
Double y = x ^ 3.0;           // 8.0  (exponent is plain double)

Float fx = (Float)3.0f;
Float fy = fx ^ 2.0f;         // 9.0  (exponent is plain float)

// Convert back to primitive
double raw = (double)y;
float  raw = (float)fy;

// Vec2, Vec3, Vec4 — element-wise power (exponent is plain double)
Vec3 v = vector::vec3(2.0, 3.0, 4.0);
Vec3 sq  = v ^ 2.0;           // (4.0, 9.0, 16.0)
Vec3 sqr = v ^ 0.5;           // element-wise square root

// Complex — full complex exponentiation: base ^ exp = e^(exp * ln(base))
Complex c1 = complex::complex_new(1.0, 1.0);
Complex c2 = complex::complex_new(2.0, 0.0);
Complex r  = c1 ^ c2;         // (1+i)^2 = 2i

// MatNM — element-wise power (covers arbitrary-length vectors as Nx1)
MatNM m  = matnm::matnm_new(3, 1);
MatNM sq = m ^ 2.0;           // square each element
matnm::matnm_free(&sq);
```

### Vectors (Vec2, Vec3, Vec4)

```c++
// Creation (module-level functions)
Vec2 v = vector::vec2(x, y);
Vec3 v = vector::vec3(x, y, z);
Vec4 v = vector::vec4(x, y, z, w);

// Operations (operator overloading)
v1 + v2                  // Addition
v1 - v2                  // Subtraction
v * scalar               // Scalar multiplication
v / scalar               // Scalar division
-v                       // Negation
v ^ exp                  // Element-wise power (exp is double)

// Member functions
v.length()               // Magnitude
v.length_squared()       // Magnitude squared (faster)
v.normalize()            // Normalize to unit vector
Vec3.dot(v1, v2)        // Dot product
Vec3.cross(v1, v2)      // Cross product (3D only)
Vec3.distance(v1, v2)   // Distance between vectors
Vec3.lerp(v1, v2, t)    // Linear interpolation
Vec3.reflect(v, normal) // Reflect vector
```

### Matrices (Mat2, Mat3, Mat4)

```c++
// Creation (module-level functions)
Mat2 m = matrix::mat2_identity();
Mat3 m = matrix::mat3_identity();
Mat4 m = matrix::mat4_identity();
Mat4 m = matrix::mat4_zero();

// Operations (operator overloading)
m1 + m2                  // Addition
m1 - m2                  // Subtraction
m1 * m2                  // Multiplication

// Transformations (module-level functions returning Mat4)
matrix::mat4_translate(Vec3)         // Translation matrix
matrix::mat4_rotate_x(angle)         // Rotation around X
matrix::mat4_rotate_y(angle)         // Rotation around Y
matrix::mat4_rotate_z(angle)         // Rotation around Z
matrix::mat4_scale_uniform(s)        // Uniform scale
matrix::mat4_scale_vec(Vec3)         // Non-uniform scale

// Projections (module-level functions)
matrix::mat4_perspective(fov, aspect, near, far)
matrix::mat4_ortho(l, r, b, t, n, f)
matrix::mat4_look_at(eye, center, up)

// Instance methods
m.transpose()            // Transpose
m.determinant()          // Determinant
m.transform(vector)      // Transform vector
m.inverse()              // Inverse (Mat2 only)
```

### Arbitrary NxM Matrices (MatNM)

```c++
// Creation (module-level functions)
MatNM m = matnm::matnm_new(rows, cols);       // Zero-initialized
MatNM m = matnm::matnm_identity(n);           // NxN identity
MatNM m = matnm::matnm_from_data(r, c, data); // From existing array

// Memory management
matnm::matnm_free(&m);              // Free MatNM heap memory
mem::free(slice);                    // Free double[] from get_row/get_col

// Element access (instance methods)
m.get(row, col)                      // Read element
m.set(row, col, val)                 // Write element
m.get_row(row)                       // Extract row as double[] (heap-allocated, caller must free)
m.get_col(col)                       // Extract column as double[] (heap-allocated, caller must free)

// Operations (operator overloading)
m1 + m2                              // Addition (same dimensions)
m1 - m2                              // Subtraction (same dimensions)
m1 * m2                              // Multiplication (NxM * MxP = NxP)
-m                                   // Negation
m ^ exp                              // Element-wise power (exp is double)

// Instance methods
m.scale(s)                           // Scalar multiply
m.transpose()                        // Transpose (returns MxN)
m.trace()                            // Sum of diagonal
m.determinant()                      // Via LU decomposition (square only)
m.inverse()                          // Via Gaussian elimination (square only)
m.frobenius_norm()                   // sqrt(sum of squares)
m.lu_decompose()                     // Returns LUResult {l, u, sign}
m.rank()                             // Via row echelon form
m.row_echelon()                      // Reduced row echelon form

// Solve linear system (module-level)
matnm::matnm_solve(a, b)            // Solve Ax = b

// Conversion (module-level)
matnm::matnm_from_mat2(mat2)        // Mat2 → MatNM
matnm::matnm_from_mat3(mat3)        // Mat3 → MatNM
matnm::matnm_from_mat4(mat4)        // Mat4 → MatNM
matnm::matnm_to_mat2(matnm)         // MatNM → Mat2
matnm::matnm_to_mat3(matnm)         // MatNM → Mat3
matnm::matnm_to_mat4(matnm)         // MatNM → Mat4
```

### Statistics

```c++
stats::mean(values[])          // Average
stats::median(values[])        // Median (modifies array)
stats::mode(values[])          // Mode
stats::variance(values[])      // Population variance
stats::sample_variance(vals[]) // Sample variance
stats::std_dev(values[])       // Standard deviation
stats::min_value(values[])     // Minimum
stats::max_value(values[])     // Maximum
stats::sum(values[])           // Sum
stats::product(values[])       // Product
stats::percentile(vals[], p)   // Percentile
stats::iqr(values[])           // Interquartile range
stats::covariance(x[], y[])    // Covariance
stats::correlation(x[], y[])   // Correlation coefficient
```

### Complex Numbers

```c++
// Creation (module-level functions)
Complex c = complex::complex_new(real, imag);
Complex c = complex::complex_from_polar(r, theta);

// Operations (operator overloading)
c1 + c2                  // Addition
c1 - c2                  // Subtraction
c1 * c2                  // Multiplication
c1 / c2                  // Division
-c                       // Negation
c1 ^ c2                  // Complex power: e^(c2 * ln(c1))

// Instance methods
c.conjugate()            // Complex conjugate
c.magnitude()            // Magnitude
c.phase()                // Phase angle

// Module-level functions
complex::complex_exp(c)           // e^c
complex::complex_log(c)           // ln(c)
complex::complex_pow(base, exp)   // Power
complex::complex_sqrt(c)          // Square root
complex::complex_sin(c)           // Sine
complex::complex_cos(c)           // Cosine
complex::complex_tan(c)           // Tangent
```

### Quaternions

```c++
// Creation (module-level functions)
Quaternion q = quaternion::quat_new(w, x, y, z);
Quaternion q = quaternion::quat_identity();
Quaternion q = quaternion::quat_from_axis_angle(axis, angle);
Quaternion q = quaternion::quat_from_euler(pitch, yaw, roll);

// Operations (operator overloading)
q1 + q2                  // Addition
q1 - q2                  // Subtraction
q1 * q2                  // Multiplication (Hamilton product)

// Instance methods
q.conjugate()            // Conjugate
q.magnitude()            // Magnitude
q.normalize()            // Normalize
q.inverse()              // Inverse
q.rotate(vector)         // Rotate a vector
q.to_axis_angle(&axis, &angle)  // Convert to axis-angle
q.to_euler(&pitch, &yaw, &roll) // Convert to Euler angles

// Module-level functions
Quaternion.dot(q1, q2)                  // Dot product
quaternion::quat_slerp(q1, q2, t)      // Spherical interpolation
```

## Common Patterns

### Solve a Linear System

```c++
MatNM a = matnm::matnm_new(3, 3);
// ... set matrix elements ...
MatNM b = matnm::matnm_new(3, 1);
// ... set right-hand side ...
MatNM x = matnm::matnm_solve(a, b);
// x is the solution vector
matnm::matnm_free(&a);
matnm::matnm_free(&b);
matnm::matnm_free(&x);
```

### Transform a Point in 3D

```c++
Vec3 point = vector::vec3(1.0, 2.0, 3.0);
Mat4 transform = matrix::mat4_translate(vector::vec3(5.0, 0.0, 0.0));
Vec4 homogeneous = vector::vec4(point.x, point.y, point.z, 1.0);
Vec4 result = transform.transform(&homogeneous);
```

### Rotate a Vector with Quaternion

```c++
Vec3 v = vector::vec3(1.0, 0.0, 0.0);
Vec3 axis = vector::vec3(0.0, 0.0, 1.0);
Quaternion q = quaternion::quat_from_axis_angle(axis, core::deg_to_rad(90.0));
Vec3 rotated = q.rotate(v);
```

### Calculate Statistics

```c++
double[] data = { 1.0, 2.0, 3.0, 4.0, 5.0 };
double avg = stats::mean(data);
double std = stats::std_dev(data);
```

### Smooth Interpolation

```c++
Vec3 start = vector::vec3(0.0, 0.0, 0.0);
Vec3 end = vector::vec3(10.0, 10.0, 10.0);
double t = 0.5; // 50% of the way
Vec3 interpolated = Vec3.lerp(start, end, t);
```

## Tips

1. **Angles**: Most functions expect radians. Use `core::deg_to_rad()` to convert.
2. **Performance**: Use `_squared()` variants when you don't need the actual length.
3. **Normalization**: Always check if a vector's length is > EPSILON before normalizing.
4. **Matrix Order**: Matrices are column-major (OpenGL convention).
5. **Quaternions**: Always normalize quaternions after interpolation or arithmetic.
6. **Statistics**: Some functions (median, percentile) modify the input array.
7. **Constructors**: Use module-level functions (e.g., `vector::vec3()`) not type methods.
8. **MatNM Memory**: Always call `matnm::matnm_free()` when done with MatNM instances to avoid memory leaks.
9. **MatNM Row/Col Slices**: `get_row()` and `get_col()` return heap-allocated `double[]` slices. Free them with `mem::free(slice)` when done.
10. **MatNM Storage**: Column-major layout, same as Mat2/3/4. Element at (row, col) is at `data[col * rows + row]`.
11. **Power Operator**: Use `Double`/`Float` from `mathlib::types` to write `x ^ exp` for scalars. For `Vec`, `Complex`, and `MatNM`, `^` is available directly on those types.
12. **Distinct Types**: `Double` and `Float` require explicit casts to/from their primitive counterparts: `(Double)2.0` and `(double)myDouble`.

## Error Handling

The library uses safe defaults:
- Division by near-zero returns identity/zero
- Normalization of zero vectors returns zero vector
- Invalid operations return sensible fallbacks

Always check critical calculations if needed:

```c++
if (v.length() > core::EPSILON) {
    Vec3 normalized = v.normalize();
    // Use normalized vector
}
```
