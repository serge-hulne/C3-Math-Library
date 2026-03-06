/**
 * @file power.c3
 * @brief Power, exponential and logarithmic functions
 * @module mathlib::power
 */

module mathlib::power;

import mathlib::core;

/**
 * Power function (wrapper for libc)
 */
extern fn double pow(double base, double exponent);

/**
 * Square root (wrapper for libc)
 */
extern fn double sqrt(double x);

/**
 * Cube root (wrapper for libc)
 */
extern fn double cbrt(double x);

/**
 * Exponential function e^x (wrapper for libc)
 */
extern fn double exp(double x);

/**
 * Natural logarithm (wrapper for libc)
 */
extern fn double log(double x);

/**
 * Base-10 logarithm (wrapper for libc)
 */
extern fn double log10(double x);

/**
 * Base-2 logarithm (wrapper for libc)
 */
extern fn double log2(double x);

/**
 * exp(x) - 1, computed accurately for small x
 */
extern fn double expm1(double x);

/**
 * log(1 + x), computed accurately for small x
 */
extern fn double log1p(double x);

/**
 * Compute sqrt(x^2 + y^2) without overflow
 */
extern fn double hypot(double x, double y);

/**
 * Integer power function (more efficient for integer exponents)
 */
fn double powi(double base, int exponent)
{
    if (exponent == 0) return 1.0;
    
    double result = 1.0;
    double current_base = base;
    int abs_exp = exponent < 0 ? -exponent : exponent;
    
    while (abs_exp > 0) {
        if (abs_exp & 1) {
            result *= current_base;
        }
        current_base *= current_base;
        abs_exp >>= 1;
    }
    
    return exponent < 0 ? 1.0 / result : result;
}

/**
 * Logarithm with arbitrary base
 */
fn double logb(double x, double base)
{
    return log(x) / log(base);
}

/**
 * Nth root function
 */
fn double nthroot(double x, double n)
{
    return pow(x, 1.0 / n);
}

/**
 * Check if a number is a power of 2
 */
fn bool is_power_of_2(int x)
{
    return x > 0 && (x & (x - 1)) == 0;
}

/**
 * Next power of 2 (round up)
 */
fn int next_power_of_2(int x)
{
    if (x <= 1) return 1;
    x--;
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    return x + 1;
}

/**
 * Previous power of 2 (round down)
 */
fn int prev_power_of_2(int x)
{
    if (x <= 1) return 1;
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    return x - (x >> 1);
}
