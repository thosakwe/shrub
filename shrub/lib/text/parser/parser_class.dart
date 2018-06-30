import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class Parser extends BaseParser {
  final List<ShrubException> errors = [];

  ExpressionParser _expressionParser;
  FunctionParser _functionParser;

  Parser(Lexer lexer) : super(lexer);

  ExpressionParser get expressionParser =>
      _expressionParser ??= new ExpressionParser(this);

  FunctionParser get functionParser =>
      _functionParser ??= new FunctionParser(this);

  CompilationUnitContext parseCompilationUnit() {
    var functions = <FunctionContext>[];
    FunctionContext function;
    FileSpan span;

    while (!done) {
      function = functionParser.parseFunction();

      if (function == null) {
        if (!done) {
          var token = consume();
          if (token != null) {
            errors.add(new ShrubException(
                ShrubExceptionSeverity.error, token.span, "Unexpected text."));
          }
        }
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
