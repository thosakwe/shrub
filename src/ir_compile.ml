type compile_state = 
  {
    scope: Analysis.scope;
    func: Ir.func;
    return_type: Analysis.rtt;
  }

let visit_stmt state node =
  match node with
    _ -> 23

let visit_type scope node =
  match node with
  | Ast.TypeRef (pos, name) -> begin
      match name with 
      | "void" -> Analysis.VoidType
      | "i8" -> Analysis.i8_type
      | "i16" -> Analysis.i16_type
      | "i32" -> Analysis.i32_type
      | "i64" -> Analysis.i64_type
      | "u8" -> Analysis.u8_type
      | "u16" -> Analysis.u16_type
      | "u32" -> Analysis.u32_type
      | "u64" -> Analysis.u64_type
      | _ -> begin
          let sym_opt = Scope.resolve name scope in
          match sym_opt with
          | Some (Analysis.Type x) -> Analysis.VoidType
          | _ -> 
            let msg = "No type named '" ^ name ^ "' exists in the current context." in
            raise (Ast.ShrubException (pos, Ast.Error, msg))
        end
    end

let visit_top_level_fndecl scope node = 
  match node with
  | Ast.FnDecl (_, returns, name, params, body) -> begin
      let func = (name, []) in
      let param_symbols = 
        let symbol_of_param p =
          let (_, _, name) = p in
          let value = Analysis.Expr (Ast.VarGet p) in
          (name, value)
        in
        List.map symbol_of_param params 
      in
      let child_scope = param_symbols @ scope in
      let state =
        { 
          scope = child_scope;
          func = func;
          return_type = (visit_type scope returns);
        } in
      visit_stmt state body
    end

let visit_top_level scope node =
  let visitor = match node with
    | Ast.FnDecl _ -> begin
        visit_top_level_fndecl
      end
  in
  visitor scope node

let ir_of_ast prog =
  let (_, top_level) = prog in
  List.map visit_top_level top_level