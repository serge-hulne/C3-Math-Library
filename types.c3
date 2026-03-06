/**
 * @file types.c3
 * @brief Distinct scalar types with power operator (^) support
 * @module mathlib::types
 *
 * Defines Float and Double as distinct types wrapping the built-in float and
 * double, enabling use of the ^ operator for exponentiation — similar to the
 * ** operator in Fortran and Python.
 *
 * Usage:
 *   Double x = (Double)2.0;
 *   Double y = x ^ 3.0;    // 8.0
 *
 *   Float fx = (Float)3.0f;
 *   Float fy = fx ^ 2.0f;  // 9.0
 *
 * Conversion:
 *   double raw = (double)x;
 *   float  raw = (float)fx;
 */

module mathlib::types;

import mathlib::power;

// ============================================================================
// Distinct scalar types
// ============================================================================

/** 64-bit floating-point scalar with ^ power operator */
distinct Double = double;

/** 32-bit floating-point scalar with ^ power operator */
distinct Float = float;

// ============================================================================
// Double — power operator
// ============================================================================

/**
 * Power operator for Double: base ^ exp
 * The exponent is a plain double, so literals work naturally: x ^ 2.0
 */
fn Double Double.pow(Double base, double exp) @operator(^)
{
    return (Double)power::pow((double)base, exp);
}

// ============================================================================
// Float — power operator
// ============================================================================

/**
 * Power operator for Float: base ^ exp
 * The exponent is a plain float, so literals work naturally: x ^ 2.0f
 */
fn Float Float.pow(Float base, float exp) @operator(^)
{
    return (Float)(float)power::pow((double)base, (double)exp);
}
