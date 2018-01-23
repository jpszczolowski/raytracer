open Object3D
open Vector

let cast ray object3D_list =
  let filter_wrong_direction =
    List.filter (fun p -> (p#minus ray#origin)#cos ray#direction > 0.) in
  let point_and_dist_from_obj obj =
    match filter_wrong_direction (obj#collider#intersection ray) with
      | [] -> new vector 0. 0. 0., None
      | [collision] -> collision, Some (collision#dist2 ray#origin)
      | [collision1; collision2] -> let dist1 = collision1#dist2 ray#origin in
                                    let dist2 = collision2#dist2 ray#origin in
                                    if dist1 < dist2 then collision1, Some dist1
                                    else collision2, Some dist2
      | _ -> failwith "Raytracer failed." in
  let return_better obj1 point1 dist1 obj2 point2 dist2 =
    match dist1, dist2 with
      | None, _ -> obj2, point2, dist2
      | _, None -> obj1, point1, dist1
      | Some dist1', Some dist2' -> if dist1' < dist2' then obj1, point1, dist1 else obj2, point2, dist2 in
  let rec choose_obj = function
    | [obj] -> let point, dist = point_and_dist_from_obj obj in obj, point, dist
    | obj::tail -> let point1, dist1 = point_and_dist_from_obj obj in
                  let obj2, point2, dist2 = choose_obj tail in
                  return_better obj point1 dist1 obj2 point2 dist2
    | _ -> failwith "Raytracer failed." in
  match choose_obj object3D_list with
    | _, _, None -> None, None
    | obj, point, _ -> Some obj, Some point