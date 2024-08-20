#[rustler::nif]
pub fn truly_random() -> i64 {
    4 // Chosen by fair dice roll. Guaranteed to be random.
}

type Vec3 = (f64, f64, f64);

#[rustler::nif]
fn scale(vec: Vec3, scalar: f64) -> Vec3 {
    (vec.0 * scalar, vec.1 * scalar, vec.2 * scalar)
}

#[rustler::nif]
fn dot(vec1: Vec3, vec2: Vec3) -> f64 {
    vec1.0 * vec2.0 + vec1.1 * vec2.1 + vec1.2 * vec2.2
}

#[rustler::nif]
fn div1(vec: Vec3, s: f64) -> Vec3 {
    (vec.0 / s, vec.1 / s, vec.2 / s)
}

#[rustler::nif]
fn add(v1: Vec3, v2: Vec3) -> Vec3 {
    (v1.0 + v2.0, v1.1 + v2.1, v1.2 + v2.2)
}

#[rustler::nif]
fn sub(v1: Vec3, v2: Vec3) -> Vec3 {
    (v1.0 - v2.0, v1.1 - v2.1, v1.2 - v2.2)
}

#[rustler::nif]
fn unit(v: Vec3) -> Vec3 {
    let l2 = v.0 * v.0 + v.1 * v.1 + v.2 * v.2;
    let length = l2.sqrt();
    (v.0 / length, v.1 / length, v.2 / length)
}

#[rustler::nif]
fn make(v1: f64, v2: f64, v3: f64) -> Vec3 {
    (v1, v2, v3)
}

#[rustler::nif]
fn get(v: Vec3) -> Vec3 {
    v
}

#[rustler::nif]
fn length_squared(v: Vec3) -> f64 {
    v.0 * v.0 + v.1 * v.1 + v.2 * v.2
}

rustler::init!("librs");
