/**
 * @file matrix.c3
 * @brief Matrix types and operations
 * @module mathlib::matrix
 */

module mathlib::matrix;

import mathlib::core;
import mathlib::vector;
import mathlib::power;
import mathlib::trig;

// 2x2 Matrix (column-major order)
struct Mat2
{
    double[4] m;
}

// 3x3 Matrix (column-major order)
struct Mat3
{
    double[9] m;
}

// 4x4 Matrix (column-major order)
struct Mat4
{
    double[16] m;
}

// ============================================================================
// Mat2 Operations
// ============================================================================

fn Mat2 mat2_identity()
{
    return { { 1, 0, 0, 1 } };
}

fn Mat2 mat2_zero()
{
    return { { 0, 0, 0, 0 } };
}

fn Mat2 mat2_new(double m00, double m01, double m10, double m11)
{
    return { { m00, m10, m01, m11 } };
}

fn Mat2 Mat2.add(Mat2 a, Mat2 b) @operator(+)
{
    Mat2 result;
    for (int i = 0; i < 4; i++) {
        result.m[i] = a.m[i] + b.m[i];
    }
    return result;
}

fn Mat2 Mat2.sub(Mat2 a, Mat2 b) @operator(-)
{
    Mat2 result;
    for (int i = 0; i < 4; i++) {
        result.m[i] = a.m[i] - b.m[i];
    }
    return result;
}

fn Mat2 Mat2.mul(Mat2 a, Mat2 b) @operator(*)
{
    return { {
        a.m[0] * b.m[0] + a.m[2] * b.m[1],
        a.m[1] * b.m[0] + a.m[3] * b.m[1],
        a.m[0] * b.m[2] + a.m[2] * b.m[3],
        a.m[1] * b.m[2] + a.m[3] * b.m[3]
    } };
}

fn Mat2 Mat2.scale(Mat2 m, double s)
{
    Mat2 result;
    for (int i = 0; i < 4; i++) {
        result.m[i] = m.m[i] * s;
    }
    return result;
}

fn double Mat2.determinant(Mat2* m)
{
    return m.m[0] * m.m[3] - m.m[1] * m.m[2];
}

fn Mat2 Mat2.transpose(Mat2* m)
{
    return { {
        m.m[0], m.m[2],
        m.m[1], m.m[3]
    } };
}

fn Mat2 Mat2.inverse(Mat2* m)
{
    double det = m.determinant();
    if (core::abs(det) < core::EPSILON) {
        return mat2_identity();
    }

    double inv_det = 1.0 / det;
    return { {
        m.m[3] * inv_det, -m.m[1] * inv_det,
        -m.m[2] * inv_det, m.m[0] * inv_det
    } };
}

fn Vec2 Mat2.transform(Mat2* m, Vec2 v)
{
    return (Vec2){ 
        m.m[0] * v.x + m.m[2] * v.y,
        m.m[1] * v.x + m.m[3] * v.y
    };
}

// ============================================================================
// Mat3 Operations
// ============================================================================

fn Mat3 mat3_identity()
{
    return { {
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
    } };
}

fn Mat3 mat3_zero()
{
    return { { 0, 0, 0, 0, 0, 0, 0, 0, 0 } };
}

fn Mat3 Mat3.add(Mat3 a, Mat3 b) @operator(+)
{
    Mat3 result;
    for (int i = 0; i < 9; i++) {
        result.m[i] = a.m[i] + b.m[i];
    }
    return result;
}

fn Mat3 Mat3.sub(Mat3 a, Mat3 b) @operator(-)
{
    Mat3 result;
    for (int i = 0; i < 9; i++) {
        result.m[i] = a.m[i] - b.m[i];
    }
    return result;
}

fn Mat3 Mat3.mul(Mat3 a, Mat3 b) @operator(*)
{
    Mat3 result;
    for (int col = 0; col < 3; col++) {
        for (int row = 0; row < 3; row++) {
            double sum = 0;
            for (int k = 0; k < 3; k++) {
                sum += a.m[k * 3 + row] * b.m[col * 3 + k];
            }
            result.m[col * 3 + row] = sum;
        }
    }
    return result;
}

fn Mat3 Mat3.scale(Mat3 m, double s)
{
    Mat3 result;
    for (int i = 0; i < 9; i++) {
        result.m[i] = m.m[i] * s;
    }
    return result;
}

fn double Mat3.determinant(Mat3* m)
{
    return m.m[0] * (m.m[4] * m.m[8] - m.m[5] * m.m[7])
         - m.m[3] * (m.m[1] * m.m[8] - m.m[2] * m.m[7])
         + m.m[6] * (m.m[1] * m.m[5] - m.m[2] * m.m[4]);
}

fn Mat3 Mat3.transpose(Mat3* m)
{
    return { {
        m.m[0], m.m[3], m.m[6],
        m.m[1], m.m[4], m.m[7],
        m.m[2], m.m[5], m.m[8]
    } };
}

fn Vec3 Mat3.transform(Mat3* m, Vec3 v)
{
    return (Vec3){ 
        m.m[0] * v.x + m.m[3] * v.y + m.m[6] * v.z,
        m.m[1] * v.x + m.m[4] * v.y + m.m[7] * v.z,
        m.m[2] * v.x + m.m[5] * v.y + m.m[8] * v.z
    };
}

fn Mat3 mat3_rotation(double angle, Vec3 axis)
{
    double c = trig::cos(angle);
    double s = trig::sin(angle);
    double t = 1.0 - c;

    Vec3 n = axis.normalize();

    return { {
        t * n.x * n.x + c,
        t * n.x * n.y + s * n.z,
        t * n.x * n.z - s * n.y,

        t * n.x * n.y - s * n.z,
        t * n.y * n.y + c,
        t * n.y * n.z + s * n.x,

        t * n.x * n.z + s * n.y,
        t * n.y * n.z - s * n.x,
        t * n.z * n.z + c
    } };
}

// ============================================================================
// Mat4 Operations
// ============================================================================

fn Mat4 mat4_identity()
{
    return { {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    } };
}

fn Mat4 mat4_zero()
{
    Mat4 result;
    for (int i = 0; i < 16; i++) {
        result.m[i] = 0;
    }
    return result;
}

fn Mat4 Mat4.add(Mat4 a, Mat4 b) @operator(+)
{
    Mat4 result;
    for (int i = 0; i < 16; i++) {
        result.m[i] = a.m[i] + b.m[i];
    }
    return result;
}

fn Mat4 Mat4.sub(Mat4 a, Mat4 b) @operator(-)
{
    Mat4 result;
    for (int i = 0; i < 16; i++) {
        result.m[i] = a.m[i] - b.m[i];
    }
    return result;
}

fn Mat4 Mat4.mul(Mat4 a, Mat4 b) @operator(*)
{
    Mat4 result;
    for (int col = 0; col < 4; col++) {
        for (int row = 0; row < 4; row++) {
            double sum = 0;
            for (int k = 0; k < 4; k++) {
                sum += a.m[k * 4 + row] * b.m[col * 4 + k];
            }
            result.m[col * 4 + row] = sum;
        }
    }
    return result;
}

fn Mat4 mat4_scale_uniform(double s)
{
    return { {
        s, 0, 0, 0,
        0, s, 0, 0,
        0, 0, s, 0,
        0, 0, 0, 1
    } };
}

fn Mat4 mat4_scale_vec(Vec3 s)
{
    return { {
        s.x, 0, 0, 0,
        0, s.y, 0, 0,
        0, 0, s.z, 0,
        0, 0, 0, 1
    } };
}

fn Mat4 mat4_translate(Vec3 t)
{
    return { {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        t.x, t.y, t.z, 1
    } };
}

fn Mat4 mat4_rotate_x(double angle)
{
    double c = trig::cos(angle);
    double s = trig::sin(angle);
    return { {
        1, 0, 0, 0,
        0, c, s, 0,
        0, -s, c, 0,
        0, 0, 0, 1
    } };
}

fn Mat4 mat4_rotate_y(double angle)
{
    double c = trig::cos(angle);
    double s = trig::sin(angle);
    return { {
        c, 0, -s, 0,
        0, 1, 0, 0,
        s, 0, c, 0,
        0, 0, 0, 1
    } };
}

fn Mat4 mat4_rotate_z(double angle)
{
    double c = trig::cos(angle);
    double s = trig::sin(angle);
    return { {
        c, s, 0, 0,
        -s, c, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    } };
}

fn Mat4 Mat4.transpose(Mat4* m)
{
    Mat4 result;
    for (int col = 0; col < 4; col++) {
        for (int row = 0; row < 4; row++) {
            result.m[row * 4 + col] = m.m[col * 4 + row];
        }
    }
    return result;
}

fn Vec4 Mat4.transform(Mat4* m, Vec4 v)
{
    return (Vec4){ 
        m.m[0] * v.x + m.m[4] * v.y + m.m[8] * v.z + m.m[12] * v.w,
        m.m[1] * v.x + m.m[5] * v.y + m.m[9] * v.z + m.m[13] * v.w,
        m.m[2] * v.x + m.m[6] * v.y + m.m[10] * v.z + m.m[14] * v.w,
        m.m[3] * v.x + m.m[7] * v.y + m.m[11] * v.z + m.m[15] * v.w
    };
}

fn Mat4 mat4_perspective(double fov, double aspect, double near, double far)
{
    double tan_half_fov = trig::tan(fov / 2.0);

    Mat4 result = mat4_zero();
    result.m[0] = 1.0 / (aspect * tan_half_fov);
    result.m[5] = 1.0 / tan_half_fov;
    result.m[10] = -(far + near) / (far - near);
    result.m[11] = -1.0;
    result.m[14] = -(2.0 * far * near) / (far - near);

    return result;
}

fn Mat4 mat4_ortho(double left, double right, double bottom, double top, double near, double far)
{
    Mat4 result = mat4_identity();
    result.m[0] = 2.0 / (right - left);
    result.m[5] = 2.0 / (top - bottom);
    result.m[10] = -2.0 / (far - near);
    result.m[12] = -(right + left) / (right - left);
    result.m[13] = -(top + bottom) / (top - bottom);
    result.m[14] = -(far + near) / (far - near);

    return result;
}

fn Mat4 mat4_look_at(Vec3 eye, Vec3 center, Vec3 up)
{
    Vec3 f = Vec3.sub(center, eye).normalize();
    Vec3 s = Vec3.cross(f, up).normalize();
    Vec3 u = Vec3.cross(s, f);

    Mat4 result = mat4_identity();
    result.m[0] = s.x;
    result.m[4] = s.y;
    result.m[8] = s.z;
    result.m[1] = u.x;
    result.m[5] = u.y;
    result.m[9] = u.z;
    result.m[2] = -f.x;
    result.m[6] = -f.y;
    result.m[10] = -f.z;
    result.m[12] = -Vec3.dot(s, eye);
    result.m[13] = -Vec3.dot(u, eye);
    result.m[14] = Vec3.dot(f, eye);

    return result;
}
