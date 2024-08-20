import vector.{type Vec}

pub type Ray {
  Ray(origin: Vec, direction: Vec)
}

pub fn at(ray, scale) {
  let Ray(origin, direction) = ray
  vector.add(origin, vector.scale(direction, scale))
}
