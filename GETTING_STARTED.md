# C3 Math Library - Overview

## What You've Got

A complete mathematics library for C3 (version 0.7+) with 9 modules covering:

### Library Modules

1. **math_core.c3** - Foundation
   - Mathematical constants (pi, e, phi, etc.)
   - Basic operations (abs, min, max, clamp, sign)
   - Interpolation and range mapping
   - Fast inverse square root

2. **trig.c3** - Trigonometry
   - All standard trig functions
   - Inverse and hyperbolic functions
   - Angle normalization
   - Special functions (haversine, versine, etc.)

3. **power.c3** - Exponentials & Powers
   - Power functions (including optimized integer powers)
   - Roots (square, cube, nth)
   - Exponentials and logarithms
   - Utilities for powers of 2

4. **types.c3** - Scalar Types with Power Operator
   - `distinct Double = double` and `distinct Float = float`
   - `^` power operator (analogous to `**` in Fortran/Python)
   - Explicit cast to/from primitives required

5. **vector.c3** - Vector Math
   - Vec2, Vec3, Vec4 types
   - Full operator overloading (+, -, *, /, ^)
   - Element-wise power: `v ^ exp`
   - Dot and cross products
   - Length, normalization, distance
   - Reflection and interpolation

6. **matrix.c3** - Matrix Operations
   - Mat2, Mat3, Mat4 types (column-major)
   - Matrix arithmetic with operators
   - 3D transformations (translate, rotate, scale)
   - Camera matrices (perspective, ortho, look-at)
   - Transpose and determinant

7. **matnm.c3** - Arbitrary NxM Matrices
   - Heap-allocated MatNM type (column-major)
   - Element access, row/column extraction
   - Arithmetic with operator overloading (+, -, *, ^)
   - Element-wise power: `m ^ exp` (works for Nx1 vectors too)
   - Transpose, trace, determinant, inverse, Frobenius norm
   - LU decomposition, row echelon form, rank
   - Linear system solver (Ax = b)
   - Conversion to/from Mat2, Mat3, Mat4

8. **statistics.c3** - Statistical Analysis
   - Mean, median, mode
   - Variance and standard deviation
   - Percentiles and IQR
   - Correlation and covariance

9. **complex.c3** - Complex Numbers
   - Full complex arithmetic (+, -, *, /, ^)
   - Complex power: `c1 ^ c2` computes `e^(c2 * ln(c1))`
   - Polar coordinates
   - Complex transcendental functions
   - Magnitude and phase

10. **quaternion.c3** - 3D Rotations
   - Quaternion algebra
   - Axis-angle and Euler conversions
   - SLERP (smooth rotation interpolation)
   - Vector rotation

### Documentation Files

- **README.md** - Comprehensive guide with examples
- **QUICK_REFERENCE.md** - Function lookup and syntax
- **example.c3** - Complete working examples
- **project.json** - Build configuration

## Getting Started

### Step 1: Add to Your Project

Copy the `.c3` files to your C3 project directory.

### Step 2: Import What You Need

```c++
module myapp;

import mathlib::vector;
import mathlib::matrix;
import mathlib::matnm;
import mathlib::core;

fn void main() {
    // Your code here
}
```

### Step 3: Use the Library

```c++
// Create and manipulate vectors
Vec3 position = vector::vec3(0.0, 5.0, 10.0);
Vec3 velocity = vector::vec3(1.0, 0.0, 0.0);
Vec3 new_position = position + velocity;

// Build transformation matrices
Mat4 model = matrix::mat4_translate(position);
Mat4 view = matrix::mat4_look_at(
    vector::vec3(0, 0, 5),    // eye
    vector::vec3(0, 0, 0),    // center
    vector::vec3(0, 1, 0)     // up
);

// Use quaternions for smooth rotations
Quaternion q1 = quaternion::quat_identity();
Quaternion q2 = quaternion::quat_from_euler(0, core::PI, 0);
Quaternion smooth = quaternion::quat_slerp(q1, q2, 0.5);
```

## Key Features

### Modern C3 Features

- **Operator Overloading**: Natural math syntax including `^` for power
  ```c++
  Vec3 result = v1 + v2 * 3.0;
  Vec3 sq     = v1 ^ 2.0;          // element-wise squaring
  Mat4 transform = translate * rotate * scale;

  Double x = (Double)2.0;
  Double y = x ^ 10.0;             // 1024.0 — like ** in Fortran/Python
  ```

- **Member Functions**: Dot notation support
  ```c++
  double len = vector.length();
  ```

- **Default Arguments**: Convenient calls
  ```c++
  Vec3 v = vector::vec3();  // Defaults to (0, 0, 0)
  ```

### Practical Design

- **Safe Defaults**: No crashes on edge cases
- **Consistent API**: Similar patterns across modules
- **Performance**: Inlined hot paths, optimized algorithms
- **Documentation**: Extensive comments and examples

## Common Use Cases

### Game Development
```c++
// Character movement
Vec3 position = player.position;
Vec3 forward = vector::vec3(0, 0, 1);
Quaternion rotation = quaternion::quat_from_euler(0, player.yaw, 0);
Vec3 move_direction = rotation.rotate(forward);
position = position + move_direction.mul(speed * dt);
```

### 3D Graphics
```c++
// Setup view-projection matrix
Mat4 projection = matrix::mat4_perspective(
    core::deg_to_rad(45.0),  // FOV
    16.0 / 9.0,              // Aspect ratio
    0.1, 100.0               // Near, far
);
Mat4 view = matrix::mat4_look_at(camera_pos, target_pos, up_vector);
Mat4 vp = projection * view;
```

### Physics Simulation
```c++
// Calculate trajectory
Vec3 velocity = initial_velocity;
Vec3 gravity = vector::vec3(0, -9.81, 0);
velocity = velocity + gravity.mul(dt);
position = position + velocity.mul(dt);
```

### Linear Algebra with Arbitrary Matrices
```c++
// Create and solve a linear system Ax = b
MatNM a = matnm::matnm_new(3, 3);
a.set(0, 0, 2.0); a.set(0, 1, 1.0); a.set(0, 2, -1.0);
a.set(1, 0, -3.0); a.set(1, 1, -1.0); a.set(1, 2, 2.0);
a.set(2, 0, -2.0); a.set(2, 1, 1.0); a.set(2, 2, 2.0);

MatNM b = matnm::matnm_new(3, 1);
b.set(0, 0, 8.0); b.set(1, 0, -11.0); b.set(2, 0, -3.0);

MatNM x = matnm::matnm_solve(a, b);
// x contains the solution vector

// Row/column extraction also allocates — free with mem::free()
double[] row = a.get_row(0);
// ... use row ...
mem::free(row);

// Don't forget to free MatNM heap memory
matnm::matnm_free(&a);
matnm::matnm_free(&b);
matnm::matnm_free(&x);
```

### Data Analysis
```c++
// Statistical analysis
double[] measurements = get_sensor_data();
double avg = stats::mean(measurements);
double std = stats::std_dev(measurements);
double q95 = stats::percentile(measurements, 95.0);
```

## Building and Testing

### Run the Example
```bash
c3c build mathlib_example
./out/mathlib_example
```

### Build as Library
```bash
c3c build
```

## Performance Tips

1. **Use squared functions**: `v.length_squared()` is faster than `v.length()` when you only need comparison
2. **Integer powers**: `power::powi(x, n)` is much faster than `power::pow(x, n)` for integer exponents
3. **Batch operations**: Transform multiple vectors with the same matrix in a loop
4. **Inline hints**: Functions marked `@inline` help the compiler optimize

## What's Included

```
c3_math_lib/
├── math_core.c3          - Core functions
├── trig.c3               - Trigonometry
├── power.c3              - Powers & exponentials
├── types.c3              - Distinct Float/Double with ^ power operator
├── vector.c3             - Vector types (^ element-wise power)
├── matrix.c3             - Fixed-size matrix types (Mat2/3/4)
├── matnm.c3              - Arbitrary NxM matrices (^ element-wise power)
├── statistics.c3         - Statistics
├── complex.c3            - Complex numbers (^ complex power)
├── quaternion.c3         - Quaternions
├── example.c3            - Working examples
├── README.md             - Full documentation
├── QUICK_REFERENCE.md    - Quick lookup
├── GETTING_STARTED.md    - This file
└── project.json          - Build config
```

## Next Steps

1. **Read the examples**: Check `example.c3` for working code
2. **Check the reference**: Use `QUICK_REFERENCE.md` for quick lookup
3. **Integrate**: Import modules as needed in your project

## Need Help?

- See **README.md** for detailed documentation
- Check **QUICK_REFERENCE.md** for function signatures
- Study **example.c3** for usage patterns

## License & Credits

This library is provided as-is for C3 development. Feel free to use, modify, and extend it for your projects.

Built for C3 version 0.7 and later, leveraging modern C3 features like operator overloading, member functions, and the module system.
