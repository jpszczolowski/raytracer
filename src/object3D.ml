open Shape
open Shader

class object3D (shape : shape) (shader : shader) = object
  val shape = shape
  method intersection = shape#intersection
  method normal = shape#normal

  val shader = shader
  

end