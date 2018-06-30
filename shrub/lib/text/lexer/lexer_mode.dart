class LexerMode {
  final LexerModeType type;

  LexerMode(this.type);
}

enum LexerModeType { code, string, comment }
