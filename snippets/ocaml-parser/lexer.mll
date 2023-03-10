{
open Lexing
open Parser
}

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let string = [^ '(' ')' '\\' '.' '#' ' ' '\t' '\n' '\t']+

rule read =
  parse
    | white { read lexbuf }
    | "\\" { LAMBDA }
    | "λ" { LAMBDA }
    | "." { DOT }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "#" { skip_line lexbuf }
    | string { ID (lexeme lexbuf) }
    | newline { END }
    | eof { EOF }
and skip_line =
  parse
    | newline { new_line lexbuf; read lexbuf }
    | eof { EOF }
    | _ { skip_line lexbuf }
