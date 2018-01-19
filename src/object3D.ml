open Collider
open Shader

class object3D (collider : collider) (shader : shader) = object
  val collider = collider
  method intersection = collider#intersection
  method normal = collider#normal

  val shader = shader
  method color = shader#color
end