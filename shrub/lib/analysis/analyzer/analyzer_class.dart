import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:string_scanner/string_scanner.dart';
import 'package:symbol_table/symbol_table.dart';

class Analyzer {
  final ModuleSystem moduleSystem;

  Analyzer(this.moduleSystem);

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
          var fn = await analyzeFunction(function, context);
          context.module.scope.create(fn.name, value: fn, constant: true);
        }
      }
    }

    return new AnalysisResult(context, errors);
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
    fn.returnType = function.expression.resolved?.type ??
        context.moduleSystemView.coreModule.unknownType;
    return fn;
  }

  Future<SymbolTable<ShrubObject>> analyzeExpression(
      ExpressionContext expression,
      SymbolTable<ShrubObject> scope,
      AnalysisContext context) async {
    if (expression.resolved != null) return scope;

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

    if (expression is BinaryExpressionContext) {
      // TODO: Support boolean
      scope = await analyzeExpression(expression.left, scope, context);

      if (expression.left.resolved == null) {
        context.errors.add(new ShrubException(
            ShrubExceptionSeverity.error,
            expression.left.span,
            'Encountered an error while resolving the left side of this "${expression
                .operator.span.text}" expression.'));
        return scope;
      }

      scope = await analyzeExpression(expression.right, scope, context);

      if (expression.right.resolved == null) {
        context.errors.add(new ShrubException(
            ShrubExceptionSeverity.error,
            expression.right.span,
            'Encountered an error while resolving the right side of this "${expression
                .operator.span.text}" expression.'));
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
                  '"${expression.operator.span.text}" operation produces. ' +
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
      } else if (left is! IntegerType) {
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
        resolvedRight.type = left;
      } else if (!left.isExactly(right)) {
        context.errors.add(new ShrubException(
            ShrubExceptionSeverity.error,
            expression.operator.span,
            'Cannot apply the operation "${expression.operator.span.text}" ' +
                'to two objects of incompatible types. ' +
                'While the left side resolves to `${left.qualifiedName}`' +
                ', the right side resolves to `${right.qualifiedName}`. ' +
                'Therefore, the operation ' +
                '"${expression.operator.span.text}" is disallowed.'));
        return scope;
      }

      expression.resolved = new Binary(
        context.module,
        context.moduleSystemView.coreModule.chooseSmallestIntegerType(
            left as IntegerType, right as IntegerType),
        expression,
        resolvedLeft,
        expression.operator,
        resolvedRight,
      );

      return scope;
    }

    throw new UnimplementedError(
        'Cannot yet analyze ${expression.runtimeType}!!!');
  }
}
