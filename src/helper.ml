open Vector

let quadratic_equation_roots a b c =
  let delta = b *. b -. 4. *. a *. c in
  let denominator = (2. *. a) in 
  if delta < 0. then [] else
  if delta = 0. then [-. b /. denominator] else
                     [(-. b -. Pervasives.sqrt delta) /. denominator; (-. b +. Pervasives.sqrt delta) /. denominator]

let rec list_mult_plus (a : vector) (b : vector) = function
  | [] -> []
  | h::t -> ((a#mult h)#plus b)::list_mult_plus a b t