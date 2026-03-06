/**
 * @file trig.c3
 * @brief Trigonometric functions
 * @module mathlib::trig
 */

module mathlib::trig;

import mathlib::core;
import std::math;

/**
 * Sine function (wrapper for libc)
 */
extern fn double sin(double x);

/**
 * Cosine function (wrapper for libc)
 */
extern fn double cos(double x);

/**
 * Tangent function (wrapper for libc)
 */
extern fn double tan(double x);

/**
 * Arc sine function
 */
extern fn double asin(double x);

/**
 * Arc cosine function
 */
extern fn double acos(double x);

/**
 * Arc tangent function
 */
extern fn double atan(double x);

/**
 * Two-argument arc tangent function
 */
extern fn double atan2(double y, double x);

/**
 * Hyperbolic sine
 */
extern fn double sinh(double x);

/**
 * Hyperbolic cosine
 */
extern fn double cosh(double x);

/**
 * Hyperbolic tangent
 */
extern fn double tanh(double x);

/**
 * Inverse hyperbolic sine
 */
extern fn double asinh(double x);

/**
 * Inverse hyperbolic cosine
 */
extern fn double acosh(double x);

/**
 * Inverse hyperbolic tangent
 */
extern fn double atanh(double x);

/**
 * Compute both sine and cosine efficiently
 */
fn void sincos(double x, double* sin_out, double* cos_out)
{
    *sin_out = sin(x);
    *cos_out = cos(x);
}

/**
 * Cotangent function
 */
fn double cot(double x) @inline
{
    return 1.0 / tan(x);
}

/**
 * Secant function
 */
fn double sec(double x) @inline
{
    return 1.0 / cos(x);
}

/**
 * Cosecant function
 */
fn double csc(double x) @inline
{
    return 1.0 / sin(x);
}

/**
 * Haversine function - useful for geographic calculations
 */
fn double haversine(double x)
{
    double s = sin(x / 2.0);
    return s * s;
}

/**
 * Versine function
 */
fn double versin(double x)
{
    return 1.0 - cos(x);
}

/**
 * Coversine function
 */
fn double coversin(double x)
{
    return 1.0 - sin(x);
}

/**
 * Normalize angle to [-PI, PI]
 */
fn double normalize_angle(double angle)
{
    while (angle > core::PI) angle -= 2.0 * core::PI;
    while (angle < -core::PI) angle += 2.0 * core::PI;
    return angle;
}

/**
 * Normalize angle to [0, 2*PI]
 */
fn double normalize_angle_positive(double angle)
{
    while (angle >= 2.0 * core::PI) angle -= 2.0 * core::PI;
    while (angle < 0.0) angle += 2.0 * core::PI;
    return angle;
}
