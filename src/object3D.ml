open Collider
open Shader

class object3D (collider : collider) (shader : shader) = object
  val collider = collider
  method collider = collider

  val shader = shader

  method intersection = collider#intersection
  method color point = shader#color point (collider#normal point)
end