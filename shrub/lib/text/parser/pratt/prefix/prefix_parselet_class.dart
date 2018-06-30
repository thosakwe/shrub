import 'package:shrub/shrub.dart';

abstract class PrefixParselet<T> {
  ExpressionContext<T> parse(Parser parser, Token token);

  static const Map<TokenType, PrefixParselet> all = {
    TokenType.radix2: ShrubIntegerLiteralParser(),
    TokenType.radix8: ShrubIntegerLiteralParser(),
    TokenType.radix10: ShrubIntegerLiteralParser(),
    TokenType.radix16: ShrubIntegerLiteralParser(),
    TokenType.pow10: ShrubIntegerLiteralParser(),
  };
}
