type shrub_exception_severity =
  | Error
  | Warning
  | Hint
  | Info

exception ShrubException of Lexing.position * shrub_exception_severity * string

type prog = Lexing.position * (top_level list)
and top_level =
  | FnDecl of (Lexing.position * type_node * string * (param list) * stmt)
and type_node =
  | TypeRef of Lexing.position * string
and param = Lexing.position * type_node * string
and block = Lexing.position * stmt list
and stmt =
  | Block of block
  | Return of Lexing.position * (expr option)
and expr =
  | VarGet of param
  | IntLiteral of Lexing.position * int
  (* | FloatLiteral of Lexing.position * float *)

let list_of_stmt = function
  | Block (_, stmts) -> stmts
  | x -> [x]