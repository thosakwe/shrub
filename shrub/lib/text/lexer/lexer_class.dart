import 'dart:collection';
import 'package:shrub/shrub.dart';
import 'package:string_scanner/string_scanner.dart';

class ShrubLexer {
  final List<ShrubException> errors = <ShrubException>[];
  final Queue<ShrubLexerMode> modes = new Queue<ShrubLexerMode>();
  final List<Token> tokens = <Token>[];
  final SpanScanner scanner;

  ShrubCodeLexer _codeLexer;

  ShrubLexer(this.scanner) {
    modes.addFirst(new ShrubLexerMode(ShrubLexerModeType.code));
  }

  ShrubCodeLexer get codeLexer => _codeLexer ??= new ShrubCodeLexer(this);

  void scan() {
    while (modes.isNotEmpty) {
      var mode = modes.removeFirst();

      switch (mode.type) {
        case ShrubLexerModeType.code:
          codeLexer.scan();
          break;
        default:
          throw new UnsupportedError(mode.type.toString());
      }
    }
  }
}
