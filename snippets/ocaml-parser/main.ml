open Lexing
open Term

let rec loop lexer =
  flush stdout;
  let _ = match Parser.prog Lexer.read lexer with
    | Some t ->
        Printf.printf "%s\n\n" (show_term t);
    | None -> () in
  loop lexer

let () =
  loop (from_channel stdin)
