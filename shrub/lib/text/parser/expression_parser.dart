import 'package:shrub/shrub.dart';

class ExpressionParser {
  final Parser parser;

  ExpressionParser(this.parser);

  ExpressionContext parseExpression([int precedence = 0]) {
    var token = parser.peek();
    if (token == null) return null;
    var prefixParser = PrefixParselet.all[token.type];

    if (prefixParser == null)
      return null;
    else {
      // TODO: Infix
      return prefixParser.parse(parser, parser.consume());
    }
  }
}
