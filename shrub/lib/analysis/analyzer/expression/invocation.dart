import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

class InvocationAnalyzer {
  final Analyzer analyzer;
  final ExpressionAnalyzer expressionAnalyzer;

  InvocationAnalyzer(this.analyzer, this.expressionAnalyzer);

  Future<SymbolTable<ShrubObject>> analyze(InvocationContext expression,
      SymbolTable<ShrubObject> scope, AnalysisContext context) async {
    scope = await analyzer.expressionAnalyzer
        .analyze(expression.target, scope, context);

    var target = expression.target.resolved;

    if (target == null) {
      context.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          expression.target.span,
          'Encountered an error resolving the target of this invocation.'));
      return scope;
    }

    if (target is! ShrubFunction) {
      context.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          expression.target.span,
          'This expression, which resolves to ' +
              '`${target.type.qualifiedName}`, .' +
              'is not a function, and therefore cannot be invoked like one.'));
      return scope;
    }
  }
}
