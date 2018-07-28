import 'dart:async';

import 'package:shrub/shrub.dart';

class FunctionAnalyzer {
  final Analyzer analyzer;

  FunctionAnalyzer(this.analyzer);

  Future<ShrubFunction> analyze(
      FunctionContext function, AnalysisContext context) async {
    var fn = new ShrubFunction(context.module, function)
      ..name = function.identifier.name;

    for (var param in function.parameters) {
      var p = new ShrubFunctionParameter(context.module, param.identifier.name,
          context.moduleSystemView.coreModule.unknownType, param.span);
      fn.parameters.add(p);
      function.scope.create(p.name, value: p, constant: true);
    }

    if (function.isExternal) {
      // TODO: True type resolution
      function.returnType.resolved = context.moduleSystemView.coreModule.int32Type;
      fn.returnType = function.returnType.resolved;
    } else {
      await analyzer.expressionAnalyzer
          .analyze(function.expression, function.scope, context);
      fn.returnType = function.expression.resolved?.type ??
          context.moduleSystemView.coreModule.unknownType;
    }
    return fn;
  }
}
