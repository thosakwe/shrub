type rtt =
  | VoidType
  | IntType of bool * int
  (* | TupleType of rtt list *)
and symbol =
  | Expr of Ast.expr
  | Type of rtt
and scope = (string * symbol) list

let i8_type = IntType (true, 8)
let i16_type = IntType (true, 16)
let i32_type = IntType (true, 32)
let i64_type = IntType (true, 64)
let u8_type = IntType (false, 8)
let u16_type = IntType (false, 16)
let u32_type = IntType (false, 32)
let u64_type = IntType (false, 64)

let position_of_rtt t =
  match t with
  | VoidType -> None
  | IntType (_, _) -> None