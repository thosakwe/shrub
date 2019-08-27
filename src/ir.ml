type t =
  | ReturnVoid
  (* signed * size * value *)
  | ReturnInt of bool * int * int