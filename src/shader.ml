open Light
open Color
open Vector
open Ray
open Collider

class virtual shader = object
  method virtual color : vector -> vector -> collider list -> light list -> color
end

class diffuse (color : color) = object
  inherit shader

  (* raw color of surface *)
  val color = color

  (* seen color when you take light into account *)
  method color (point : vector) (normal : vector) (collider_list : collider list) (light_list : light list) =
    let is_light_visible light =
      let ray_to_light = new ray point light#position in
      List.for_all (fun collider -> collider#intersection ray_to_light = []) collider_list in
    let visible_light_list = List.filter is_light_visible light_list in
    let cos_angle_to_light light = normal#cos (light#position#minus point) in
    let real_light_intensity light = cos_angle_to_light light *. light#intensity point in
    let intensity_list = List.map real_light_intensity visible_light_list in
    let sum_intensity_list = List.fold_left (+.) 0. intensity_list in
    color#mult sum_intensity_list
end