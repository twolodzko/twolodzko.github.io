%{
open Term
%}

%token <string> ID
%token LPAREN "("
%token RPAREN ")"
%token LAMBDA "λ"
%token DOT "."
%token END
%token EOF

%start <Term.term option> prog
%%

let prog :=
  | EOF; { None }
  | END; p = prog; { p }
  | t = term; line_end; { Some t }

let line_end := END | EOF

let variable :=
  | x = ID; { Var x }

let element :=
  | variable
  | "("; x = term; ")"; { x }

let application :=
  | element
  | t = application; u = element; { App (t, u) }

let abstraction :=
  | "λ"; x = ID; u = body; { Abs (x, u) }

let body :=
  | "."; u = term; { u }
  | x = ID; u = body; { Abs (x, u) }

let term :=
  | application
  | abstraction
