open Ray
open Color
open Collider
open Camera
open Shader
open Vector
open Light
open Object3D

let collider1 = new plane_collider (new vector 0. 0. 15.) (new vector 0. 0. (-1.))
let shader1 = new diffuse color_blue

let collider2 = new sphere_collider (new vector 1.5 0.5 10.) 1.
let shader2 = new diffuse color_gold

let collider3 = new sphere_collider (new vector (-0.5) 0.5 10.) 0.2
let shader3 = new diffuse color_tomato

let collider4 = new plane_collider (new vector 0. (-2.5) 10.) (new vector 0. 2. (-1.))
let shader4 = new diffuse color_seashell

let object3D1 = new object3D collider1 shader1
let object3D2 = new object3D collider2 shader2
let object3D3 = new object3D collider3 shader3
let object3D4 = new object3D collider4 shader4

let object3D_list = [object3D1; object3D2; object3D3; object3D4]
let collider_list = List.map (fun (o : object3D) -> o#collider) object3D_list

let light1 = new pointlight (new vector 10.0 (-5.0) 3.) 0.3
let light2 = new pointlight (new vector (-10.) 0.5 6.) 0.07
let light_list = [light1; light2]

let camera = new camera (-0.5) (-0.5) 1440 1080 0.001 0.7 object3D_list collider_list light_list

let () = Graphics.set_window_title "Raytracer";
         Graphics.open_graph @@
          " " ^ (Pervasives.string_of_int camera#resolution_x)
          ^ "x" ^ (Pervasives.string_of_int camera#resolution_y)

let image = Image.create_rgb camera#resolution_x camera#resolution_y

let () =
  for x = 0 to camera#resolution_x - 1 do
    if x mod ((camera#resolution_x - 1) / 10) = 0 then
      (Printf.printf "%.2f%%\n" @@ Helper.percent x (camera#resolution_x - 1); flush stdout);

    for y = 0 to camera#resolution_y - 1 do
      camera#plot_and_draw (x, y) image;
    done
  done; Printf.printf "Done.\n"

let () = ImagePNG.write_png "raytracer.png" image

let () = ignore @@ read_line ()