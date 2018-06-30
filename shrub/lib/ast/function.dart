import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class FunctionContext {
  final List<ParameterContext> parameters = [];
  final SourceSpan span;
  final IdentifierContext name;
  final ExpressionContext expression;

  FunctionContext(this.span, this.name, this.expression);
}

class ParameterContext {
  final IdentifierContext identifier;

  ParameterContext(this.identifier);

  SourceSpan get span => identifier.span;
}
