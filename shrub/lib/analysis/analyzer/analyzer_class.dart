import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:string_scanner/string_scanner.dart';
import 'package:symbol_table/symbol_table.dart';

class Analyzer {
  final ModuleSystem moduleSystem;
  ExpressionAnalyzer _expressionAnalyzer;
  FunctionAnalyzer _functionAnalyzer;

  Analyzer(this.moduleSystem);

  ExpressionAnalyzer get expressionAnalyzer => _expressionAnalyzer ??= new ExpressionAnalyzer(this);

  FunctionAnalyzer get functionAnalyzer => _functionAnalyzer ??= new FunctionAnalyzer(this);

  // TODO: Support for resolving deltas, etc.
  Future<AnalysisResult> analyze(AnalysisContext context) async {
    var errors = <ShrubException>[];

    await for (var file in context.module.directory.listShrubFiles()) {
      var scanner = new SpanScanner(await file.read(), sourceUrl: file.path);
      var lexer = new Lexer(scanner)..scan();
      var parser = new Parser(lexer);
      var unit = parser.parseCompilationUnit();
      errors.addAll(parser.errors);

      if (unit != null) {
        for (var function in unit.functions) {
          function.scope ??= context.module.scope.createChild();
          var fn = await functionAnalyzer.analyze(function, context);
          context.module.scope.create(fn.name, value: fn, constant: true);
        }
      }
    }

    return new AnalysisResult(context, errors);
  }



}
