open Ray
open Color
open Collider
open Camera
open Shader
open Vector
open Light
open Object3D

let collider1 = new sphere_collider (new vector 1. 1. 50.) 3.;;
let shader1 = new diffuse color_gold

let object3D1 = new object3D collider1 shader1
let object3D_list = [object3D1]
let collider_list = List.map (fun (o : object3D) -> o#collider) object3D_list

let light = new pointlight (new vector 0.5 0.5 0.1) 1.
let light_list = [light]

let camera = new camera 0. 0. 500 500 0.01 1. object3D_list collider_list light_list

let () = Graphics.set_window_title "Raytracer";
         Graphics.open_graph @@
          " " ^ (Pervasives.string_of_int camera#resolution_x)
          ^ "x" ^ (Pervasives.string_of_int camera#resolution_y)

let pixel_array = Helper.range2D 0 camera#resolution_x 0 camera#resolution_y

let () = List.iter camera#plot pixel_array

let () = ignore @@ read_line (); Graphics.close_graph ()