/**
 * @file complex.c3
 * @brief Complex number operations
 * @module mathlib::complex
 */

module mathlib::complex;

import mathlib::core;
import mathlib::power;
import mathlib::trig;

/**
 * Complex number structure
 */
struct Complex
{
    double real;
    double imag;
}

/**
 * Create a new complex number
 */
fn Complex complex_new(double real = 0, double imag = 0)
{
    return (Complex){  real, imag };
}

/**
 * Create complex from polar coordinates
 */
fn Complex complex_from_polar(double r, double theta)
{
    return (Complex){ 
        r * trig::cos(theta),
        r * trig::sin(theta)
    };
}

/**
 * Addition of complex numbers
 */
fn Complex Complex.add(Complex a, Complex b) @operator(+)
{
    return (Complex){ 
        a.real + b.real,
        a.imag + b.imag
    };
}

/**
 * Subtraction of complex numbers
 */
fn Complex Complex.sub(Complex a, Complex b) @operator(-)
{
    return (Complex){ 
        a.real - b.real,
        a.imag - b.imag
    };
}

/**
 * Multiplication of complex numbers
 */
fn Complex Complex.mul(Complex a, Complex b) @operator(*)
{
    return (Complex){ 
        a.real * b.real - a.imag * b.imag,
        a.real * b.imag + a.imag * b.real
    };
}

/**
 * Division of complex numbers
 */
fn Complex Complex.div(Complex a, Complex b) @operator(/)
{
    double denom = b.real * b.real + b.imag * b.imag;
    if (denom < core::EPSILON) {
        return (Complex){  0, 0 }; // Avoid division by zero
    }

    return (Complex){ 
        (a.real * b.real + a.imag * b.imag) / denom,
        (a.imag * b.real - a.real * b.imag) / denom
    };
}

/**
 * Negation of complex number
 */
fn Complex Complex.neg(Complex c) @operator(-)
{
    return (Complex){  -c.real, -c.imag };
}

/**
 * Complex conjugate
 */
fn Complex Complex.conjugate(Complex* c)
{
    return (Complex){  c.real, -c.imag };
}

/**
 * Magnitude (absolute value) of complex number
 */
fn double Complex.magnitude(Complex* c)
{
    return power::sqrt(c.real * c.real + c.imag * c.imag);
}

/**
 * Magnitude squared (more efficient than magnitude)
 */
fn double Complex.magnitude_squared(Complex* c)
{
    return c.real * c.real + c.imag * c.imag;
}

/**
 * Phase angle (argument) of complex number
 */
fn double Complex.phase(Complex* c)
{
    return trig::atan2(c.imag, c.real);
}

/**
 * Complex exponential e^(a+bi)
 */
fn Complex complex_exp(Complex c)
{
    double exp_real = power::exp(c.real);
    return (Complex){ 
        exp_real * trig::cos(c.imag),
        exp_real * trig::sin(c.imag)
    };
}

/**
 * Natural logarithm of complex number
 */
fn Complex complex_log(Complex c)
{
    return (Complex){ 
        power::log(c.magnitude()),
        c.phase()
    };
}

/**
 * Complex power function
 */
fn Complex complex_pow(Complex base, Complex exponent)
{
    // Using formula: a^b = e^(b * ln(a))
    Complex ln_base = complex_log(base);
    Complex product = ln_base.mul(exponent);
    return complex_exp(product);
}

/**
 * Complex square root
 */
fn Complex complex_sqrt(Complex c)
{
    double r = c.magnitude();
    double theta = c.phase();

    return complex_from_polar(power::sqrt(r), theta / 2.0);
}

/**
 * Complex sine
 */
fn Complex complex_sin(Complex c)
{
    return (Complex){ 
        trig::sin(c.real) * trig::cosh(c.imag),
        trig::cos(c.real) * trig::sinh(c.imag)
    };
}

/**
 * Complex cosine
 */
fn Complex complex_cos(Complex c)
{
    return (Complex){ 
        trig::cos(c.real) * trig::cosh(c.imag),
        -trig::sin(c.real) * trig::sinh(c.imag)
    };
}

/**
 * Complex tangent
 */
fn Complex complex_tan(Complex c)
{
    return complex_sin(c).div(complex_cos(c));
}

/**
 * Check if two complex numbers are approximately equal
 */
fn bool Complex.approx_equal(Complex a, Complex b, double epsilon = core::EPSILON)
{
    return core::approx_equal(a.real, b.real, epsilon)
        && core::approx_equal(a.imag, b.imag, epsilon);
}

/**
 * Check if complex number is real (imaginary part is zero)
 */
fn bool Complex.is_real(Complex* c)
{
    return core::abs(c.imag) < core::EPSILON;
}

/**
 * Check if complex number is imaginary (real part is zero)
 */
fn bool Complex.is_imaginary(Complex* c)
{
    return core::abs(c.real) < core::EPSILON;
}

/**
 * Complex power operator: base ^ exp  (uses e^(exp * ln(base)))
 */
fn Complex Complex.pow(Complex base, Complex exp) @operator(^)
{
    return complex_pow(base, exp);
}

/**
 * Scalar multiplication
 */
fn Complex Complex.scale(Complex c, double scalar)
{
    return (Complex){
        c.real * scalar,
        c.imag * scalar
    };
}
