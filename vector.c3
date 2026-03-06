/**
 * @file vector.c3
 * @brief Generic vector types and operations
 * @module mathlib::vector
 */

module mathlib::vector;

import mathlib::core;
import mathlib::power;

// 2D Vector
struct Vec2
{
    double x;
    double y;
}

// 3D Vector
struct Vec3
{
    double x;
    double y;
    double z;
}

// 4D Vector (useful for quaternions and homogeneous coordinates)
struct Vec4
{
    double x;
    double y;
    double z;
    double w;
}

// ============================================================================
// Vec2 Operations
// ============================================================================

fn Vec2 vec2(double x = 0, double y = 0)
{
    return (Vec2){  x, y };
}

fn Vec2 Vec2.add(Vec2 a, Vec2 b) @operator(+)
{
    return (Vec2){  a.x + b.x, a.y + b.y };
}

fn Vec2 Vec2.sub(Vec2 a, Vec2 b) @operator(-)
{
    return (Vec2){  a.x - b.x, a.y - b.y };
}

fn Vec2 Vec2.mul(Vec2 v, double scalar) @operator(*)
{
    return (Vec2){  v.x * scalar, v.y * scalar };
}

fn Vec2 Vec2.div(Vec2 v, double scalar) @operator(/)
{
    return (Vec2){  v.x / scalar, v.y / scalar };
}

fn Vec2 Vec2.neg(Vec2 v) @operator(-)
{
    return (Vec2){  -v.x, -v.y };
}

fn double Vec2.dot(Vec2 a, Vec2 b)
{
    return a.x * b.x + a.y * b.y;
}

fn double Vec2.length_squared(Vec2* v)
{
    return v.x * v.x + v.y * v.y;
}

fn double Vec2.length(Vec2* v)
{
    return power::sqrt(v.length_squared());
}

fn Vec2 Vec2.normalize(Vec2* v)
{
    double len = v.length();
    if (len < core::EPSILON) return (Vec2){  0, 0 };
    return (Vec2){  v.x / len, v.y / len };
}

fn double Vec2.distance(Vec2 a, Vec2 b)
{
    Vec2 diff = a.sub(b);
    return diff.length();
}

fn Vec2 Vec2.lerp(Vec2 a, Vec2 b, double t)
{
    return (Vec2){ 
        a.x + t * (b.x - a.x),
        a.y + t * (b.y - a.y)
    };
}

fn Vec2 Vec2.perpendicular(Vec2* v)
{
    return (Vec2){  -v.y, v.x };
}

fn double Vec2.cross(Vec2 a, Vec2 b)
{
    return a.x * b.y - a.y * b.x;
}

fn Vec2 Vec2.reflect(Vec2 v, Vec2 normal)
{
    double dot_product = Vec2.dot(v, normal);
    return (Vec2){
        v.x - 2.0 * dot_product * normal.x,
        v.y - 2.0 * dot_product * normal.y
    };
}

fn Vec2 Vec2.pow(Vec2 v, double exp) @operator(^)
{
    return (Vec2){ power::pow(v.x, exp), power::pow(v.y, exp) };
}

// ============================================================================
// Vec3 Operations
// ============================================================================

fn Vec3 vec3(double x = 0, double y = 0, double z = 0)
{
    return (Vec3){  x, y, z };
}

fn Vec3 Vec3.add(Vec3 a, Vec3 b) @operator(+)
{
    return (Vec3){  a.x + b.x, a.y + b.y, a.z + b.z };
}

fn Vec3 Vec3.sub(Vec3 a, Vec3 b) @operator(-)
{
    return (Vec3){  a.x - b.x, a.y - b.y, a.z - b.z };
}

fn Vec3 Vec3.mul(Vec3 v, double scalar) @operator(*)
{
    return (Vec3){  v.x * scalar, v.y * scalar, v.z * scalar };
}

fn Vec3 Vec3.div(Vec3 v, double scalar) @operator(/)
{
    return (Vec3){  v.x / scalar, v.y / scalar, v.z / scalar };
}

fn Vec3 Vec3.neg(Vec3 v) @operator(-)
{
    return (Vec3){  -v.x, -v.y, -v.z };
}

fn double Vec3.dot(Vec3 a, Vec3 b)
{
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

fn Vec3 Vec3.cross(Vec3 a, Vec3 b)
{
    return (Vec3){ 
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    };
}

fn double Vec3.length_squared(Vec3* v)
{
    return v.x * v.x + v.y * v.y + v.z * v.z;
}

fn double Vec3.length(Vec3* v)
{
    return power::sqrt(v.length_squared());
}

fn Vec3 Vec3.normalize(Vec3* v)
{
    double len = v.length();
    if (len < core::EPSILON) return (Vec3){  0, 0, 0 };
    return (Vec3){  v.x / len, v.y / len, v.z / len };
}

fn double Vec3.distance(Vec3 a, Vec3 b)
{
    Vec3 diff = a.sub(b);
    return diff.length();
}

fn Vec3 Vec3.lerp(Vec3 a, Vec3 b, double t)
{
    return (Vec3){ 
        a.x + t * (b.x - a.x),
        a.y + t * (b.y - a.y),
        a.z + t * (b.z - a.z)
    };
}

fn Vec3 Vec3.reflect(Vec3 v, Vec3 normal)
{
    double dot_product = Vec3.dot(v, normal);
    return (Vec3){
        v.x - 2.0 * dot_product * normal.x,
        v.y - 2.0 * dot_product * normal.y,
        v.z - 2.0 * dot_product * normal.z
    };
}

fn Vec3 Vec3.pow(Vec3 v, double exp) @operator(^)
{
    return (Vec3){ power::pow(v.x, exp), power::pow(v.y, exp), power::pow(v.z, exp) };
}

// ============================================================================
// Vec4 Operations
// ============================================================================

fn Vec4 vec4(double x = 0, double y = 0, double z = 0, double w = 0)
{
    return (Vec4){  x, y, z, w };
}

fn Vec4 Vec4.add(Vec4 a, Vec4 b) @operator(+)
{
    return (Vec4){  a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w };
}

fn Vec4 Vec4.sub(Vec4 a, Vec4 b) @operator(-)
{
    return (Vec4){  a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w };
}

fn Vec4 Vec4.mul(Vec4 v, double scalar) @operator(*)
{
    return (Vec4){  v.x * scalar, v.y * scalar, v.z * scalar, v.w * scalar };
}

fn Vec4 Vec4.div(Vec4 v, double scalar) @operator(/)
{
    return (Vec4){  v.x / scalar, v.y / scalar, v.z / scalar, v.w / scalar };
}

fn Vec4 Vec4.neg(Vec4 v) @operator(-)
{
    return (Vec4){  -v.x, -v.y, -v.z, -v.w };
}

fn double Vec4.dot(Vec4 a, Vec4 b)
{
    return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
}

fn double Vec4.length_squared(Vec4* v)
{
    return v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w;
}

fn double Vec4.length(Vec4* v)
{
    return power::sqrt(v.length_squared());
}

fn Vec4 Vec4.normalize(Vec4* v)
{
    double len = v.length();
    if (len < core::EPSILON) return (Vec4){  0, 0, 0, 0 };
    return (Vec4){  v.x / len, v.y / len, v.z / len, v.w / len };
}

fn Vec4 Vec4.lerp(Vec4 a, Vec4 b, double t)
{
    return (Vec4){
        a.x + t * (b.x - a.x),
        a.y + t * (b.y - a.y),
        a.z + t * (b.z - a.z),
        a.w + t * (b.w - a.w)
    };
}

fn Vec4 Vec4.pow(Vec4 v, double exp) @operator(^)
{
    return (Vec4){ power::pow(v.x, exp), power::pow(v.y, exp), power::pow(v.z, exp), power::pow(v.w, exp) };
}
