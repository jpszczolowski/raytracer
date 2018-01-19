open Vector
open Ray

class virtual collider (position : vector) = object
  val position = position
  method private position = position

  (* list of intersection points with a ray *)
  method virtual intersection : ray -> vector list

  (* normal vector to a shape in given point *)
  method virtual normal : vector -> vector
end

class sphere_collider (position : vector) (radius : float) = object(self)
  inherit collider position

  val radius = radius
  method private radius = radius

  method normal (point : vector) = (point#minus self#position)#normalize

  method intersection (ray : ray) =
    let org_minus_pos = ray#origin#minus self#position in
    let a = ray#direction#dot ray#direction in
    let b = 2. *. (ray#direction#dot org_minus_pos) in
    let c = (org_minus_pos#dot org_minus_pos) -. self#radius in
      Helper.list_mult_plus ray#direction ray#origin (Helper.quadratic_equation_roots a b c)
end

(* position is point on the plane and normal is normal vector to this plane *)
class plane_collider (position : vector) (normal : vector) = object(self)
  inherit collider position

  val normal = normal#normalize
  method normal _ = normal

  method intersection (ray : ray) =
    let d_denominator = ray#direction#dot (self#normal self#position) in
    if d_denominator = 0. then []
    else
      let d_nominator = (self#position#minus ray#origin)#dot (self#normal self#position) in
      let d = d_nominator /. d_denominator in
        Helper.list_mult_plus ray#direction ray#origin [d]
end