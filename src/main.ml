let camera = Parser.parse "scene.json"

let () = Graphics.set_window_title "Raytracer";
         Graphics.open_graph @@
          " " ^ (Pervasives.string_of_int camera#resolution_x)
          ^ "x" ^ (Pervasives.string_of_int camera#resolution_y)

let image = Image.create_rgb camera#resolution_x camera#resolution_y

let () =
  for x = 0 to camera#resolution_x - 1 do
    if x mod (camera#resolution_x / 10) = 0 then
      (Printf.printf "%.1f%%\n" @@ Helper.percent x camera#resolution_x; flush stdout);

    for y = 0 to camera#resolution_y - 1 do
      camera#plot_and_draw (x, y) image;
    done
  done; Printf.printf "Rendering done.\n"

let () = ImagePNG.write_png "rendered.png" image;
         Printf.printf "Image saved to file 'rendered.png'.\n"

let () = ignore @@ read_line ()