import gleam/float
import gleam/string
import vector

pub type Pixel {
  Pixel(r: Int, g: Int, b: Int)
}

pub fn pixel(r, g, b) {
  //let max = r |> int.max(g) |> int.max(b)

  //case max {
  //  n if n > 255 -> {
  //    let message =
  //      "RGB values must be 0-255, I got " <> string.inspect(#(r, g, b))
  //    panic as message
  //  }
  //  _ -> Nil
  //}

  Pixel(r, g, b)
}

pub fn to_tuple(pixel) {
  let Pixel(r, g, b) = pixel
  #(r, g, b)
}

pub fn to_pixel(v) {
  let #(r, g, b) = vector.scale(v, 255.0) |> vector.get
  let r = r |> float.floor |> float.round
  //|> int.clamp(0, 255)
  let g = g |> float.floor |> float.round
  //|> int.clamp(0, 255)
  let b = b |> float.floor |> float.round
  //|> int.clamp(0, 255)

  pixel(r, g, b)
}

pub fn print(pixel) {
  let Pixel(r, g, b) = pixel
  let r = string.inspect(r) |> adjust
  let g = string.inspect(g) |> adjust
  let b = string.inspect(b) |> adjust

  " " <> r <> " " <> g <> " " <> b <> " "
}

fn adjust(r) {
  case string.length(r) {
    1 -> "00" <> r
    2 -> "0" <> r
    _ -> r
  }
}
