class vector (x : float) (y : float) (z : float) = object(self)
  val x = x
  method x = x
  
  val y = y
  method y = y

  val z = z
  method z = z

  method length = Pervasives.sqrt (self#x *. self#x +. self#y *. self#y +. self#z *. self#z)
  method normalize = let l = self#length in new vector (self#x /. l) (self#y /. l) (self#z /. l)
  method dot (other : vector) = self#x *. other#x +. self#y *. other#y +. self#z *. other#z
  method plus (other : vector) = new vector (self#x +. other#x) (self#y +. other#y) (self#z +. other#z)
  method minus (other : vector) = new vector (self#x -. other#x) (self#y -. other#y) (self#z -. other#z)
end

class ray (origin : vector) (direction : vector) = object
  val origin = origin
  method origin = origin

  val direction = direction#normalize
  method direction = direction
end

class virtual shape (position : vector) = object
  val position = position
  method position = position
end

class sphere (position : vector) (radius : float) = object(self)
  inherit shape position

  val radius = radius
  method radius = radius

  method intersection (ray : ray) =
    let org_minus_pos = ray#origin#minus self#position in
    Helper.quadratic_equation_roots
      (ray#direction#dot ray#direction)
      (2. *. (ray#direction#dot org_minus_pos))
      ((org_minus_pos#dot org_minus_pos) -. self#radius)
end

class plane (position : vector) (normal : vector) = object

end