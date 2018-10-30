import 'package:shrub/shrub.dart';

abstract class IntegerType extends ShrubType {
  final int size;

  IntegerType(Module module, this.size, [String name])
      : super(module, name ?? 'Int$size');
}

class Integer8Type extends IntegerType {
  Integer8Type(Module module) : super(module, 8);
}

class Integer16Type extends IntegerType {
  Integer16Type(Module module) : super(module, 16);
}

class Integer32Type extends IntegerType {
  Integer32Type(Module module) : super(module, 32);
}

class Integer64Type extends IntegerType {
  Integer64Type(Module module) : super(module, 64);
}

abstract class UnsignedIntegerType extends IntegerType {
  final int size;

  UnsignedIntegerType(Module module, this.size)
      : super(module, size, 'Uint$size');
}

class UnsignedInteger8Type extends UnsignedIntegerType {
  UnsignedInteger8Type(Module module) : super(module, 8);
}

class UnsignedInteger16Type extends UnsignedIntegerType {
  UnsignedInteger16Type(Module module) : super(module, 16);
}

class UnsignedInteger32Type extends UnsignedIntegerType {
  UnsignedInteger32Type(Module module) : super(module, 32);
}

class UnsignedInteger64Type extends UnsignedIntegerType {
  UnsignedInteger64Type(Module module) : super(module, 64);
}
