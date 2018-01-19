open Vector

(* intensity is between 0. and 1. *)
class virtual light (position : vector) (intensity : float) = object
  method position = position
  method virtual intensity : vector -> float
end

class pointlight (position : vector) (intensity : float) = object
  inherit light position intensity

  method intensity (point : vector) = intensity /. (position#dist2 point)
end