/**
 * @file math_core.c3
 * @brief Core mathematical constants and basic functions
 * @module mathlib::core
 */

module mathlib::core;

// Mathematical constants
const double PI = 3.14159265358979323846;
const double E = 2.71828182845904523536;
const double SQRT2 = 1.41421356237309504880;
const double SQRT3 = 1.73205080756887729352;
const double GOLDEN_RATIO = 1.61803398874989484820;
const double EPSILON = 1e-10;

// Degree/Radian conversion
const double DEG_TO_RAD = PI / 180.0;
const double RAD_TO_DEG = 180.0 / PI;

/**
 * Convert degrees to radians
 */
fn double deg_to_rad(double degrees) @inline
{
    return degrees * DEG_TO_RAD;
}

/**
 * Convert radians to degrees
 */
fn double rad_to_deg(double radians) @inline
{
    return radians * RAD_TO_DEG;
}

/**
 * Absolute value for double
 */
fn double abs(double x) @inline
{
    return x < 0 ? -x : x;
}

/**
 * Absolute value for float
 */
fn float absf(float x) @inline
{
    return x < 0 ? -x : x;
}

/**
 * Absolute value for int
 */
fn int absi(int x) @inline
{
    return x < 0 ? -x : x;
}

/**
 * Minimum of two doubles
 */
fn double min(double a, double b) @inline
{
    return a < b ? a : b;
}

/**
 * Maximum of two doubles
 */
fn double max(double a, double b) @inline
{
    return a > b ? a : b;
}

/**
 * Clamp a value between min and max
 */
fn double clamp(double x, double min_val, double max_val) @inline
{
    return min(max(x, min_val), max_val);
}

/**
 * Sign function: returns -1, 0, or 1
 */
fn double sign(double x) @inline
{
    if (x > 0) return 1.0;
    if (x < 0) return -1.0;
    return 0.0;
}

/**
 * Square function
 */
fn double square(double x) @inline
{
    return x * x;
}

/**
 * Cube function
 */
fn double cube(double x) @inline
{
    return x * x * x;
}

/**
 * Check if two doubles are approximately equal
 */
fn bool approx_equal(double a, double b, double epsilon = EPSILON) @inline
{
    return abs(a - b) < epsilon;
}

/**
 * Linear interpolation
 */
fn double lerp(double a, double b, double t) @inline
{
    return a + t * (b - a);
}

/**
 * Map a value from one range to another
 */
fn double map_range(double value, double in_min, double in_max, double out_min, double out_max)
{
    return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

/**
 * Fast inverse square root (Quake III algorithm)
 * Good approximation for 1/sqrt(x)
 */
fn float fast_inv_sqrt(float number)
{
    int i;
    float x2, y;
    
    x2 = number * 0.5f;
    y = number;
    i = *(int*)&y;
    i = 0x5f3759df - (i >> 1);
    y = *(float*)&i;
    y = y * (1.5f - (x2 * y * y));
    
    return y;
}
