import 'package:shrub/shrub.dart';
import 'package:string_scanner/string_scanner.dart';

CompilationUnitContext parse(String string) {
  var scanner = new SpanScanner(string);
  var lexer = new ShrubLexer(scanner)..scan();
  var parser = new ShrubParser(lexer);
  var unit = parser.parseCompilationUnit();
  var errors =
      parser.errors.where((e) => e.severity == ShrubExceptionSeverity.error);

  if (errors.isNotEmpty) {
    for (var error in errors) {
      print(error);
      print(error.span.highlight());
    }

    //throw new StateError('Parse failed with ${errors.length} error(s).');
  }

  return unit;
}
