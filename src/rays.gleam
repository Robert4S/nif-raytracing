import gleam/list
import gleam/result
import image
import pngleam
import simplifile

pub fn main() {
  image.raytraced_image(400)
  |> save_img
}

fn save_img(image: image.Image) -> Result(Nil, Nil) {
  use first <- result.try(list.first(image.pixels))

  image
  |> image.to_bitarrays
  |> pngleam.from_packed(
    width: list.length(first),
    height: list.length(image.pixels),
    color_info: pngleam.rgb_8bit,
    compression_level: pngleam.default_compression,
  )
  |> simplifile.write_bits("img.png", _)
  |> result.map_error(fn(_) { Nil })
}
