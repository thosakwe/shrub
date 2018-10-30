import 'package:shrub/shrub.dart';

class InvocationExpressionParselet implements InfixParselet {
  final int precedence;

  const InvocationExpressionParselet(this.precedence);

  @override
  ExpressionContext parse(Parser parser, ExpressionContext left, Token token) {
    var lastSpan = token.span, span = left.span.expand(lastSpan);
    var argument = parseArgument(parser, false);
    var arguments = <ArgumentContext>[];
    bool hasNamed = false;

    while (argument != null) {
      hasNamed = hasNamed || argument is NamedArgumentContext;
      arguments.add(argument);
      span = span.expand(lastSpan = argument.span);
      argument = parseArgument(parser, hasNamed);
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

  ArgumentContext parseArgument(Parser parser, bool hasNamed) {
    var id = parser.nextSimpleIdentifier();

    if (id == null) {
      return hasNamed ? null : parseExpressionArgument(parser);
    } else {
      return parseNamedArgument(parser, id, hasNamed);
    }
  }

  ExpressionArgumentContext parseExpressionArgument(Parser parser) {
    var expr = parser.expressionParser.parse();
    return expr == null ? null : new ExpressionArgumentContext(expr);
  }

  ArgumentContext parseNamedArgument(
      Parser parser, IdentifierContext identifier, bool hasNamed) {
    var lastSpan = identifier.span, span = lastSpan;
    var equals = parser.nextToken(TokenType.equals);

    if (equals == null) {
      if (!hasNamed) {
        return new ExpressionArgumentContext(identifier);
      } else {
        parser.errors.add(new ShrubException(
            ShrubExceptionSeverity.error,
            lastSpan,
            'Missing "=" after identifier "${identifier.name}" ' +
                'in function invocation expression.'));
        return null;
      }
    }

    span = span.expand(lastSpan = equals.span);

    var expr = parser.expressionParser.parse();

    if (expr == null) {
      parser.errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          lastSpan,
          'Missing expression after "=" in function invocation expression.'));
      return null;
    }

    return new NamedArgumentContext(span, identifier, expr);
  }
}
