let rec resolve name scope =
  match scope with
  | [] -> None
  | (n, symbol) :: rest ->
    if n = name then
      Some symbol
    else 
      resolve name rest
