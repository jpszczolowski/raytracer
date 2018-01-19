open Vector

class color (r : float) (g: float) (b: float) = object
  val rgb : vector = new vector r g b
  method rgb = rgb

  method sum (other : color) = let v = rgb#plus other#rgb in new color v#x v#y v#z
  method mult (other : float) = let v = rgb#mult other in new color v#x v#y v#z
  method to_graphics_color =
    let fti = Pervasives.int_of_float in
    Graphics.rgb (fti rgb#x) (fti rgb#y) (fti rgb#z)
end

let color_pink = new color 255. 192. 203.
let color_blue = new color 70. 130. 180.
let color_green = new color 0. 201. 87.
let color_gold = new color 255. 215. 0.
let color_seashell = new color 238. 229. 222.
let color_tomato = new color 238. 92. 66.