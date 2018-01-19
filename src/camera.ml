open Vector

class camera (position : vector) (resolution_x : int) (resolution_y : int) (pixel_size : float) = object
  val position = position
  val resolution_x = resolution_x
  val resolution_y = resolution_y
  val pixel_size = pixel_size

  
end