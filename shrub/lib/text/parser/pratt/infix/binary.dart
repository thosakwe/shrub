import 'package:shrub/shrub.dart';

class BinaryExpressionParselet implements InfixParselet {
  final int precedence;

  const BinaryExpressionParselet(this.precedence);

  @override
  ExpressionContext parse(Parser parser, ExpressionContext left, Token token) {
    var right = parser.expressionParser.parseExpression();

    if (right == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          token.span, 'Missing expression after "${token.span.text}".'));
      return null;
    } else {
      return new BinaryContext(
          left.span.expand(token.span).expand(right.span), left, token, right);
    }
  }
}
