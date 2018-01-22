open Collider
open Camera
open Vector
open Shader
open Color
open Light
open Object3D

let parse_error_msg = "Parsing failed."

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
  | _ -> failwith parse_error_msg

let parse_int (json : Yojson.Basic.json) = match json with
  | `Int i -> i
  | _ -> failwith parse_error_msg

let parse_string (json : Yojson.Basic.json) = match json with
  | `String s -> s
  | _ -> failwith parse_error_msg

let parse_camera (json : Yojson.Basic.json) =
  match json with
    | `List [blx; bly; urx; ury; rx; ry; fl] -> {
        bottom_left_x = parse_float blx;
        bottom_left_y = parse_float bly;
        upper_right_x = parse_float urx;
        upper_right_y = parse_float ury;
        resolution_x = parse_int rx;
        resolution_y = parse_int ry;
        focal_length = parse_float fl
      }
    | _ -> failwith parse_error_msg

let parse_pointlight (json : Yojson.Basic.json) = match json with
  | `List [intensity; pos_x; pos_y; pos_z] ->
    new pointlight
      (parse_float intensity) @@
      new vector
        (parse_float pos_x)
        (parse_float pos_y)
        (parse_float pos_z)
  | _ -> failwith parse_error_msg

let parse_directionallight (json : Yojson.Basic.json) = match json with
  | `List [intensity; dir_x; dir_y; dir_z] ->
    new directionallight
      (parse_float intensity) @@
      new vector
        (parse_float dir_x)
        (parse_float dir_y)
        (parse_float dir_z)
  | _ -> failwith parse_error_msg

let parse_light (json : Yojson.Basic.json) = match json with
  | `Assoc [("type", lighttype); ("data", data)] ->
    (match parse_string lighttype with
      | "point" -> parse_pointlight data
      | "directional" -> parse_directionallight data
      | _ -> failwith parse_error_msg)
  | _ -> failwith parse_error_msg

let parse_lights (json : Yojson.Basic.json) = match json with
  | `List l -> List.map parse_light l
  | _ -> failwith parse_error_msg

let parse_objects (json : Yojson.Basic.json) = 42

let parse_start (json : Yojson.Basic.json) = match json with
  | `Assoc [("camera", cam_json); ("objects", objs_json); ("lights", lights_json)] ->
      parse_camera cam_json, parse_objects objs_json, parse_lights lights_json
  | _ -> failwith parse_error_msg

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
    lights
  in camera