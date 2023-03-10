
type term =
  | Var of string
  | App of term * term
  | Abs of string * term
  [@@deriving show]
