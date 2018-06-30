class ShrubLexerMode {
  final ShrubLexerModeType type;

  ShrubLexerMode(this.type);
}

enum ShrubLexerModeType { code, string, comment }
