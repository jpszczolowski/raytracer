open Ray
open Color
open Collider
open Camera
open Shader
open Vector
open Light
open Object3D

let collider1 = new plane_collider (new vector 0. 0. 20.) (new vector 0.1 0. (-1.))
let shader1 = new diffuse color_blue

let collider2 = new sphere_collider (new vector 1.5 0.5 10.) 1.
let shader2 = new diffuse color_gold

let collider3 = new sphere_collider (new vector (-0.5) 0.5 10.) 0.4
let shader3 = new diffuse color_tomato

let object3D1 = new object3D collider1 shader1
let object3D2 = new object3D collider2 shader2
let object3D3 = new object3D collider3 shader3

let object3D_list = [object3D1; object3D2; object3D3]
let collider_list = List.map (fun (o : object3D) -> o#collider) object3D_list

let light1 = new pointlight (new vector 10.0 (-5.0) 3.) 0.5
let light2 = new pointlight (new vector (-12.) 1. 7.) 0.2
let light_list = [light1]

let camera = new camera 0. 0. 800 600 0.001 0.7 object3D_list collider_list light_list

let () = Graphics.set_window_title "Raytracer";
         Graphics.open_graph @@
          " " ^ (Pervasives.string_of_int camera#resolution_x)
          ^ "x" ^ (Pervasives.string_of_int camera#resolution_y)

let () =
  for x = 0 to camera#resolution_x do
    for y = 0 to camera#resolution_y do
      camera#plot (x, y)
    done
  done

(* let pixel_array = Helper.range2D 0 camera#resolution_x 0 camera#resolution_y *)
(* let () = List.iter camera#plot pixel_array *)

let () = ignore @@ read_line (); Graphics.close_graph ()