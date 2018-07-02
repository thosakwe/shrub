import 'package:shrub/shrub.dart';

abstract class InfixParselet<T> {
  int get precedence;

  ExpressionContext<T> parse(
      Parser parser, ExpressionContext left, Token token);

  static const Map<TokenType, InfixParselet> all = const {
    TokenType.exponent: const BinaryExpressionParselet(5),
    TokenType.times: const BinaryExpressionParselet(4),
    TokenType.divide: const BinaryExpressionParselet(3),
    TokenType.modulo: const BinaryExpressionParselet(2),
    TokenType.plus: const BinaryExpressionParselet(1),
    TokenType.minus: const BinaryExpressionParselet(0),
    // TODO: Bitwise, boolean
  };
}
