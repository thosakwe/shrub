import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

class InvocationAnalyzer {
  final Analyzer analyzer;
  final ExpressionAnalyzer expressionAnalyzer;

  InvocationAnalyzer(this.analyzer, this.expressionAnalyzer);

  Future<SymbolTable<ShrubObject>> analyze(InvocationContext expression,
      SymbolTable<ShrubObject> scope, AnalysisContext context) async {}
}
