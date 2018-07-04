import 'package:shrub/shrub.dart';

abstract class PrefixParselet<T> {
  ExpressionContext<T> parse(Parser parser, Token token);

  static const Map<TokenType, PrefixParselet> all = {
    TokenType.radix2: IntegerLiteralParser(),
    TokenType.radix8: IntegerLiteralParser(),
    TokenType.radix10: IntegerLiteralParser(),
    TokenType.radix16: IntegerLiteralParser(),
    TokenType.pow10: IntegerLiteralParser(),
    TokenType.float_: FloatLiteralParser(),
    TokenType.id: SimpleIdentifierParser(),
  };
}
