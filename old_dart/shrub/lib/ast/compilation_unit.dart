import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';
import 'package:symbol_table/symbol_table.dart';

class CompilationUnitContext {
  final List<ImportDirectiveContext> imports = [];
  final List<FunctionContext> functions = [];
  final FileSpan span;

  CompilationUnitContext(this.span);
}
