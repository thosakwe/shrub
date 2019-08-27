type prog = Lexing.position * (top_level list)
and top_level =
  | FnDecl of (Lexing.position * type_node * string * (param list) * block)
and type_node =
  | TypeRef of Lexing.position * string
and param = Lexing.position * type_node * string
and block = Lexing.position * stmt list
and stmt =
  | Block of block
  | Return of Lexing.position * (expr option)
and expr =
  | IntLiteral of Lexing.position * int
  | FloatLiteral of Lexing.position * float