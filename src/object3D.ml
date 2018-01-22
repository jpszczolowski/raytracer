open Collider
open Shader

(* a container for collider and shader *)
class object3D (collider : collider) (shader : shader) = object
  val collider = collider
  val shader = shader

  method collider = collider

  method color point = shader#color point (collider#normal point)
end