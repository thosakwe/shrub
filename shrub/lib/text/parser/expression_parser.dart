import 'package:shrub/shrub.dart';

class ShrubExpressionParser {
  final ShrubParser parser;

  ShrubExpressionParser(this.parser);

  ExpressionContext parseExpression([int precedence = 0]) {
    var token = parser.peek();
    var prefixParser = PrefixParselet.all[token.type];

    if (prefixParser == null)
      return null;
    else {
      // TODO: Infix
      return prefixParser.parse(parser, token);
    }
  }
}
