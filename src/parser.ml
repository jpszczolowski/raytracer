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

let parse_camera (json : Yojson.Basic.json) = match json with
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

let parse_color (json : Yojson.Basic.json) = match parse_string json with
  | "pink" -> color_pink
  | "blue" -> color_blue
  | "green" -> color_green
  | "gold" -> color_gold
  | "seashell" -> color_seashell
  | "tomato" -> color_tomato
  | "black" -> color_black
  | "white" -> color_white
  | "orchid" -> color_orchid
  | "olive" -> color_olive
  | _ -> failwith parse_error_msg

let parse_sphere_collider (json : Yojson.Basic.json) = match json with
  | `List [pos_x; pos_y; pos_z; r] ->
    new sphere_collider
      (new vector
        (parse_float pos_x)
        (parse_float pos_y)
        (parse_float pos_z))
      (parse_float r)
  | _ -> failwith parse_error_msg

let parse_plane_collider (json : Yojson.Basic.json) = match json with
  | `List [pos_x; pos_y; pos_z; norm_x; norm_y; norm_z] ->
    new plane_collider
      (new vector
        (parse_float pos_x)
        (parse_float pos_y)
        (parse_float pos_z))
      (new vector
        (parse_float norm_x)
        (parse_float norm_y)
        (parse_float norm_z))
  | _ -> failwith parse_error_msg

let parse_object (json : Yojson.Basic.json) = match json with
  | `Assoc [("type", _objtype); ("color", _color); ("shader", _shader); ("data", _data)] ->
    let color = parse_color _color in
    let shader = match parse_string _shader with
      | "diffuse" -> new diffuse color
      | _ -> failwith parse_error_msg in
    let collider = match parse_string _objtype with
      | "sphere" -> parse_sphere_collider _data
      | "plane" -> parse_plane_collider _data
      | _ -> failwith parse_error_msg
    in new object3D collider shader
  | _ -> failwith parse_error_msg

let parse_objects (json : Yojson.Basic.json) = match json with
  | `List l -> List.map parse_object l
  | _ -> failwith parse_error_msg

let parse_all (json : Yojson.Basic.json) = match json with
  | `Assoc [("camera", cam_json); ("objects", objs_json); ("lights", lights_json)] ->
      parse_camera cam_json, parse_objects objs_json, parse_lights lights_json
  | _ -> failwith parse_error_msg

let parse ~filename:filename =
  let scene_json = Yojson.Basic.from_file filename in
  let camera_data, objects, lights = parse_all scene_json in
  let camera = new camera
    camera_data.bottom_left_x
    camera_data.bottom_left_y
    camera_data.upper_right_x
    camera_data.upper_right_y
    camera_data.resolution_x
    camera_data.resolution_y
    camera_data.focal_length
    objects
    (List.map (fun o -> o#collider) objects)
    lights
  in camera