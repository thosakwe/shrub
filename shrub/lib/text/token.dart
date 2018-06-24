import 'package:source_span/source_span.dart';

class Token {
  final TokenType type;
  final FileSpan span;
  final Match match;

  Token(this.type, this.span, this.match);
}

enum TokenType {
  // Symbols
  comma,
  lBracket,
  rBracket,
  lCurly,
  rCurly,
  lParen,
  rParen,
  semicolon,

  // Unary
  spread2,
  spread3,
  increment,
  not,
  tilde,

  // Arithmetic
  equals,
  exponent,
  times,
  divide,
  plus,
  minus,

  // Boolean
  booleanAnd,
  booleanOr,

  // Bitwise
  xor,
  and,
  or,
  shiftLeft,
  shiftRight,

  // Keywords
  as_,
  fn,
  import_,
  match_,
  with_,

  // Data
  binary,
  hex,
  octal,
  number,
  id,
}
