import 'package:shrub/shrub.dart';

class Binary extends ShrubObject {
  final ShrubObject left;
  final Token operator;
  final ShrubObject right;
  final BinaryContext declaration;

  Binary(Module module, ShrubType type, this.declaration, this.left,
      this.operator, this.right)
      : super(module, type, declaration.span);
}
