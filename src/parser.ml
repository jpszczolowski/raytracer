open Collider
open Camera
open Vector
open Shader
open Color
open Light
open Object3D

type camera_t = {
  mutable bottom_left_x : float option;
  mutable bottom_left_y : float option;
  mutable upper_right_x : float option;
  mutable upper_right_y : float option;
  mutable resolution_x : int option;
  mutable resolution_y : int option;
  mutable focal_length : float option
}

let camera_data = {
    bottom_left_x = None;
    bottom_left_y = None;
    upper_right_x = None;
    upper_right_y = None;
    resolution_x = None;
    resolution_y = None;
    focal_length = None
}

let parse_float (json : Yojson.Basic.json) = match json with
  | `Float f -> f
  | _ -> failwith "Parsing failed."

let parse_int (json : Yojson.Basic.json) = match json with
  | `Int i -> i
  | _ -> failwith "Parsing failed."

let parse_camera_elem name value = match name with
  | "bottom_left_x" -> camera_data.bottom_left_x <- Some (parse_float value)
  | "bottom_left_y" -> camera_data.bottom_left_y <- Some (parse_float value)
  | "upper_right_x" -> camera_data.upper_right_x <- Some (parse_float value)
  | "upper_right_y" -> camera_data.upper_right_y <- Some (parse_float value)
  | "resolution_x" -> camera_data.resolution_x <- Some (parse_int value)
  | "resolution_y" -> camera_data.resolution_y <- Some (parse_int value)
  | "focal_length" -> camera_data.focal_length <- Some (parse_float value)
  | _ -> failwith "Parsing failed."

let parse_camera (json : Yojson.Basic.json) = match json with
  | `Assoc l -> List.iter (fun (name, value) -> parse_camera_elem name value) l
  | _ -> failwith "Parsing failed."

let parse_lights json = ();;

let parse_objects json = ();;

let parse_start (json : Yojson.Basic.json) = match json with
  | `Assoc l ->
    let process (name, content) =
      let f = match name with
        | "camera" -> parse_camera
        | "lights" -> parse_lights
        | "objects" -> parse_objects
        | _ -> failwith "Parsing failed."
      in f content
    in List.iter process l
  | _ -> failwith "Parsing failed."

let parse ~filename:filename =
  let scene_json = Yojson.Basic.from_file filename in
  parse_start scene_json

let collider1 = new plane_collider (new vector 0. 0. 15.) (new vector 0. 0. (-1.))
let shader1 = new diffuse color_blue

let collider2 = new sphere_collider (new vector 1.5 0.5 5.) 1.
let shader2 = new diffuse color_gold

let collider3 = new sphere_collider (new vector (-0.5) 0.5 4.) 0.2
let shader3 = new diffuse color_tomato

let collider4 = new plane_collider (new vector 0. (-2.5) 10.) (new vector 0. 2. (-1.))
let shader4 = new diffuse color_seashell

let object3D1 = new object3D collider1 shader1
let object3D2 = new object3D collider2 shader2
let object3D3 = new object3D collider3 shader3
let object3D4 = new object3D collider4 shader4

let object3D_list = [object3D1; object3D2; object3D3; object3D4]
let collider_list = List.map (fun (o : object3D) -> o#collider) object3D_list

let light1 = new pointlight (new vector 10.0 (-5.0) (-3.)) 0.3
let light2 = new pointlight (new vector (-10.) 0.5 6.) 0.07
let light_list = [light1; light2]

let get_camera () =
  let camera = new camera
    (Helper.get camera_data.bottom_left_x)
    (Helper.get camera_data.bottom_left_y)
    (Helper.get camera_data.upper_right_x)
    (Helper.get camera_data.upper_right_y)
    (Helper.get camera_data.resolution_x)
    (Helper.get camera_data.resolution_y)
    (Helper.get camera_data.focal_length)
    object3D_list
    collider_list
    light_list
  in camera