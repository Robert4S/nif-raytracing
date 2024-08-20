pub type Vec

@external(erlang, "librs", "scale")
pub fn scale(v: Vec, s: Float) -> Vec

@external(erlang, "librs", "div1")
pub fn div(v: Vec, s: Float) -> Vec

@external(erlang, "librs", "dot")
pub fn dot(v: Vec, s: Vec) -> Float

@external(erlang, "librs", "add")
pub fn add(v: Vec, s: Vec) -> Vec

@external(erlang, "librs", "sub")
pub fn sub(v: Vec, s: Vec) -> Vec

@external(erlang, "librs", "unit")
pub fn unit(v: Vec) -> Vec

@external(erlang, "librs", "make")
pub fn make(a: Float, b: Float, c: Float) -> Vec

@external(erlang, "librs", "get")
pub fn get(vec: Vec) -> #(Float, Float, Float)

@external(erlang, "librs", "length_squared")
pub fn length_squared(vec: Vec) -> Float
