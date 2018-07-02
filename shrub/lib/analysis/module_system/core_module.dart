import 'package:shrub/shrub.dart';

class CoreModule extends Module {
  IntegerType _integerType;

  CoreModule() : super(null, const ShrubEmptyDirectory(), 'Core', '1.0.0') {
    types.add(_integerType = new IntegerType(this));
  }

  IntegerType get integerType => _integerType;
}
