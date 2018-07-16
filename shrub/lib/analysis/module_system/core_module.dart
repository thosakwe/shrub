import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class CoreModule extends Module {
  IntegerType _int8Type;
  IntegerType _int16Type;
  IntegerType _int32Type;
  IntegerType _int64Type;
  IntegerType _uInt8Type;
  IntegerType _uInt16Type;
  IntegerType _uInt32Type;
  IntegerType _uInt64Type;
  FloatType _floatType;
  UnknownType _unknownType;

  CoreModule() : super(null, const ShrubEmptyDirectory(), 'Core', '1.0.0') {
    types.add(_int8Type = new Integer8Type(this));
    types.add(_int16Type = new Integer16Type(this));
    types.add(_int32Type = new Integer32Type(this));
    types.add(_int64Type = new Integer64Type(this));
    types.add(_uInt8Type = new UnsignedInteger8Type(this));
    types.add(_uInt16Type = new UnsignedInteger16Type(this));
    types.add(_uInt32Type = new UnsignedInteger32Type(this));
    types.add(_uInt64Type = new UnsignedInteger64Type(this));
    types.add(_floatType = new FloatType(this));
    types.add(_unknownType = new UnknownType(this));
  }

  IntegerType get int8Type => _int8Type;

  IntegerType get int16Type => _int16Type;

  IntegerType get int32Type => _int32Type;

  IntegerType get int64Type => _int64Type;

  IntegerType get uInt8Type => _uInt8Type;

  IntegerType get uInt16Type => _uInt16Type;

  IntegerType get uInt32Type => _uInt32Type;

  IntegerType get uInt64Type => _uInt64Type;

  FloatType get floatType => _floatType;

  UnknownType get unknownType => _unknownType;
//
//  ShrubType chooseIntegerType(
//      int value, FileSpan span, void Function(ShrubException) onError) {
//    if (value.bitLength <= 32) {
//      return int32Type;
//    } else if (value.bitLength <= 64) {
//      return int64Type;
//    } else {
//      onError(new ShrubException(ShrubExceptionSeverity.error, span,
//          'The integer value "$value" is too large to fit into 64 bits.'));
//      return unknownType;
//    }
//  }
//
//// TODO: How to potentially handle overflows???
//  IntegerType chooseSmallestIntegerType(IntegerType left, IntegerType right) {
//    if (left is Integer32Type && right is Integer32Type) {
//      return left;
//    }
//
//    return [left, right].firstWhere((t) => t is Integer64Type);
//  }
}
