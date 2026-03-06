/**
 * @file test.c3
 * @brief Simple tests for the math library
 */

module test;

import mathlib::core;
import mathlib::vector;
import mathlib::matrix;
import mathlib::complex;
import std::io;

fn bool test_vector_operations()
{
    Vec3 v1 = Vec3.new(1.0, 0.0, 0.0);
    Vec3 v2 = Vec3.new(0.0, 1.0, 0.0);
    
    // Test cross product
    Vec3 cross = Vec3.cross(v1, v2);
    bool cross_ok = core::approx_equal(cross.x, 0.0) && 
                    core::approx_equal(cross.y, 0.0) && 
                    core::approx_equal(cross.z, 1.0);
    
    // Test normalization
    Vec3 v3 = Vec3.new(3.0, 4.0, 0.0);
    Vec3 normalized = v3.normalize();
    bool norm_ok = core::approx_equal(normalized.length(), 1.0);
    
    return cross_ok && norm_ok;
}

fn bool test_matrix_operations()
{
    Mat3 identity = Mat3.identity();
    double det = identity.determinant();
    
    bool det_ok = core::approx_equal(det, 1.0);
    
    // Test matrix multiplication with identity
    Mat3 m1 = Mat3.identity();
    Mat3 m2 = Mat3.identity();
    Mat3 result = m1.mul(m2);
    
    bool mul_ok = core::approx_equal(result.m[0], 1.0) && 
                  core::approx_equal(result.m[4], 1.0) && 
                  core::approx_equal(result.m[8], 1.0);
    
    return det_ok && mul_ok;
}

fn bool test_complex_operations()
{
    Complex c1 = Complex.new(1.0, 0.0);  // 1 + 0i
    Complex c2 = Complex.new(0.0, 1.0);  // 0 + 1i
    
    // Test i * i = -1
    Complex result = c2.mul(c2);
    bool mul_ok = core::approx_equal(result.real, -1.0) && 
                  core::approx_equal(result.imag, 0.0);
    
    // Test magnitude
    Complex c3 = Complex.new(3.0, 4.0);
    double mag = c3.magnitude();
    bool mag_ok = core::approx_equal(mag, 5.0);
    
    return mul_ok && mag_ok;
}

fn bool test_core_functions()
{
    // Test basic functions
    bool abs_ok = core::abs(-5.5) == 5.5;
    bool min_ok = core::min(3.0, 7.0) == 3.0;
    bool max_ok = core::max(3.0, 7.0) == 7.0;
    bool lerp_ok = core::approx_equal(core::lerp(0.0, 10.0, 0.5), 5.0);
    
    return abs_ok && min_ok && max_ok && lerp_ok;
}

fn void run_tests()
{
    io::printn("\n=== Running Math Library Tests ===\n");
    
    int passed = 0;
    int total = 0;
    
    // Test core functions
    total++;
    if (test_core_functions()) {
        io::printn("✓ Core functions test PASSED");
        passed++;
    } else {
        io::printn("✗ Core functions test FAILED");
    }
    
    // Test vectors
    total++;
    if (test_vector_operations()) {
        io::printn("✓ Vector operations test PASSED");
        passed++;
    } else {
        io::printn("✗ Vector operations test FAILED");
    }
    
    // Test matrices
    total++;
    if (test_matrix_operations()) {
        io::printn("✓ Matrix operations test PASSED");
        passed++;
    } else {
        io::printn("✗ Matrix operations test FAILED");
    }
    
    // Test complex numbers
    total++;
    if (test_complex_operations()) {
        io::printn("✓ Complex number test PASSED");
        passed++;
    } else {
        io::printn("✗ Complex number test FAILED");
    }
    
    io::printn("\n=================================");
    io::printfn("Tests passed: %d/%d", passed, total);
    io::printn("=================================\n");
}

fn void main()
{
    run_tests();
}
