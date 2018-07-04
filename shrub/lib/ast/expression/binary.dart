import 'package:shrub/shrub.dart';
import 'package:source_span/src/file.dart';

class BinaryContext extends ExpressionContext {
  final FileSpan span;
  final ExpressionContext left;
  final Token operator;
  final ExpressionContext right;

  BinaryContext(this.span, this.left, this.operator, this.right);
}
