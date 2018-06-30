import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

abstract class IdentifierContext extends ExpressionContext {
  String get name;
}

class SimpleIdentifierContext extends IdentifierContext {
  final FileSpan span;

  SimpleIdentifierContext(this.span);

  @override
  String get name => span.text;
}
