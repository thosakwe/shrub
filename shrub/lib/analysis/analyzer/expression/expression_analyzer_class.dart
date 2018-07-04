import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

class ExpressionAnalyzer {
  final Analyzer analyzer;
  BinaryExpressionAnalyzer _binaryExpressionAnalyzer;

  ExpressionAnalyzer(this.analyzer);

  BinaryExpressionAnalyzer get binaryExpressionAnalyzer =>
      _binaryExpressionAnalyzer ??=
          new BinaryExpressionAnalyzer(analyzer, this);

  Future<SymbolTable<ShrubObject>> analyze(ExpressionContext expression,
      SymbolTable<ShrubObject> scope, AnalysisContext context) async {
    if (expression.resolved != null) return scope;

    if (expression is LiteralContext) {
      return await analyzeLiteral(expression, scope, context);
    }

    if (expression is IdentifierContext) {
      return await analyzeIdentifier(expression, scope, context);
    }

    if (expression is BinaryExpressionContext) {
      return await binaryExpressionAnalyzer.analyze(expression, scope, context);
    }

    throw new UnimplementedError(
        'Cannot yet analyze ${expression.runtimeType}!!!');
  }

  Future<SymbolTable<ShrubObject>> analyzeLiteral(LiteralContext expression,
      SymbolTable<ShrubObject> scope, AnalysisContext context) async {
    if (expression is IntegerLiteralContext) {
      var constantValue = expression.getConstantValue(context.errors.add);

      if (constantValue != null) {
        expression.resolved = new ShrubObject(
            context.module,
            context.moduleSystemView.coreModule.chooseIntegerType(
              constantValue,
              expression.span,
              context.errors.add,
            ),
            expression.span);
      }

      return scope;
    }

    if (expression is FloatLiteralContext) {
      var constantValue = expression.getConstantValue(context.errors.add);

      if (constantValue != null) {
        expression.resolved = new ShrubObject(context.module,
            context.moduleSystemView.coreModule.floatType, expression.span);
      }

      return scope;
    }

    throw new UnimplementedError(
        'Cannot yet analyze ${expression.runtimeType}!!!');
  }

  Future<SymbolTable<ShrubObject>> analyzeIdentifier(
      IdentifierContext expression,
      SymbolTable<ShrubObject> scope,
      AnalysisContext context) async {
    if (expression is SimpleIdentifierContext) {
      var symbol = scope[expression.name];

      if (symbol == null) {
        context.errors.add(new ShrubException(
            ShrubExceptionSeverity.error,
            expression.span,
            'The name "${expression.name}" does not exist in this context.'));
      } else {
        expression.resolved = symbol.value;
      }

      return scope;
    }

    throw new UnimplementedError(
        'Cannot yet analyze ${expression.runtimeType}!!!');
  }
}
