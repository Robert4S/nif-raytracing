import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/option
import pixel.{type Pixel}
import ray
import vector

pub type Image {
  Image(pixels: List(List(Pixel)))
}

@external(erlang, "erlang", "list_to_binary")
fn list_to_binary(data: List(Int)) -> BitArray

pub fn print(image) {
  let Image(pixels) = image

  pixels
  |> list.map(fn(subarr) {
    subarr
    |> list.map(pixel.print)
    |> list.fold("", fn(a, b) { a <> " " <> b })
  })
  |> list.fold("", fn(acc, item) { acc <> "\n" <> item })
}

pub fn to_bitarrays(image: Image) {
  image.pixels
  |> list.map(fn(b) {
    b
    |> list.flat_map(fn(a) {
      let pixel.Pixel(r, g, b) = a
      [r, g, b]
    })
    |> list_to_binary
  })
  //|> list.map(fn(subl) {
  //  subl
  //  |> list.map(fn(pix) {
  //    let #(r, g, b) = pixel.to_tuple(pix)
  //    <<r, g, b>>
  //  })
  //  |> list.fold(<<>>, fn(acc, item) { bit_array.append(acc, item) })
  //})
}

pub fn createf(width, height, f) {
  list.range(0, height - 1)
  |> list.map(fn(row) {
    list.range(0, width - 1)
    |> list.map(fn(a) { f(row, a) })
  })
  |> list.map(list.map(_, pixel.to_pixel))
  |> Image
}

pub fn raytraced_image(w) {
  let aspect_ratio = 16.0 /. 9.0
  let image_width = w
  let image_height =
    int.to_float(image_width) /. aspect_ratio
    |> float.floor
    |> float.round

  // Camera
  let viewport_height = 2.0
  let viewport_width =
    viewport_height
    *. { int.to_float(image_width) /. int.to_float(image_height) }

  let focal_length = 1.0
  let camera_center = vector.make(0.0, 0.0, 0.0)

  // Helper vectors from left to right of viewport and up and down
  let viewport_lr = vector.make(viewport_width, 0.0, 0.0)
  let viewport_td = vector.make(0.0, float.negate(viewport_height), 0.0)

  // Deltas
  let pixel_delta_lr = vector.div(viewport_lr, int.to_float(image_width))
  let pixel_delta_td = vector.div(viewport_td, int.to_float(image_height))

  // Locations
  let center_vec = camera_center

  let top_left =
    center_vec
    |> vector.sub(vector.make(0.0, 0.0, focal_length))
    |> vector.sub(vector.div(viewport_lr, 2.0))
    |> vector.sub(vector.div(viewport_td, 2.0))

  let pixel0 =
    top_left
    |> vector.add(vector.scale(vector.add(pixel_delta_lr, pixel_delta_td), 0.5))

  let render = fn(row, col) {
    pixel0
    |> vector.add(vector.scale(pixel_delta_lr, col |> int.to_float))
    |> vector.add(vector.scale(pixel_delta_td, row |> int.to_float))
    |> vector.sub(center_vec)
    |> ray.Ray(origin: camera_center, direction: _)
    |> ray_colour
  }

  createf(image_width, image_height, render)
}

fn hits_sphere(center, radius, ray) {
  let ray.Ray(origin, direction) = ray
  let origin_to_center = vector.sub(center, origin)
  let a = vector.length_squared(direction)
  let h = vector.dot(direction, origin_to_center)
  let c = vector.length_squared(origin_to_center) -. { radius *. radius }
  let discriminant = h *. h -. a *. c

  case discriminant {
    n if n <. 0.0 -> option.None
    _ -> {
      let assert Ok(sqrt) = float.square_root(discriminant)
      option.Some({ h -. sqrt } /. a)
    }
  }
}

fn ray_colour(r: ray.Ray) {
  let res = hits_sphere(vector.make(0.0, 0.0, -1.0), 0.5, r)

  let return = fn() {
    let assert option.Some(res) = res
    let n: vector.Vec =
      vector.unit(
        r
        |> ray.at(res),
      )
      |> vector.sub(vector.make(0.0, 0.0, -1.0))
    vector.scale(vector.add(n, vector.make(1.0, 1.0, 1.0)), 0.5)
  }

  use <- bool.lazy_guard(res |> option.is_some, return)

  let #(_, y, _) = vector.unit(r.direction) |> vector.get
  let blend_factor = 0.5 *. { y +. 1.0 }

  vector.make(1.0, 1.0, 1.0)
  |> vector.scale(1.0 -. blend_factor)
  |> vector.add(vector.scale(vector.make(0.5, 0.7, 1.0), blend_factor))
}
