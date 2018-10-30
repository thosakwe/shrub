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
      await analyzeType(function.returnType, context);
      fn.returnType = function.returnType.resolved ??
          context.moduleSystemView.coreModule.unknownType;
    } else {
      await analyzer.expressionAnalyzer
          .analyze(function.expression, function.scope, context);
      fn.returnType = function.expression.resolved?.type ??
          context.moduleSystemView.coreModule.unknownType;
    }
    return fn;
  }

  Future analyzeType(TypeContext type, AnalysisContext context) async {
    if (type.resolved != null) return;
    type.resolved = context.moduleSystemView.coreModule.unknownType;

    if (type is IdentifierTypeContext) {
      // TODO: Search imported modules
      var module = context.module;

      while (module != null) {
        var found = module.types.firstWhere(
            (t) => t.name == type.identifier.name,
            orElse: () => null);

        if (found != null) {
          type.resolved = found;
          return;
        }

        module = module.parent;
      }
    } else if (type is StructTypeContext) {
      var structType = new ObjectType(context.module);

      for (var field in type.fields) {
        await analyzeType(field.type, context);
        field.type.resolved ??= context.moduleSystemView.coreModule.unknownType;

        if (field.type.resolved ==
            context.moduleSystemView.coreModule.unknownType) {
          context.errors.add(new ShrubException(
              ShrubExceptionSeverity.error,
              field.span,
              'Could not resolve the type of field "${field.identifier.name}".'));
        } else {
          structType.fields[field.identifier.name] = field.type.resolved;
        }
      }

      type.resolved = structType;
      return;
    }
  }
}
