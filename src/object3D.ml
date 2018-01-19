open Collider
open Shader

class object3D (collider : collider) (shader : shader) = object
  val collider = collider
  val shader = shader

  method collider = collider
  method intersection = collider#intersection

  method color point = shader#color point (collider#normal point)
end