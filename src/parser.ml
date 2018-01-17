(* TU NIE MA NIC CIEKAWEGO *)

(* simple parser
ocamlbuild -I src parser.byte && ./parser.byte*)

open Printf

type shape = SPHERE of Vector3.t * float | PLANE of Vector3.t * Vector3.t

(*
SPHERE
point, radius (4 floats)

PLANE
point, normal_vec (6 floats)
*)

let filename = "scene.dat"
let parsed = ref []
let fos = float_of_string
let il = input_line

let () =
  let ic = open_in filename in
  try
    while true; do
      match il ic with
      | "SPHERE" -> let f1 = fos (il ic) in let f2 = fos (il ic) in let f3 = fos (il ic)
        in let f4 = fos (il ic) in parsed := SPHERE(Vector3.Vector3(f1, f2, f3), f4) :: !parsed;
        printf "SPHERE(V3(%f, %f, %f), %f)\n" f1 f2 f3 f4
      | "PLANE" -> let f1 = fos (il ic) in let f2 = fos (il ic) in let f3 = fos (il ic)
        in let f4 = fos (il ic) in let f5 = fos (il ic) in let f6 = fos (il ic) in
        parsed := PLANE(Vector3.Vector3(f1, f2, f3), Vector3.Vector3(f4, f5, f6)) :: !parsed;
        printf "PLANE(V3(%f, %f, %f), V3(%f, %f, %f))\n" f1 f2 f3 f4 f5 f6
      | _ -> raise (Failure "bad shape")
    done;
  with End_of_file -> flush stdout; close_in ic;;