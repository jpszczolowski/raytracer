open Vector

class color (r : float) (g: float) (b: float) = object(self)
  val rgb : vector = new vector r g b
  method rgb = rgb

  method normalize =
    let cut x =
      if x < 0. then 0.
      else if x > 255. then 255.
      else x in
    new color (cut rgb#x) (cut rgb#y) (cut rgb#z)

  method sum (other : color) = let v = rgb#plus other#rgb in new color v#x v#y v#z
  method mult (other : float) = let v = rgb#mult other in new color v#x v#y v#z
  method get_color =
    let c = self#normalize in
    let fti = Pervasives.int_of_float in
    (fti c#rgb#x), (fti c#rgb#y), (fti c#rgb#z)
end

let color_pink = new color 255. 192. 203.
let color_blue = new color 70. 130. 180.
let color_green = new color 0. 201. 87.
let color_gold = new color 255. 215. 0.
let color_seashell = new color 238. 229. 222.
let color_tomato = new color 238. 92. 66.
let color_black = new color 0. 0. 0.
let color_white = new color 255. 255. 255.
let color_orchid = new color 218. 112. 214.
let color_black = new color 0. 0. 0.
let color_olive = new color 142. 142. 56.