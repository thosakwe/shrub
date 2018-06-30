import 'dart:collection';
import 'package:shrub/shrub.dart';
import 'package:string_scanner/string_scanner.dart';

class Lexer {
  final List<ShrubException> errors = <ShrubException>[];
  final Queue<LexerMode> modes = new Queue<LexerMode>();
  final List<Token> tokens = <Token>[];
  final SpanScanner scanner;

  CodeLexer _codeLexer;

  Lexer(this.scanner) {
    modes.addFirst(new LexerMode(LexerModeType.code));
  }

  CodeLexer get codeLexer => _codeLexer ??= new CodeLexer(this);

  void scan() {
    while (modes.isNotEmpty) {
      var mode = modes.removeFirst();

      switch (mode.type) {
        case LexerModeType.code:
          codeLexer.scan();
          break;
        default:
          throw new UnsupportedError(mode.type.toString());
      }
    }
  }
}
