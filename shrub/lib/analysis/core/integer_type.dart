import 'package:shrub/shrub.dart';

abstract class IntegerType extends ShrubType {
  final int size;

  IntegerType(Module module, this.size) : super(module, 'Integer$size');
}

class Integer32Type extends IntegerType {
  Integer32Type(Module module) : super(module, 32);
}

class Integer64Type extends IntegerType {
  Integer64Type(Module module) : super(module, 64);
}
