import 'package:shrub/shrub.dart';

class ExpressionParser {
  final Parser parser;

  ExpressionParser(this.parser);

  int getPrecedence() =>
      InfixParselet.all[parser.peek()?.type]?.precedence ?? 0;

  ExpressionContext parseExpression([int precedence = 0]) {
    var token = parser.peek();
    if (token == null) return null;
    var prefixParser = PrefixParselet.all[token.type];

    if (prefixParser == null)
      return null;
    else {
      var left = prefixParser.parse(parser, parser.consume());

      while (left != null && precedence < getPrecedence()) {
        var token = parser.consume();
        var infix = InfixParselet.all[token.type];
        left = infix.parse(parser, left, token);
      }

      return left;
    }
  }
}
