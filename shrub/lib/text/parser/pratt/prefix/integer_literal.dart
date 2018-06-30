import 'package:shrub/shrub.dart';

class ShrubIntegerLiteralParser implements PrefixParselet<int> {
  const ShrubIntegerLiteralParser();

  @override
  ExpressionContext<int> parse(ShrubParser parser, Token token) {
    return new IntegerLiteralContext(token);
  }
}
