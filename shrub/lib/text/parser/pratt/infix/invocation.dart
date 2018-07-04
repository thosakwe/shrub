import 'package:shrub/shrub.dart';

class InvocationExpressionParselet implements InfixParselet {
  final int precedence;

  const InvocationExpressionParselet(this.precedence);

  @override
  ExpressionContext parse(Parser parser, ExpressionContext left, Token token) {
    var lastSpan = token.span, span = left.span.expand(lastSpan);
    var argument = parser.expressionParser.parseExpression();
    var arguments = <ExpressionContext>[];

    while (argument != null) {
      arguments.add(argument);
      span = span.expand(lastSpan = argument.span);
      argument = parser.expressionParser.parseExpression();
    }

    var rParen = parser.nextToken(TokenType.rParen);

    if (rParen == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing a ")" at the end of this argument list.'));
      return null;
    }

    span = span.expand(rParen.span);
    return new InvocationContext(span, left, arguments);
  }
}
