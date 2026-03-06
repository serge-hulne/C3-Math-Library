/**
 * @file example.c3
 * @brief Example usage of the mathlib library
 */

module example;

import mathlib::core;
import mathlib::trig;
import mathlib::power;
import mathlib::types;
import mathlib::vector;
import mathlib::matrix;
import mathlib::stats;
import mathlib::complex;
import mathlib::quaternion;
import mathlib::matnm;
import std::io;

fn void demonstrate_core_functions()
{
    io::printn("\n=== Core Functions ===");

    // Constants
    io::printfn("PI = %.10f", core::PI);
    io::printfn("E = %.10f", core::E);

    // Basic operations
    io::printfn("abs(-5.5) = %.2f", core::abs(-5.5));
    io::printfn("min(3.0, 7.0) = %.2f", core::min(3.0, 7.0));
    io::printfn("max(3.0, 7.0) = %.2f", core::max(3.0, 7.0));
    io::printfn("clamp(15.0, 0.0, 10.0) = %.2f", core::clamp(15.0, 0.0, 10.0));

    // Interpolation
    io::printfn("lerp(0.0, 10.0, 0.5) = %.2f", core::lerp(0.0, 10.0, 0.5));
}

fn void demonstrate_trigonometry()
{
    io::printn("\n=== Trigonometry ===");

    double angle_deg = 45.0;
    double angle_rad = core::deg_to_rad(angle_deg);

    io::printfn("sin(45°) = %.6f", trig::sin(angle_rad));
    io::printfn("cos(45°) = %.6f", trig::cos(angle_rad));
    io::printfn("tan(45°) = %.6f", trig::tan(angle_rad));

    // Arc functions
    io::printfn("asin(0.5) = %.6f rad", trig::asin(0.5));
    io::printfn("atan2(1, 1) = %.6f rad", trig::atan2(1.0, 1.0));
}

fn void demonstrate_power_functions()
{
    io::printn("\n=== Power & Exponential Functions ===");

    io::printfn("sqrt(16) = %.2f", power::sqrt(16.0));
    io::printfn("cbrt(27) = %.2f", power::cbrt(27.0));
    io::printfn("pow(2, 8) = %.0f", power::pow(2.0, 8.0));
    io::printfn("powi(2, 10) = %.0f", power::powi(2.0, 10));

    io::printfn("exp(1) = %.6f", power::exp(1.0));
    io::printfn("log(e) = %.6f", power::log(core::E));
    io::printfn("log10(100) = %.2f", power::log10(100.0));
}

fn void demonstrate_vectors()
{
    io::printn("\n=== Vector Operations ===");

    Vec3 v1 = vector::vec3(1.0, 2.0, 3.0);
    Vec3 v2 = vector::vec3(4.0, 5.0, 6.0);

    Vec3 sum = v1.add(v2);
    io::printfn("v1 + v2 = (%.1f, %.1f, %.1f)", sum.x, sum.y, sum.z);

    double dot = Vec3.dot(v1, v2);
    io::printfn("v1 · v2 = %.1f", dot);

    Vec3 cross = Vec3.cross(v1, v2);
    io::printfn("v1 × v2 = (%.1f, %.1f, %.1f)", cross.x, cross.y, cross.z);

    double len = v1.length();
    io::printfn("|v1| = %.6f", len);

    Vec3 normalized = v1.normalize();
    io::printfn("normalize(v1) = (%.6f, %.6f, %.6f)",
                normalized.x, normalized.y, normalized.z);
}

fn void demonstrate_matrices()
{
    io::printn("\n=== Matrix Operations ===");

    Mat3 m1 = matrix::mat3_identity();
    io::printn("Identity Matrix 3x3 created");

    Mat4 translate = matrix::mat4_translate(vector::vec3(5.0, 10.0, 15.0));
    io::printn("Translation matrix created");

    Mat4 rotate = matrix::mat4_rotate_z(core::deg_to_rad(45.0));
    io::printn("Rotation matrix (45° around Z) created");

    Mat4 scale = matrix::mat4_scale_uniform(2.0);
    io::printn("Scale matrix (2x) created");

    // Matrix multiplication
    Mat4 combined = translate.mul(rotate).mul(scale);
    io::printn("Combined transformation matrix created");
}

fn void demonstrate_statistics()
{
    io::printn("\n=== Statistics ===");

    double[] data = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };

    io::printfn("Mean = %.2f", stats::mean(data));
    io::printfn("Median = %.2f", stats::median(data));
    io::printfn("Std Dev = %.6f", stats::std_dev(data));
    io::printfn("Variance = %.6f", stats::variance(data));
    io::printfn("Min = %.2f", stats::min_value(data));
    io::printfn("Max = %.2f", stats::max_value(data));
    io::printfn("Sum = %.2f", stats::sum(data));
}

fn void demonstrate_complex()
{
    io::printn("\n=== Complex Numbers ===");

    Complex c1 = complex::complex_new(3.0, 4.0);
    Complex c2 = complex::complex_new(1.0, 2.0);

    io::printfn("c1 = %.1f + %.1fi", c1.real, c1.imag);
    io::printfn("c2 = %.1f + %.1fi", c2.real, c2.imag);

    Complex sum = c1.add(c2);
    io::printfn("c1 + c2 = %.1f + %.1fi", sum.real, sum.imag);

    Complex product = c1.mul(c2);
    io::printfn("c1 * c2 = %.1f + %.1fi", product.real, product.imag);

    double mag = c1.magnitude();
    io::printfn("|c1| = %.6f", mag);

    double phase = c1.phase();
    io::printfn("arg(c1) = %.6f rad", phase);
}

fn void demonstrate_quaternions()
{
    io::printn("\n=== Quaternions ===");

    // Create a rotation quaternion: 90 degrees around Z-axis
    Vec3 axis = vector::vec3(0.0, 0.0, 1.0);
    double angle = core::deg_to_rad(90.0);
    Quaternion q = quaternion::quat_from_axis_angle(axis, angle);

    io::printfn("Quaternion (90° around Z): w=%.6f, x=%.6f, y=%.6f, z=%.6f",
                q.w, q.x, q.y, q.z);

    // Rotate a vector
    Vec3 v = vector::vec3(1.0, 0.0, 0.0);
    Vec3 rotated = q.rotate(v);

    io::printfn("Original vector: (%.1f, %.1f, %.1f)", v.x, v.y, v.z);
    io::printfn("Rotated vector: (%.6f, %.6f, %.6f)",
                rotated.x, rotated.y, rotated.z);

    // SLERP example
    Quaternion q1 = quaternion::quat_identity();
    Quaternion q2 = quaternion::quat_from_axis_angle(vector::vec3(0.0, 1.0, 0.0),
                                               core::deg_to_rad(180.0));
    Quaternion interpolated = quaternion::quat_slerp(q1, q2, 0.5);

    io::printfn("SLERP at t=0.5: w=%.6f, x=%.6f, y=%.6f, z=%.6f",
                interpolated.w, interpolated.x, interpolated.y, interpolated.z);
}

fn void demonstrate_power_operator()
{
    io::printn("\n=== Power Operator (^) ===");

    // Double scalar type
    Double dx = (Double)2.0;
    Double dy = dx ^ 3.0;    // 2^3 = 8
    io::printfn("Double: 2.0 ^ 3.0 = %.1f", (double)dy);

    Double dbase = (Double)10.0;
    Double dhalf = dbase ^ 0.5;  // sqrt(10)
    io::printfn("Double: 10.0 ^ 0.5 = %.6f", (double)dhalf);

    // Float scalar type
    Float fx = (Float)3.0f;
    Float fy = fx ^ 2.0f;   // 3^2 = 9
    io::printfn("Float: 3.0 ^ 2.0 = %.1f", (double)(float)fy);

    // Vec2 element-wise power
    Vec2 v2 = vector::vec2(2.0, 3.0);
    Vec2 v2_sq = v2 ^ 2.0;
    io::printfn("Vec2 ^ 2: (%.1f, %.1f)", v2_sq.x, v2_sq.y);

    // Vec3 element-wise power
    Vec3 v3 = vector::vec3(2.0, 3.0, 4.0);
    Vec3 v3_sq = v3 ^ 2.0;
    io::printfn("Vec3 ^ 2: (%.1f, %.1f, %.1f)", v3_sq.x, v3_sq.y, v3_sq.z);

    Vec3 v3_half = v3 ^ 0.5;  // element-wise sqrt
    io::printfn("Vec3 ^ 0.5: (%.6f, %.6f, %.6f)", v3_half.x, v3_half.y, v3_half.z);

    // Vec4 element-wise power
    Vec4 v4 = vector::vec4(1.0, 2.0, 3.0, 4.0);
    Vec4 v4_cb = v4 ^ 3.0;
    io::printfn("Vec4 ^ 3: (%.1f, %.1f, %.1f, %.1f)", v4_cb.x, v4_cb.y, v4_cb.z, v4_cb.w);

    // Complex power: (1+i)^2 = 2i
    Complex c1 = complex::complex_new(1.0, 1.0);
    Complex c2 = complex::complex_new(2.0, 0.0);
    Complex cpow = c1 ^ c2;
    io::printfn("(1+i)^2 = %.6f + %.6fi", cpow.real, cpow.imag);

    // Complex power: i^i = e^(-pi/2)
    Complex ci = complex::complex_new(0.0, 1.0);
    Complex cpow2 = ci ^ ci;
    io::printfn("i^i = %.6f + %.6fi", cpow2.real, cpow2.imag);

    // MatNM element-wise power (arbitrary-length vectors as Nx1)
    MatNM m = matnm::matnm_new(2, 2);
    m.set(0, 0, 2.0); m.set(0, 1, 3.0);
    m.set(1, 0, 4.0); m.set(1, 1, 5.0);
    MatNM m_sq = m ^ 2.0;
    io::printn("MatNM ^ 2:");
    io::printfn("  [%.1f, %.1f]", m_sq.get(0, 0), m_sq.get(0, 1));
    io::printfn("  [%.1f, %.1f]", m_sq.get(1, 0), m_sq.get(1, 1));

    // Arbitrary-length vector (5x1) using MatNM
    MatNM vec5 = matnm::matnm_new(5, 1);
    vec5.set(0, 0, 1.0); vec5.set(1, 0, 2.0); vec5.set(2, 0, 3.0);
    vec5.set(3, 0, 4.0); vec5.set(4, 0, 5.0);
    MatNM vec5_sq = vec5 ^ 2.0;
    io::printfn("5-vector ^ 2: [%.0f, %.0f, %.0f, %.0f, %.0f]",
        vec5_sq.get(0, 0), vec5_sq.get(1, 0), vec5_sq.get(2, 0),
        vec5_sq.get(3, 0), vec5_sq.get(4, 0));

    matnm::matnm_free(&m);
    matnm::matnm_free(&m_sq);
    matnm::matnm_free(&vec5);
    matnm::matnm_free(&vec5_sq);
}

fn void demonstrate_matnm()
{
    io::printn("\n=== Arbitrary NxM Matrix Operations ===");

    // Creation
    MatNM m1 = matnm::matnm_new(3, 3);
    m1.set(0, 0, 1.0); m1.set(0, 1, 2.0); m1.set(0, 2, 3.0);
    m1.set(1, 0, 0.0); m1.set(1, 1, 4.0); m1.set(1, 2, 5.0);
    m1.set(2, 0, 1.0); m1.set(2, 1, 0.0); m1.set(2, 2, 6.0);
    io::printn("Created 3x3 matrix m1:");
    io::printfn("  [%.1f, %.1f, %.1f]", m1.get(0, 0), m1.get(0, 1), m1.get(0, 2));
    io::printfn("  [%.1f, %.1f, %.1f]", m1.get(1, 0), m1.get(1, 1), m1.get(1, 2));
    io::printfn("  [%.1f, %.1f, %.1f]", m1.get(2, 0), m1.get(2, 1), m1.get(2, 2));

    // Identity
    MatNM id3 = matnm::matnm_identity(3);
    io::printn("Created 3x3 identity matrix");

    // Addition
    MatNM sum_m = MatNM.add(m1, id3);
    io::printn("m1 + I =");
    io::printfn("  [%.1f, %.1f, %.1f]", sum_m.get(0, 0), sum_m.get(0, 1), sum_m.get(0, 2));
    io::printfn("  [%.1f, %.1f, %.1f]", sum_m.get(1, 0), sum_m.get(1, 1), sum_m.get(1, 2));
    io::printfn("  [%.1f, %.1f, %.1f]", sum_m.get(2, 0), sum_m.get(2, 1), sum_m.get(2, 2));

    // Multiplication
    MatNM prod = MatNM.mul(m1, id3);
    io::printn("m1 * I = m1 (verified)");

    // Transpose
    MatNM mt = m1.transpose();
    io::printn("Transpose of m1:");
    io::printfn("  [%.1f, %.1f, %.1f]", mt.get(0, 0), mt.get(0, 1), mt.get(0, 2));
    io::printfn("  [%.1f, %.1f, %.1f]", mt.get(1, 0), mt.get(1, 1), mt.get(1, 2));
    io::printfn("  [%.1f, %.1f, %.1f]", mt.get(2, 0), mt.get(2, 1), mt.get(2, 2));

    // Row and column extraction (heap-allocated, must be freed)
    double[] row0 = m1.get_row(0);
    io::printfn("Row 0 of m1: [%.1f, %.1f, %.1f]", row0[0], row0[1], row0[2]);
    double[] col1 = m1.get_col(1);
    io::printfn("Col 1 of m1: [%.1f, %.1f, %.1f]", col1[0], col1[1], col1[2]);
    // Free the extracted row/column slices (they are heap-allocated)
    mem::free(row0);
    mem::free(col1);

    // Trace
    double tr = m1.trace();
    io::printfn("Trace of m1 = %.1f", tr);

    // Determinant
    double det = m1.determinant();
    io::printfn("Determinant of m1 = %.6f", det);

    // Frobenius norm
    double fnorm = m1.frobenius_norm();
    io::printfn("Frobenius norm of m1 = %.6f", fnorm);

    // Inverse
    MatNM inv = m1.inverse();
    io::printn("Inverse of m1:");
    io::printfn("  [%.6f, %.6f, %.6f]", inv.get(0, 0), inv.get(0, 1), inv.get(0, 2));
    io::printfn("  [%.6f, %.6f, %.6f]", inv.get(1, 0), inv.get(1, 1), inv.get(1, 2));
    io::printfn("  [%.6f, %.6f, %.6f]", inv.get(2, 0), inv.get(2, 1), inv.get(2, 2));

    // Verify: m1 * inv should be identity
    MatNM check = MatNM.mul(m1, inv);
    io::printn("m1 * inv(m1) (should be identity):");
    io::printfn("  [%.6f, %.6f, %.6f]", check.get(0, 0), check.get(0, 1), check.get(0, 2));
    io::printfn("  [%.6f, %.6f, %.6f]", check.get(1, 0), check.get(1, 1), check.get(1, 2));
    io::printfn("  [%.6f, %.6f, %.6f]", check.get(2, 0), check.get(2, 1), check.get(2, 2));

    // LU Decomposition
    LUResult lu = m1.lu_decompose();
    io::printn("LU Decomposition of m1:");
    io::printn("  L:");
    io::printfn("    [%.6f, %.6f, %.6f]", lu.l.get(0, 0), lu.l.get(0, 1), lu.l.get(0, 2));
    io::printfn("    [%.6f, %.6f, %.6f]", lu.l.get(1, 0), lu.l.get(1, 1), lu.l.get(1, 2));
    io::printfn("    [%.6f, %.6f, %.6f]", lu.l.get(2, 0), lu.l.get(2, 1), lu.l.get(2, 2));
    io::printn("  U:");
    io::printfn("    [%.6f, %.6f, %.6f]", lu.u.get(0, 0), lu.u.get(0, 1), lu.u.get(0, 2));
    io::printfn("    [%.6f, %.6f, %.6f]", lu.u.get(1, 0), lu.u.get(1, 1), lu.u.get(1, 2));
    io::printfn("    [%.6f, %.6f, %.6f]", lu.u.get(2, 0), lu.u.get(2, 1), lu.u.get(2, 2));

    // Rank
    usz rank = m1.rank();
    io::printfn("Rank of m1 = %d", (int)rank);

    // Non-square matrix operations
    MatNM rect = matnm::matnm_new(2, 3);
    rect.set(0, 0, 1.0); rect.set(0, 1, 2.0); rect.set(0, 2, 3.0);
    rect.set(1, 0, 4.0); rect.set(1, 1, 5.0); rect.set(1, 2, 6.0);
    io::printn("2x3 rectangular matrix:");
    io::printfn("  [%.1f, %.1f, %.1f]", rect.get(0, 0), rect.get(0, 1), rect.get(0, 2));
    io::printfn("  [%.1f, %.1f, %.1f]", rect.get(1, 0), rect.get(1, 1), rect.get(1, 2));
    usz rect_rank = rect.rank();
    io::printfn("Rank of 2x3 matrix = %d", (int)rect_rank);

    // Conversion from Mat4
    Mat4 mat4id = matrix::mat4_identity();
    MatNM from_mat4 = matnm::matnm_from_mat4(mat4id);
    io::printn("Converted Mat4 identity to MatNM:");
    io::printfn("  Rows=%d, Cols=%d, trace=%.1f", (int)from_mat4.rows, (int)from_mat4.cols, from_mat4.trace());

    // Convert back to Mat4
    Mat4 back = matnm::matnm_to_mat4(from_mat4);
    io::printn("Converted back to Mat4 successfully");

    // Solve Ax = b
    MatNM b_vec = matnm::matnm_new(3, 1);
    b_vec.set(0, 0, 1.0);
    b_vec.set(1, 0, 2.0);
    b_vec.set(2, 0, 3.0);
    MatNM x = matnm::matnm_solve(m1, b_vec);
    io::printn("Solve m1 * x = [1, 2, 3]^T:");
    io::printfn("  x = [%.6f, %.6f, %.6f]^T", x.get(0, 0), x.get(1, 0), x.get(2, 0));

    // Clean up
    matnm::matnm_free(&m1);
    matnm::matnm_free(&id3);
    matnm::matnm_free(&sum_m);
    matnm::matnm_free(&prod);
    matnm::matnm_free(&mt);
    matnm::matnm_free(&inv);
    matnm::matnm_free(&check);
    matnm::matnm_free(&lu.l);
    matnm::matnm_free(&lu.u);
    matnm::matnm_free(&rect);
    matnm::matnm_free(&from_mat4);
    matnm::matnm_free(&b_vec);
    matnm::matnm_free(&x);
}

fn void main()
{
    io::printn("===============================================");
    io::printn("  C3 Math Library - Feature Demonstration");
    io::printn("===============================================");

    demonstrate_core_functions();
    demonstrate_trigonometry();
    demonstrate_power_functions();
    demonstrate_power_operator();
    demonstrate_vectors();
    demonstrate_matrices();
    demonstrate_statistics();
    demonstrate_complex();
    demonstrate_quaternions();
    demonstrate_matnm();

    io::printn("\n===============================================");
    io::printn("  All demonstrations completed!");
    io::printn("===============================================");
}
