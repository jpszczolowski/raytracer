open Light
open Color
open Vector
open Ray
open Collider

class virtual shader = object

  (* seen color when you take light into account *)
  method virtual color : vector -> vector -> collider list -> light list -> color
end

class diffuse (color : color) = object
  inherit shader

  (* raw color of surface *)
  val color = color

  method color (point : vector) (normal : vector) (collider_list : collider list) (light_list : light list) =
    let is_light_visible light =
      let vec_to_light = light#vector_from point in
      let ray_to_light = new ray point vec_to_light in
      let filter_out =
        let good_point p = not (p#equal point) && vec_to_light#cos (p#minus point) > 0. in
        List.filter good_point in
      List.for_all (fun collider -> filter_out (collider#intersection ray_to_light) = []) collider_list in
    let visible_light_list = List.filter is_light_visible light_list in
    let cos_angle_to_light light = normal#cos (light#vector_from point) in
    let real_light_intensity light = cos_angle_to_light light *. light#intensity point in
    let intensity_list = List.map real_light_intensity visible_light_list in
    let sum_intensity_list = List.fold_left (+.) 0. intensity_list in
    color#mult sum_intensity_list
end