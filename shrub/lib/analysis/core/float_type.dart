import 'package:shrub/shrub.dart';

abstract class FloatType extends ShrubType {
  final int size;

  FloatType(Module module, this.size) : super(module, 'Float$size');
}

class Float32Type extends FloatType {
  Float32Type(Module module) : super(module, 32);
}

class Float64Type extends FloatType {
  Float64Type(Module module) : super(module, 64);
}
