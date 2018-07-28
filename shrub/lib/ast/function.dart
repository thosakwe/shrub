import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';
import 'package:symbol_table/symbol_table.dart';

class FunctionContext {
  final List<ParameterContext> parameters = [];
  final FileSpan span;
  final IdentifierContext identifier;
  final ExpressionContext expression;
  final TypeContext returnType;
  SymbolTable<ShrubObject> scope;

  FunctionContext(this.span, this.identifier, this.expression, this.returnType);

  bool get isExternal => expression == null && returnType != null;
}

class ParameterContext {
  final IdentifierContext identifier;

  ParameterContext(this.identifier);

  FileSpan get span => identifier.span;
}
