import 'package:shrub/shrub.dart';

class ShrubParser extends ShrubBaseParser {
  final List<ShrubException> errors = [];

  ShrubParser(ShrubLexer lexer) : super(lexer);
}
