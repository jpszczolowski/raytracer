open Vector
open Ray
open Color
open Collider
open Light
open Object3D

class camera (position_x : float) (position_y : float) (resolution_x : int)
             (resolution_y : int) (pixel_size : float) (focal_length : float)
             (object3D_list : object3D list) (collider_list : collider list)
             (light_list : light list) = object(self)
  val position = new vector position_x position_y 0.
  val resolution_x = resolution_x
  val resolution_y = resolution_y
  val pixel_size = pixel_size
  val focal_length = focal_length

  val object3D_list = object3D_list
  val collider_list = collider_list
  val light_list = light_list

  method resolution_x = resolution_x
  method resolution_y = resolution_y

  method private pixel_location (x : int) (y : int) =
    let itf = Pervasives.float_of_int in
    position#plus (new vector (itf x *. pixel_size) (itf y *. pixel_size) 0.)

  method private focus_location =
    let center = self#pixel_location (resolution_x / 2) (resolution_y / 2) in
    center#plus @@ new vector 0. 0. focal_length

  method private ray_to_focus (x : int) (y : int) =
    new ray (self#pixel_location x y) self#focus_location

  method private color (x : int) (y : int) =
    let point_and_dist_from_obj obj =
      match obj#collider#intersection (self#ray_to_focus x y) with
        | [] -> new vector 0. 0. 0., None
        | [collision] -> collision, Some (collision#dist2 position)
        | [collision1; collision2] -> let dist1 = collision1#dist2 position in
                                      let dist2 = collision2#dist2 position in
                                      if dist1 < dist2 then collision1, Some dist1
                                      else collision2, Some dist2 in
    let return_better obj1 point1 dist1 obj2 point2 dist2 =
      match dist1, dist2 with
        | None, _ -> obj2, point2, dist2
        | _, None -> obj1, point1, dist1
        | Some dist1', Some dist2' -> if dist1' < dist2' then obj1, point1, dist1 else obj2, point2, dist2 in
    let rec choose_obj = function
      | [obj] -> let point, dist = point_and_dist_from_obj obj in obj, point, dist
      | obj::tail -> let point1, dist1 = point_and_dist_from_obj obj in
                     let obj2, point2, dist2 = choose_obj tail in
                     return_better obj point1 dist1 obj2 point2 dist2 in
    match choose_obj object3D_list with
      | _, _, None -> color_black
      | obj, point, _ -> obj#color point collider_list light_list

  method plot (pixel : int * int) =
    let x, y = pixel in
    Graphics.set_color (self#color x y)#to_graphics_color; Graphics.plot x y
end