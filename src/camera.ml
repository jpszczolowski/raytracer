open Vector
open Ray
open Color
open Collider
open Light
open Object3D

class camera (bottom_left_x : float) (bottom_left_y : float) (upper_right_x : float) (upper_right_y : float)
             (resolution_x : int) (resolution_y : int) (focal_length : float) (object3D_list : object3D list)
             (collider_list : collider list) (light_list : light list) = object(self)
  val position = new vector bottom_left_x bottom_left_y 0.
  val pixel_size_x = (upper_right_x -. bottom_left_x) /. (Pervasives.float_of_int resolution_x)
  val pixel_size_y = (upper_right_y -. bottom_left_y) /. (Pervasives.float_of_int resolution_y)
  val resolution_x = resolution_x
  val resolution_y = resolution_y
  val focal_length = focal_length

  val object3D_list = object3D_list
  val collider_list = collider_list
  val light_list = light_list

  method resolution_x = resolution_x
  method resolution_y = resolution_y

  method private pixel_location (x : int) (y : int) =
    let itf = Pervasives.float_of_int in
    position#plus (new vector (itf x *. pixel_size_x) (itf y *. pixel_size_y) 0.)

  method private focus_location =
    let center = self#pixel_location (resolution_x / 2) (resolution_y / 2) in
    center#plus @@ new vector 0. 0. focal_length

  method private ray_to_focus (x : int) (y : int) =
    let origin = self#pixel_location x y in
    new ray origin (self#focus_location#minus origin)

  (* get pixel color for plot_and_draw method *)
  method private color (x : int) (y : int) =
    let ray = self#ray_to_focus x y in
    match Raycaster.cast ray object3D_list with
      | Some obj, Some point -> obj#color point object3D_list light_list ray#direction
      | _ -> color_black

  method plot_and_draw (pixel : int * int) (image : Image.image) =
    let x, y = pixel in
    let mirror_x = resolution_x - x - 1 and mirror_y = resolution_y - y - 1 in
    let r, g, b = (self#color mirror_x mirror_y)#get_color in
    Graphics.set_color @@ Graphics.rgb r g b; Graphics.plot x y;
    Image.write_rgb image x mirror_y r g b
end