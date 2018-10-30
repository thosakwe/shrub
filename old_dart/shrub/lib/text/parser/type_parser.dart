import 'package:shrub/shrub.dart';

class TypeParser {
  final Parser parser;

  TypeParser(this.parser);

  TypeContext parse([int precedence = 0]) {
    // TODO: Pratt
    return parsePrefix();
  }

  TypeContext parsePrefix() {
    var peek = parser.peek();

    if (peek?.type == TokenType.id) {
      return parseIdentifierType();
    } else if (peek?.type == TokenType.lCurly) {
      return parseStructType();
    } else {
      return null;
    }
  }

  IdentifierTypeContext parseIdentifierType() {
    var id = parser.nextSimpleIdentifier();
    return id == null ? null : new IdentifierTypeContext(id);
  }

  StructTypeContext parseStructType() {
    var lCurly = parser.nextToken(TokenType.lCurly),
        span = lCurly?.span,
        lastSpan = span;
    if (lCurly == null) return null;

    var fields = <StructFieldContext>[];
    var field = parseStructField();

    while (field != null) {
      span = span.expand(lastSpan = field.span);
      fields.add(field);
      var comma = parser.nextToken(TokenType.comma);

      if (comma == null)
        break;
      else {
        span = span.expand(lastSpan = comma.span);
        field = parseStructField();
      }
    }

    var rCurly = parser.nextToken(TokenType.rCurly);

    if (rCurly == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          lastSpan, 'Missing "}" at the end of struct type definition.'));
      return null;
    }

    span = span.expand(lastSpan = rCurly.span);
    return new StructTypeContext(span, fields);
  }

  StructFieldContext parseStructField() {
    var id = parser.nextSimpleIdentifier(), span = id?.span;
    if (id == null) return null;

    var colon = parser.nextToken(TokenType.colon);

    if (colon == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          id.span, 'Missing ":" in struct field definition.'));
      return null;
    }

    span = span.expand(colon.span);
    var type = parser.typeParser.parse();

    if (type == null) {
      parser.errors.add(new ShrubException(ShrubExceptionSeverity.error,
          colon.span, 'Missing type for field "${id.name}".'));
      return null;
    }

    return new StructFieldContext(span.expand(type.span), id, type);
  }
}
