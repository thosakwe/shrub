import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class InvocationContext extends ExpressionContext {
  final FileSpan span;
  final ExpressionContext target;
  final List<ExpressionContext> arguments;

  InvocationContext(
      this.span, this.target, Iterable<ExpressionContext> arguments)
      : this.arguments = arguments.toList();
}
