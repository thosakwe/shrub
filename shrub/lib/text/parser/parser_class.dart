import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class ShrubParser extends ShrubBaseParser {
  final List<ShrubException> errors = [];

  ShrubExpressionParser _expressionParser;
  ShrubFunctionParser _functionParser;

  ShrubParser(ShrubLexer lexer) : super(lexer);

  ShrubExpressionParser get expressionParser =>
      _expressionParser ??= new ShrubExpressionParser(this);

  ShrubFunctionParser get functionParser =>
      _functionParser ??= new ShrubFunctionParser(this);

  CompilationUnitContext parseCompilationUnit() {
    var functions = <FunctionContext>[];
    FunctionContext function;
    FileSpan span;

    while (!done) {
      function = functionParser.parseFunction();

      if (function == null) {
        var token = consume();
        errors.add(new ShrubException(
            ShrubExceptionSeverity.error, token.span, "Unexpected text."));
      } else {
        span ??= function.span;
        span = span.expand(function.span);
        functions.add(function);
      }
    }

    if (span == null) return null;
    return new CompilationUnitContext(span)..functions.addAll(functions);
  }
}
