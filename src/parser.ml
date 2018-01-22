open Collider
open Camera
open Vector
open Shader
open Color
open Light
open Object3D

type camera_data_t = {
  bottom_left_x : float;
  bottom_left_y : float;
  upper_right_x : float;
  upper_right_y : float;
  resolution_x : int;
  resolution_y : int;
  focal_length : float
}

let parse_float (json : Yojson.Basic.json) = match json with
  | `Float f -> f
  | _ -> failwith "Parsing failed."

let parse_int (json : Yojson.Basic.json) = match json with
  | `Int i -> i
  | _ -> failwith "Parsing failed."

let parse_camera (json : Yojson.Basic.json) =
  match json with
    | `List l -> (match l with
      | [blx; bly; urx; ury; rx; ry; fl] -> {
          bottom_left_x = parse_float blx;
          bottom_left_y = parse_float bly;
          upper_right_x = parse_float urx;
          upper_right_y = parse_float ury;
          resolution_x = parse_int rx;
          resolution_y = parse_int ry;
          focal_length = parse_float fl
        }
      | _ -> failwith "Paring failed.")
    | _ -> failwith "Parsing failed."

let parse_lights json = 42

let parse_objects json = 42

let parse_start (json : Yojson.Basic.json) =
  let camera_data = ref None in
  let objects = ref None in
  let lights = ref None in
  (match json with
    | `Assoc l ->
      let process (name, content) =
      match name with
        | "camera" -> camera_data := Some (parse_camera content)
        | "lights" -> lights := Some (parse_lights content)
        | "objects" -> objects := Some (parse_objects)
        | _ -> failwith "Parsing failed."
      in List.iter process l
    | _ -> failwith "Parsing failed.");
    Helper.get !camera_data, Helper.get !objects, Helper.get !lights

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

let light1 = new pointlight 0.3 (new vector 10.0 (-5.0) (-3.))
let light2 = new pointlight 0.07 (new vector (-10.) 0.5 6.)
let light3 = new directionallight 1. (new vector (-1.) (-1.) 1.)
let light_list = [light1]

let parse ~filename:filename =
  let scene_json = Yojson.Basic.from_file filename in
  let camera_data, objects, lights = parse_start scene_json in
  let camera = new camera
    camera_data.bottom_left_x
    camera_data.bottom_left_y
    camera_data.upper_right_x
    camera_data.upper_right_y
    camera_data.resolution_x
    camera_data.resolution_y
    camera_data.focal_length
    object3D_list
    (List.map (fun o -> o#collider) object3D_list )
    light_list
  in camera