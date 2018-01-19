open Vector

let quadratic_equation_roots a b c =
  let delta = b *. b -. 4. *. a *. c in
  let denominator = (2. *. a) in
  if delta < 0. then [] else
  if delta = 0. then [-. b /. denominator] else
                     [(-. b -. Pervasives.sqrt delta) /. denominator; (-. b +. Pervasives.sqrt delta) /. denominator]

let rec list_mult_plus (a : vector) (b : vector) = List.map (fun e -> ((a#mult e)#plus b))

let print_vector (v : vector) =
  print_string "("; print_float v#x; print_string ", ";
  print_float v#y; print_string ", ";
  print_float v#z; print_string ")"

let rec print_vector_list = function
  | [] -> ()
  | h::t -> print_vector h; print_string " "; print_vector_list t

let rec range a b = if a >= b then [] else a::range (a + 1) b

let rec range2D x_from x_to y_from y_to =
  List.fold_left List.rev_append [] @@ List.map (fun x -> List.map (fun y -> (x, y)) @@ range y_from y_to) (range x_from x_to)