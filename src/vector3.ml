type t = Vector3 of float * float * float

let line_line_intersection (Vector3(a1, b1, c1)) (Vector3(a2, b2, c2)) = 
  let det a b c d = a *. d -. b *. c in
  let wx = det (-.c1) b1 (-.c2) b2 in
  let wy = det a1 (-.c1) a2 (-.c2) in
  let w  = det a1 b2 a2 b2 in
    Vector2.Vector2(wx /. w,  wy /. w);;