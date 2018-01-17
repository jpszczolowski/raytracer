open Vector

class ray (origin : vector) (direction : vector) = object
  val origin = origin
  method origin = origin

  val direction = direction#normalize
  method direction = direction
end