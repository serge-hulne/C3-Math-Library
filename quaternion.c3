/**
 * @file quaternion.c3
 * @brief Quaternion operations for 3D rotations
 * @module mathlib::quaternion
 */

module mathlib::quaternion;

import mathlib::core;
import mathlib::vector;
import mathlib::power;
import mathlib::trig;

/**
 * Quaternion structure (w + xi + yj + zk)
 */
struct Quaternion
{
    double w;  // Real part
    double x;  // i component
    double y;  // j component
    double z;  // k component
}

/**
 * Create a new quaternion
 */
fn Quaternion quat_new(double w = 1, double x = 0, double y = 0, double z = 0)
{
    return (Quaternion){  w, x, y, z };
}

/**
 * Create identity quaternion
 */
fn Quaternion quat_identity()
{
    return (Quaternion){  1, 0, 0, 0 };
}

/**
 * Create quaternion from axis and angle
 */
fn Quaternion quat_from_axis_angle(Vec3 axis, double angle)
{
    Vec3 normalized = axis.normalize();
    double half_angle = angle / 2.0;
    double s = trig::sin(half_angle);

    return (Quaternion){ 
        trig::cos(half_angle),
        normalized.x * s,
        normalized.y * s,
        normalized.z * s
    };
}

/**
 * Create quaternion from Euler angles (pitch, yaw, roll)
 */
fn Quaternion quat_from_euler(double pitch, double yaw, double roll)
{
    double cy = trig::cos(yaw * 0.5);
    double sy = trig::sin(yaw * 0.5);
    double cp = trig::cos(pitch * 0.5);
    double sp = trig::sin(pitch * 0.5);
    double cr = trig::cos(roll * 0.5);
    double sr = trig::sin(roll * 0.5);

    return (Quaternion){ 
        cr * cp * cy + sr * sp * sy,
        sr * cp * cy - cr * sp * sy,
        cr * sp * cy + sr * cp * sy,
        cr * cp * sy - sr * sp * cy
    };
}

/**
 * Addition of quaternions
 */
fn Quaternion Quaternion.add(Quaternion a, Quaternion b) @operator(+)
{
    return (Quaternion){ 
        a.w + b.w,
        a.x + b.x,
        a.y + b.y,
        a.z + b.z
    };
}

/**
 * Subtraction of quaternions
 */
fn Quaternion Quaternion.sub(Quaternion a, Quaternion b) @operator(-)
{
    return (Quaternion){ 
        a.w - b.w,
        a.x - b.x,
        a.y - b.y,
        a.z - b.z
    };
}

/**
 * Quaternion multiplication (Hamilton product)
 */
fn Quaternion Quaternion.mul(Quaternion a, Quaternion b) @operator(*)
{
    return (Quaternion){ 
        a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,
        a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
        a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
        a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w
    };
}

/**
 * Scalar multiplication
 */
fn Quaternion Quaternion.scale(Quaternion q, double s)
{
    return (Quaternion){ 
        q.w * s,
        q.x * s,
        q.y * s,
        q.z * s
    };
}

/**
 * Conjugate of quaternion
 */
fn Quaternion Quaternion.conjugate(Quaternion* q)
{
    return (Quaternion){  q.w, -q.x, -q.y, -q.z };
}

/**
 * Magnitude (norm) of quaternion
 */
fn double Quaternion.magnitude(Quaternion* q)
{
    return power::sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z);
}

/**
 * Magnitude squared
 */
fn double Quaternion.magnitude_squared(Quaternion* q)
{
    return q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z;
}

/**
 * Normalize quaternion
 */
fn Quaternion Quaternion.normalize(Quaternion* q)
{
    double mag = q.magnitude();
    if (mag < core::EPSILON) {
        return quat_identity();
    }

    return (Quaternion){ 
        q.w / mag,
        q.x / mag,
        q.y / mag,
        q.z / mag
    };
}

/**
 * Inverse of quaternion
 */
fn Quaternion Quaternion.inverse(Quaternion* q)
{
    double mag_sq = q.magnitude_squared();
    if (mag_sq < core::EPSILON) {
        return quat_identity();
    }

    Quaternion conj = q.conjugate();
    return (Quaternion){ 
        conj.w / mag_sq,
        conj.x / mag_sq,
        conj.y / mag_sq,
        conj.z / mag_sq
    };
}

/**
 * Dot product of quaternions
 */
fn double Quaternion.dot(Quaternion a, Quaternion b)
{
    return a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
}

/**
 * Spherical linear interpolation (SLERP)
 */
fn Quaternion quat_slerp(Quaternion a, Quaternion b, double t)
{
    Quaternion norm_a = a.normalize();
    Quaternion norm_b = b.normalize();

    double dot = Quaternion.dot(norm_a, norm_b);

    // If the dot product is negative, slerp won't take the shorter path
    if (dot < 0.0) {
        norm_b = (Quaternion){ 
            -norm_b.w, -norm_b.x, -norm_b.y, -norm_b.z
        };
        dot = -dot;
    }

    // If quaternions are very close, use linear interpolation
    if (dot > 0.9995) {
        Quaternion result = (Quaternion){ 
            norm_a.w + t * (norm_b.w - norm_a.w),
            norm_a.x + t * (norm_b.x - norm_a.x),
            norm_a.y + t * (norm_b.y - norm_a.y),
            norm_a.z + t * (norm_b.z - norm_a.z)
        };
        return result.normalize();
    }

    double theta_0 = trig::acos(dot);
    double theta = theta_0 * t;
    double sin_theta = trig::sin(theta);
    double sin_theta_0 = trig::sin(theta_0);

    double s0 = trig::cos(theta) - dot * sin_theta / sin_theta_0;
    double s1 = sin_theta / sin_theta_0;

    return (Quaternion){ 
        s0 * norm_a.w + s1 * norm_b.w,
        s0 * norm_a.x + s1 * norm_b.x,
        s0 * norm_a.y + s1 * norm_b.y,
        s0 * norm_a.z + s1 * norm_b.z
    };
}

/**
 * Rotate a vector by a quaternion
 */
fn Vec3 Quaternion.rotate(Quaternion* q, Vec3 v)
{
    Vec3 qvec = (Vec3){  q.x, q.y, q.z };
    Vec3 cross1 = Vec3.cross(qvec, v);
    Vec3 scaled_v = v.mul(q.w);
    Vec3 sum = Vec3.add(cross1, scaled_v);
    Vec3 cross2 = Vec3.cross(qvec, sum);
    Vec3 result = Vec3.add(v, cross2.mul(2.0));

    return result;
}

/**
 * Convert quaternion to axis-angle representation
 */
fn void Quaternion.to_axis_angle(Quaternion* q, Vec3* axis, double* angle)
{
    Quaternion norm = q.normalize();

    *angle = 2.0 * trig::acos(norm.w);
    double s = power::sqrt(1.0 - norm.w * norm.w);

    if (s < core::EPSILON) {
        *axis = (Vec3){  1, 0, 0 };
    } else {
        *axis = (Vec3){ 
            norm.x / s,
            norm.y / s,
            norm.z / s
        };
    }
}

/**
 * Get Euler angles from quaternion (pitch, yaw, roll)
 */
fn void Quaternion.to_euler(Quaternion* q, double* pitch, double* yaw, double* roll)
{
    // Roll (x-axis rotation)
    double sinr_cosp = 2.0 * (q.w * q.x + q.y * q.z);
    double cosr_cosp = 1.0 - 2.0 * (q.x * q.x + q.y * q.y);
    *roll = trig::atan2(sinr_cosp, cosr_cosp);

    // Pitch (y-axis rotation)
    double sinp = 2.0 * (q.w * q.y - q.z * q.x);
    if (core::abs(sinp) >= 1.0) {
        *pitch = core::sign(sinp) * core::PI / 2.0;
    } else {
        *pitch = trig::asin(sinp);
    }

    // Yaw (z-axis rotation)
    double siny_cosp = 2.0 * (q.w * q.z + q.x * q.y);
    double cosy_cosp = 1.0 - 2.0 * (q.y * q.y + q.z * q.z);
    *yaw = trig::atan2(siny_cosp, cosy_cosp);
}
