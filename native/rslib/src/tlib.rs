#![feature(portable_simd)]

use std::{
    ops::Index,
    simd::{f64x4, num::SimdFloat, Simd},
    sync::Arc,
};

use rustler::{Resource, ResourceArc};

#[rustler::nif]
pub fn truly_random() -> i64 {
    4 // Chosen by fair dice roll. Guaranteed to be random.
}

struct Vec3(Simd<f64, 4>);

#[rustler::resource_impl]
impl Resource for Vec3 {}

#[rustler::nif]
fn scale(vec: ResourceArc<Vec3>, scalar: f64) -> ResourceArc<Vec3> {
    //(vec.0 * scalar, vec.1 * scalar, vec.2 * scalar)
    let scalar_simd = f64x4::splat(scalar);
    Vec3((vec.0 * scalar_simd).into()).into()
}

#[rustler::nif]
fn dot(vec1: ResourceArc<Vec3>, vec2: ResourceArc<Vec3>) -> f64 {
    dot1(vec1, vec2)
}

fn dot1(vec1: ResourceArc<Vec3>, vec2: ResourceArc<Vec3>) -> f64 {
    (vec1.0 * vec2.0).reduce_sum().into()
}

#[rustler::nif]
fn div1(vec: ResourceArc<Vec3>, s: f64) -> ResourceArc<Vec3> {
    Vec3((vec.0 / f64x4::splat(s)).into()).into()
}

#[rustler::nif]
fn add(v1: ResourceArc<Vec3>, v2: ResourceArc<Vec3>) -> ResourceArc<Vec3> {
    //(v1.0 + v2.0, v1.1 + v2.1, v1.2 + v2.2)
    Vec3((v1.0 + v2.0).into()).into()
}

#[rustler::nif]
fn sub(v1: ResourceArc<Vec3>, v2: ResourceArc<Vec3>) -> ResourceArc<Vec3> {
    //(v1.0 - v2.0, v1.1 - v2.1, v1.2 - v2.2)
    Vec3((v1.0 - v2.0).into()).into()
}

#[rustler::nif]
fn unit(v: ResourceArc<Vec3>) -> ResourceArc<Vec3> {
    //let l2 = v.0 * v.0 + v.1 * v.1 + v.2 * v.2;
    //let length = l2.sqrt();
    //(v.0 / length, v.1 / length, v.2 / length)
    let mag = dot1(v.clone(), v.clone());
    let length = mag.sqrt();
    let length_smd = f64x4::splat(length);
    Vec3((v.0 / length_smd).into()).into()
}

#[rustler::nif]
fn make(v1: f64, v2: f64, v3: f64) -> ResourceArc<Vec3> {
    let simd = f64x4::from_array([v1, v2, v3, 0.]);
    Vec3(simd.into()).into()
}

#[rustler::nif]
fn get(vec: ResourceArc<Vec3>) -> (f64, f64, f64) {
    (*vec.0.index(0), *vec.0.index(1), *vec.0.index(2))
}

fn get(vec: ResourceArc<Vec3>) -> (f64, f64, f64) {
    (*vec.0.index(0), *vec.0.index(1), *vec.0.index(2))
}

#[rustler::nif]
fn length_squared(v: ResourceArc<Vec3>) -> f64 {
    let (x, y, z) = get(v);
    x * x + y * y + z * z
}

rustler::init!("librs");
