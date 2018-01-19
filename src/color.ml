open Vector

(* r g b are floats from 0. to 255. *)
class color (r : float) (g: float) (b: float) = object
  (* but here from 0. to 1. *)
  val r = r /. 255.
  val g = g /. 255.
  val b = b /. 255.
end

let color_pink = new color 255. 192. 203.
let color_blue = new color 70. 130. 180.
let color_green = new color 0. 201. 87.
let color_gold = new color 255. 215. 0.
let color_seashell = new color 238. 229. 222.
let color_tomato = new color 238. 92. 66.