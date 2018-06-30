import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class FunctionContext {
  final List<ParameterContext> parameters = [];
  final FileSpan span;
  final IdentifierContext identifier;
  final ExpressionContext expression;

  FunctionContext(this.span, this.identifier, this.expression);
}

class ParameterContext {
  final IdentifierContext identifier;

  ParameterContext(this.identifier);

  FileSpan get span => identifier.span;
}
