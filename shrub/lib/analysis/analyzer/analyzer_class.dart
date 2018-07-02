import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:string_scanner/string_scanner.dart';
import 'package:symbol_table/symbol_table.dart';

class Analyzer {
  final ModuleSystem moduleSystem;

  Analyzer(this.moduleSystem);

  // TODO: Support for resolving deltas, etc.
  Future<AnalysisResult> analyze(AnalysisContext context) async {
    await for (var file in context.module.directory.listShrubFiles()) {
      var scanner = new SpanScanner(await file.read(), sourceUrl: file.path);
      var lexer = new Lexer(scanner)..scan();
      var parser = new Parser(lexer);
      var unit = parser.parseCompilationUnit();

      if (unit == null) {
        return new AnalysisResult(
            context, AnalysisResultType.failure, parser.errors);
      } else {
        for (var function in unit.functions) {
          function.scope ??= context.module.scope.createChild();
          await analyzeFunction(function, context);
        }
      }
    }

    return new AnalysisResult(context, AnalysisResultType.success, []);
  }

  Future analyzeFunction(
      FunctionContext function, AnalysisContext context) async {
    // TODO: Analyze parameters
    await analyzeExpression(function.expression, function.scope, context);
  }

  Future<SymbolTable<ShrubObject>> analyzeExpression(
      ExpressionContext expression,
      SymbolTable<ShrubObject> scope,
      AnalysisContext context) async {
    if (expression.resolved != null) return scope;

    if (expression is IntegerLiteralContext) {
      expression.resolved = new ShrubObject(context.module,
          context.moduleSystemView.findCoreType('Integer'), expression.span);
      return scope;
    }

    throw new UnimplementedError(
        'Cannot yet analyze ${expression.runtimeType}!!!');
  }
}
