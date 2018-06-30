import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

abstract class ExpressionContext<T> {
  SourceSpan get span;

  bool get hasConstantValue => false;

  T get constantValue => throw new UnsupportedError(
      'A(n) `$runtimeType` is not a constant expression.');

  ShrubObject resolved;
}
