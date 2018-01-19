open Vector
open Ray
open Color

class camera (position_x : float) (position_y : float) (resolution_x : int)
             (resolution_y : int) (pixel_size : float) (focal_length : float) = object(self)
  val position = new vector position_x position_y 0.
  val resolution_x = resolution_x
  val resolution_y = resolution_y
  val pixel_size = pixel_size
  val focal_length = focal_length

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

  method private color (x : int) (y : int) = color_blue

  method plot (pixel : int * int) =
    let x, y = pixel in
    Graphics.set_color (self#color x y)#to_graphics_color; Graphics.plot x y
end