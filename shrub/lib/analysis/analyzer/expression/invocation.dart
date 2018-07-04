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

    var fn = target as ShrubFunction;

    if (expression.arguments.length > fn.parameters.length) {
      context.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          expression.target.span,
          'Illegal invocation of the function ' +
              '`${fn.qualifiedName}` (${fn.type.qualifiedName}). ' +
              'You provided ${expression.arguments.length}, while ' +
              'the function can only take a maximum of ' +
              '${fn.parameters.length} argument(s).'));
      return scope;
    }

    var resolvedArguments = <String, ShrubObject>{};
    int positional = 0;

    for (var argument in expression.arguments) {
      scope = await analyzer.expressionAnalyzer
          .analyze(argument.expression, scope, context);

      if (argument.expression.resolved == null) {
        context.errors.add(new ShrubException(
            ShrubExceptionSeverity.error,
            argument.expression.span,
            'Cannot resolve this invocation expression, because one of its arguments produced an error.'));
        return scope;
      }

      ShrubFunctionParameter p;

      if (argument is ExpressionArgumentContext) {
        p = fn.parameters[positional++];
      } else if (argument is NamedArgumentContext) {
        p = fn.parameters.firstWhere(
            (pp) => pp.name == argument.identifier.name,
            orElse: () => null);

        if (p == null) {
          context.errors.add(new ShrubException(
              ShrubExceptionSeverity.error,
              argument.identifier.span,
              'The function `${fn.qualifiedName}` (${fn.type.qualifiedName}) ' +
                  'does not have any parameter named ' +
                  '"${argument.identifier.name}".'));
          return scope;
        } else if (resolvedArguments.containsKey(p.name)) {
          context.errors.add(new ShrubException(
              ShrubExceptionSeverity.error,
              argument.identifier.span,
              'A value has already been passed for the parameter ' +
                  '"${argument.identifier.name}" ' +
                  'in this invocation of the function ' +
                  '`${fn.qualifiedName}` (${fn.type.qualifiedName}).'));
          return scope;
        }
      } else {
        throw new ArgumentError(
            'Cannot analyze ${argument.runtimeType} yet!!!');
      }

      if (p != null) {
        resolvedArguments[p.name] = argument.expression.resolved;
      }
    }

    // TODO: Enforce type checking, IF the parameter has a type annotation?...
    for (var name in resolvedArguments.keys) {
      var param = fn.parameters.firstWhere((p) => p.name == name);
      var arg = resolvedArguments[name];

      if (arg is ShrubFunctionParameter) {
        arg.type = param.type;
      } else {
        param.type = arg.type;
      }
    }

    expression.resolved =
        new ShrubInvocation(context.module, fn, resolvedArguments, expression);
    return scope;
  }
}
