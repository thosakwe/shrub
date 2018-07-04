import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class InvocationContext extends ExpressionContext {
  final FileSpan span;
  final ExpressionContext target;
  final List<ArgumentContext> arguments;

  InvocationContext(this.span, this.target, Iterable<ArgumentContext> arguments)
      : this.arguments = arguments.toList();
}

abstract class ArgumentContext {
  FileSpan get span;

  ExpressionContext get expression;
}

class ExpressionArgumentContext extends ArgumentContext {
  final ExpressionContext expression;

  ExpressionArgumentContext(this.expression);

  @override
  FileSpan get span => expression.span;
}

class NamedArgumentContext extends ArgumentContext {
  final FileSpan span;
  final IdentifierContext identifier;
  final ExpressionContext expression;

  NamedArgumentContext(this.span, this.identifier, this.expression);
}
