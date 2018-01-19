open Ray
open Color
open Collider
open Camera
open Shader
open Vector
open Light
open Object3D

let ray = new ray (new vector 0. 0. 0.) (new vector 0. 0. 5.)
let () = Helper.print_vector @@ ray#direction

let () = print_newline ()

let collider = new sphere_collider (new vector 1. 0. 10.) 3.;;
let () = Helper.print_vector_list @@ collider#intersection ray

let shader = new diffuse color_gold

let object3D = new object3D collider shader
let object3D_list = [object3D]
let collider_list = List.map (fun (o : object3D) -> o#collider) object3D_list

let light = new pointlight (new vector 0. 0. 0.) 42.
let light_list = [light]

let () = ignore @@ object3D#color (new vector 0. 0. 0.) collider_list light_list