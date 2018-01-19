open Light
open Color
open Vector
open Collider

class virtual shader = object
  method virtual color : vector -> vector -> collider list -> light list -> color
end

class diffuse (color : color) = object
  inherit shader

  (* color of surface *)
  val color = color

  (* seen color when you take light into account *)
  method color (point : vector) (normal : vector) (collider_list : collider list) (light_list : light list) = color_gold

end