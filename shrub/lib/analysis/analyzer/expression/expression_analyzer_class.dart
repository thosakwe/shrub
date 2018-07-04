import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

class ExpressionAnalyzer {
  final Analyzer analyzer;
  BinaryAnalyzer _binaryAnalyzer;
  InvocationAnalyzer _invocationAnalyzer;

  ExpressionAnalyzer(this.analyzer);

  BinaryAnalyzer get binaryAnalyzer =>
      _binaryAnalyzer ??= new BinaryAnalyzer(analyzer, this);

  InvocationAnalyzer get invocationAnalyzer =>
      _invocationAnalyzer ??= new InvocationAnalyzer(analyzer, this);

  Future<SymbolTable<ShrubObject>> analyze(ExpressionContext expression,
      SymbolTable<ShrubObject> scope, AnalysisContext context) async {
    if (expression.resolved != null) return scope;

    if (expression is LiteralContext) {
      return await analyzeLiteral(expression, scope, context);
    }

    if (expression is IdentifierContext) {
      return await analyzeIdentifier(expression, scope, context);
    }

    if (expression is BinaryContext) {
      return await binaryAnalyzer.analyze(expression, scope, context);
    }

    if (expression is InvocationContext) {
      return await invocationAnalyzer.analyze(expression, scope, context);
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
        symbol.value.usages
            .add(new SymbolUsage(SymbolUsageType.read, expression.span));
      }

      return scope;
    }

    throw new UnimplementedError(
        'Cannot yet analyze ${expression.runtimeType}!!!');
  }
}
