open Vector

class virtual light (intensity : float) = object
  val intensity = intensity

  (* intensity at given point *)
  method virtual intensity : vector -> float

  (* vector from given point to light *)
  method virtual vector_from : vector -> vector
end

class pointlight (intensity : float) (position : vector) = object
  inherit light intensity

  val position = position

  method intensity (point : vector) = 500. *. intensity /. (position#dist2 point)
  method vector_from (point : vector) = position#minus point
end

class directionallight (intensity : float) (direction : vector) = object
  inherit light intensity

  val direction = direction#normalize

  method intensity (point : vector) = intensity
  method vector_from _ = direction#mult (-1.)
end