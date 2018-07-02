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
          var fn = await analyzeFunction(function, context);
          context.module.scope.create(fn.name, value: fn, constant: true);
        }
      }
    }

    return new AnalysisResult(context, AnalysisResultType.success, []);
  }

  Future<ShrubFunction> analyzeFunction(
      FunctionContext function, AnalysisContext context) async {
    var fn = new ShrubFunction(context.module, function)
      ..name = function.identifier.name;

    for (var param in function.parameters) {
      var p = new ShrubFunctionParameter(context.module, param.identifier.name,
          context.moduleSystemView.coreModule.unknownType, param.span);
      fn.parameters.add(p);
      function.scope.create(p.name, value: p, constant: true);
    }

    await analyzeExpression(function.expression, function.scope, context);
    fn.returnType = function.expression.resolved.type;
    return fn;
  }

  Future<SymbolTable<ShrubObject>> analyzeExpression(
      ExpressionContext expression,
      SymbolTable<ShrubObject> scope,
      AnalysisContext context) async {
    if (expression.resolved != null) return scope;

    if (expression is IntegerLiteralContext) {
      expression.resolved = new ShrubObject(context.module,
          context.moduleSystemView.coreModule.integerType, expression.span);
      return scope;
    }

    throw new UnimplementedError(
        'Cannot yet analyze ${expression.runtimeType}!!!');
  }
}
