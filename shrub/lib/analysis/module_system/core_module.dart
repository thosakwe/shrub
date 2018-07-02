import 'package:shrub/shrub.dart';

class CoreModule extends Module {
  IntegerType _integerType;
  UnknownType _unknownType;

  CoreModule() : super(null, const ShrubEmptyDirectory(), 'Core', '1.0.0') {
    types.add(_integerType = new IntegerType(this));
    types.add(_unknownType = new UnknownType(this));
  }

  IntegerType get integerType => _integerType;

  UnknownType get unknownType => _unknownType;
}
