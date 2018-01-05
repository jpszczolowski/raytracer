let main () = let Vector2.Vector2(a, b) =
  Vector3.line_line_intersection (Vector3.Vector3(2., -1., 0.)) (Vector3.Vector3(-1., -1., 1.)) in 
    Printf.printf "(%f, %f)" a b;;

  let () = main ();;