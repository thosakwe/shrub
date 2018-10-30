import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

class BinaryAnalyzer {
  final Analyzer analyzer;
  final ExpressionAnalyzer expressionAnalyzer;

  BinaryAnalyzer(this.analyzer, this.expressionAnalyzer);

  Future<SymbolTable<ShrubObject>> analyze(BinaryContext expression,
      SymbolTable<ShrubObject> scope, AnalysisContext context) async {
    // TODO: Support boolean
    scope = await expressionAnalyzer.analyze(expression.left, scope, context);

    if (expression.left.resolved == null) {
      context.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          expression.left.span,
          'Encountered an error while resolving the left side of this "${expression.operator.span.text}" expression.'));
      return scope;
    }

    scope = await expressionAnalyzer.analyze(expression.right, scope, context);

    if (expression.right.resolved == null) {
      context.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          expression.right.span,
          'Encountered an error while resolving the right side of this "${expression.operator.span.text}" expression.'));
      return scope;
    }

    var resolvedLeft = expression.left.resolved;
    var resolvedRight = expression.right.resolved;
    var left = resolvedLeft.type, right = resolvedRight.type;

    // TODO: Support floats
    if (resolvedLeft is ShrubFunctionParameter &&
        resolvedLeft.type is UnknownType) {
      if (right is UnknownType) {
        context.errors.add(new ShrubException(
            ShrubExceptionSeverity.error,
            expression.left.span,
            'Cannot infer which type of value this ' +
                '"${expression.operator.span.text}" operation produces.',
            'The left side, the parameter "${resolvedLeft.name}", ' +
                'has not been given an explicit type; therefore, Shrub ' +
                'attempted to resolve the type of the right side, and ' +
                'use it to deduce the type of "${resolvedLeft.name}". ' +
                'However, an error occurred in doing so, and thus the type of the '
                'right side is completely unknown.'));
        return scope;
      } else {
        left = resolvedLeft.type = right;
      }
    } else if (left is! IntegerType && left is! FloatType) {
      context.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          expression.left.span,
          'Cannot apply the operation ' +
              '"${expression.operator.span.text}" ' +
              'to a value of type ' +
              '`${left.qualifiedName}`, ' +
              'because it is not an integer or float.'));
      return scope;
    }

    if (resolvedRight is ShrubFunctionParameter &&
        resolvedRight.type is UnknownType) {
      right = resolvedRight.type = left;
    } else if (!left.isExactly(right)) {
      context.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          expression.operator.span,
          'Cannot apply the operation "${expression.operator.span.text}" ' +
              'to two objects of incompatible types.',
          'While the left side resolves to `${left.qualifiedName}`' +
              ', the right side resolves to `${right.qualifiedName}`. ' +
              'Therefore, the operation ' +
              '"${expression.operator.span.text}" is disallowed.'));
      return scope;
    }
    ;

    if (left is IntegerType) {
      expression.resolved = new Binary(
        context.module,
        left,
//        context.moduleSystemView.coreModule
//            .chooseSmallestIntegerType(left, right as IntegerType),
        expression,
        resolvedLeft,
        expression.operator,
        resolvedRight,
      );
    } else if (left is FloatType) {
      expression.resolved = new Binary(
        context.module,
        context.moduleSystemView.coreModule.floatType,
        expression,
        resolvedLeft,
        expression.operator,
        resolvedRight,
      );
    }

    return scope;
  }
}
