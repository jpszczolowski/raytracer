class vector (x : float) (y : float) (z : float) = object(self)
  val x = x
  method x = x

  val y = y
  method y = y

  val z = z
  method z = z

  method length2 = self#x *. self#x +. self#y *. self#y +. self#z *. self#z
  method length = Pervasives.sqrt self#length2
  method normalize = let l = self#length in new vector (self#x /. l) (self#y /. l) (self#z /. l)
  method dot (other : vector) = self#x *. other#x +. self#y *. other#y +. self#z *. other#z
  method plus (other : vector) = new vector (self#x +. other#x) (self#y +. other#y) (self#z +. other#z)
  method minus (other : vector) = new vector (self#x -. other#x) (self#y -. other#y) (self#z -. other#z)
  method mult (other : float) = new vector (self#x *. other) (self#y *. other) (self#z *. other)
  method cos (other : vector) = self#normalize#dot other#normalize
  method dist2 (other : vector) = (self#minus other)#length2
end