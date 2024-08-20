import gleam/bool
import gleam/float
import ray.{type Ray}
import vector.{type Vec}

pub type HitRecord {
  HitRecord(p: Vec, normal: Vec, t: Float)
}

pub type Sphere {
  Sphere(center: Vec, radius: Float)
}

fn hits_sphere(
  sphere: Sphere,
  ray: Ray,
  ray_tmin: Float,
  ray_tmax: Float,
  record: HitRecord,
) {
  let oc = sphere.center |> vector.sub(ray.origin)
  let a = ray.direction |> vector.length_squared
  let h = vector.dot(ray.direction, oc)

  let c = { oc |> vector.length_squared } -. { sphere.radius *. sphere.radius }

  let discr = h *. h -. a *. c
  use <- bool.guard(discr <. 0.0, #(False, record))

  let assert Ok(sqrt) = float.square_root(discr)

  let root = { h -. sqrt } /. a

  let return = fn(root) {
    let newrecord =
      HitRecord(
        t: root,
        p: ray.at(ray, record.t),
        normal: vector.sub(record.p, sphere.center)
          |> vector.div(sphere.radius),
      )
    #(True, newrecord)
  }

  case root {
    n if n <=. ray_tmin || n >=. ray_tmax -> {
      let root = { h +. sqrt } /. a
      case root {
        n if n <=. ray_tmin || n >=. ray_tmax -> #(False, record)
        _ -> return(root)
      }
    }
    _ -> return(root)
  }
}
