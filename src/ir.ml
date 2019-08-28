type  t = func list
and func = string * branch list
and branch = string * (instruction list)
and instruction =
  | ReturnVoid
  (* signed * size * value *)
  | ReturnInt of bool * int * int