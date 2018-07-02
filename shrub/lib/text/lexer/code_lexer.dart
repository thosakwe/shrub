import 'package:shrub/shrub.dart';
import 'package:string_scanner/string_scanner.dart';

final RegExp doubleQuotedString = new RegExp(
    r'"((\\(["\\/bfnrt]|(u[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])))|([^"\\]))*"');

final RegExp singleQuotedString = new RegExp(
    r"'((\\(['\\/bfnrt]|(u[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])))|([^'\\]))*'");

class CodeLexer {
  final Lexer lexer;

  CodeLexer(this.lexer);

  static final RegExp _whitespace = new RegExp(r'[ \n\r\t]+');

  static final Map<Pattern, TokenType> _patterns = {
    // Symbols
    '=>': TokenType.arrow,
    ',': TokenType.comma,
    '[': TokenType.lBracket,
    ']': TokenType.rBracket,
    '{': TokenType.lCurly,
    '}': TokenType.rCurly,
    '(': TokenType.lParen,
    ')': TokenType.rParen,
    ';': TokenType.semicolon,

    // Unary
    '..': TokenType.spread2,
    '...': TokenType.spread3,
    '++': TokenType.increment,
    '--': TokenType.decrement,
    '!': TokenType.not,
    '~': TokenType.tilde,

    // Arithmetic
    '=': TokenType.equals,
    '**': TokenType.exponent,
    '*': TokenType.times,
    '/': TokenType.divide,
    '%': TokenType.modulo,
    '+': TokenType.plus,
    '-': TokenType.minus,

    // Boolean
    '&&': TokenType.booleanAnd,
    '||': TokenType.booleanOr,

    // Bitwise
    '^': TokenType.xor,
    '&': TokenType.and,
    '|': TokenType.or,
    '<<': TokenType.shiftLeft,
    '>>': TokenType.shiftRight,

    // Keywords
    'as': TokenType.as_,
    'fn': TokenType.fn,
    'import': TokenType.import_,
    'match': TokenType.match,
    'with': TokenType.with_,

    // Data
    new RegExp(r'0b([0-1]+)'): TokenType.radix2,
    new RegExp(r'0o([0-7]+)'): TokenType.radix8,
    new RegExp(r'([0-9]+)'): TokenType.radix10,
    new RegExp(r'([0-9]+)E|e(-?[0-9]+)'): TokenType.radix10,
    new RegExp(r'0x([A-Fa-f0-9]+)'): TokenType.radix16,
    new RegExp(r'[0-9]+\.[0-9]+'): TokenType.radix10,
    singleQuotedString: TokenType.string,
    doubleQuotedString: TokenType.string,
    new RegExp(r'[A-Za-z_][A-Za-z0-9_]*'): TokenType.id,
  };

  void scan() {
    lexer.scanner.scan(_whitespace);

    LineScannerState _unexpectedStart;

    void flush() {
      if (_unexpectedStart != null) {
        var span = lexer.scanner.spanFrom(_unexpectedStart);
        lexer.errors.add(new ShrubException(
            ShrubExceptionSeverity.error, span, "Unexpected text."));
        _unexpectedStart = null;
      }
    }

    while (!lexer.scanner.isDone) {
      var matches = <Token>[];

      _patterns.forEach((pattern, type) {
        if (lexer.scanner.matches(pattern)) {
          matches.add(
              new Token(type, lexer.scanner.lastSpan, lexer.scanner.lastMatch));
        }
      });

      if (matches.isEmpty) {
        _unexpectedStart ??= lexer.scanner.state;
        lexer.scanner.readChar();
      } else {
        flush();
        matches.sort((a, b) => b.span.length.compareTo(a.span.length));

        var token = matches.first;
        lexer
          ..tokens.add(token)
          ..scanner.scan(token.span.text);
      }

      lexer.scanner.scan(_whitespace);
    }

    flush();
  }
}
