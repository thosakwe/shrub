import 'package:shrub/shrub.dart';

class FunctionParser {
  final Parser parser;

  FunctionParser(this.parser);

  FunctionContext parseFunction() {
    if (parser.peek()?.type == TokenType.external) {
      return parseExternalFunction();
    } else {
      return parseRegularFunction();
    }
  }

  FunctionContext parseRegularFunction() {
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

    var expression = parser.expressionParser.parse();

    if (expression == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing body for function.'));
      return null;
    }

    return new FunctionContext(
        span.expand(expression.span), id, expression, null)
      ..parameters.addAll(parameters);
  }

  ParameterContext parseParameter() {
    var id = parser.nextSimpleIdentifier();
    return id == null ? null : new ParameterContext(id);
  }

  FunctionContext parseExternalFunction() {
    var external = parser.nextToken(TokenType.external),
        span = external?.span,
        lastSpan = span;
    if (external == null) return null;

    var fn = parser.nextToken(TokenType.fn);

    if (fn == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing "fn" in external function definition.'));
      return null;}

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

    // TODO: Real type parser
    var typeId = parser.nextSimpleIdentifier();

    if (typeId == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing return type in function definition.'));
      return null;
    }

    var type = new IdentifierTypeContext(typeId);

    if (type == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing return type for external function.'));
      return null;
    }

    span = span.expand(lastSpan = type.span);

    return new FunctionContext(span.expand(type.span), id, null, type)
      ..parameters.addAll(parameters);
  }
}
