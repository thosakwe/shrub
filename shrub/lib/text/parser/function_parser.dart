import 'package:shrub/shrub.dart';

class FunctionParser {
  final Parser parser;

  FunctionParser(this.parser);

  FunctionContext parseFunction() {
    var fn = parser.nextToken(TokenType.fn), span = fn?.span, lastSpan = span;
    if (fn == null) return null;

    var id = parser.nextSimpleIdentifier();

    if (id == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing name for function.'));
      return null;
    }

    span = span.expand(lastSpan = id.span);

    var parameters = <ParameterContext>[];

    var lBracket = parser.nextToken(TokenType.lBracket);

    if (lBracket != null) {
      span = span.expand(lastSpan = lBracket.span);

      var parameter = parseParameter();

      while (parameter != null) {
        span = span.expand(lastSpan = parameter.span);
        parameters.add(parameter);
        var comma = parser.nextToken(TokenType.comma);
        if (comma == null) break;
        span = span.expand(lastSpan = comma.span);
        parameter = parseParameter();
      }

      var rBracket = parser.nextToken(TokenType.rBracket);

      if (rBracket == null) {
        parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
            lastSpan, 'Missing "]" in function definition.'));
        return null;
      }

      span = span.expand(lastSpan = rBracket.span);
    }

    var arrow = parser.nextToken(TokenType.arrow);

    if (arrow == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing "=>" in function definition.'));
      return null;
    }

    span = span.expand(lastSpan = arrow.span);

    var expression = parser.expressionParser.parseExpression();

    if (expression == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing body for function.'));
      return null;
    }

    return new FunctionContext(span.expand(expression.span), id, expression)
      ..parameters.addAll(parameters);
  }

  ParameterContext parseParameter() {
    var id = parser.nextSimpleIdentifier();
    return id == null ? null : new ParameterContext(id);
  }
}
