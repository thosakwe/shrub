import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

abstract class ExpressionContext<T> {
  FileSpan get span;

  bool get hasConstantValue => false;

  T getConstantValue(void Function(ShrubException) onError) {
    onError(new ShrubException(ShrubExceptionSeverity.error, span,
        'A(n) `$runtimeType` is not a constant expression.'));
    return null;
  }

  ShrubObject resolved;
}
