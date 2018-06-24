import 'dart:collection';
import 'package:string_scanner/string_scanner.dart';
import '../error.dart';
import '../token.dart';
import 'code_lexer.dart';
import 'comment_lexer.dart';
import 'lexer_mode.dart';
import 'string_lexer.dart';

class Lexer {
  final List<ShrubException> errors = <ShrubException>[];
  final Queue<LexerMode> modes = new Queue<LexerMode>();
  final List<Token> tokens = <Token>[];
  final StringScanner scanner;

  CodeLexer _codeLexer;

  Lexer(this.scanner) {
    modes.addFirst(new LexerMode(LexerModeType.code));
  }

  CodeLexer get codeLexer => _codeLexer ??= new CodeLexer(this);

  void scan() {
    if (modes.isEmpty) return;
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
