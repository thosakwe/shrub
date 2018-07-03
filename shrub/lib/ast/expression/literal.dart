import 'dart:math' as math;
import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class IntegerLiteralContext extends ExpressionContext<int> {
  final Token token;

  IntegerLiteralContext(this.token);

  @override
  FileSpan get span => token.span;

  @override
  bool get hasConstantValue => true;

  @override
  int getConstantValue(void Function(ShrubException) onError) {
    try {
      switch (token.type) {
        case TokenType.radix2:
          return int.parse(token.match[1], radix: 2);
        case TokenType.radix8:
          return int.parse(token.match[1], radix: 8);
        case TokenType.radix10:
          return int.parse(token.match[0], radix: 10);
        case TokenType.radix16:
          return int.parse(token.match[1], radix: 16);
        case TokenType.pow10:
          return math
              .pow(int.parse(token.match[1]), int.parse(token.match[2]))
              .toInt();
        default:
          throw new FormatException('Cannot parse a token of type `${token
              .type}` as a constant integer.');
      }
    } on FormatException catch (e) {
      onError(
          new ShrubException(ShrubExceptionSeverity.error, span, e.message));
      return null;
    }
  }
}
