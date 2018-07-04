import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class CoreModule extends Module {
  IntegerType _integer32Type;
  IntegerType _integer64Type;
  FloatType _float32Type;
  FloatType _float64Type;
  UnknownType _unknownType;

  CoreModule() : super(null, const ShrubEmptyDirectory(), 'Core', '1.0.0') {
    types.add(_integer32Type = new Integer32Type(this));
    types.add(_integer64Type = new Integer64Type(this));
    types.add(_float32Type = new Float32Type(this));
    types.add(_float64Type = new Float64Type(this));
    types.add(_unknownType = new UnknownType(this));
  }

  IntegerType get integer32Type => _integer32Type;

  IntegerType get integer64Type => _integer64Type;

  FloatType get float32Type => _float32Type;

  FloatType get float64Type => _float64Type;

  UnknownType get unknownType => _unknownType;

  ShrubType chooseIntegerType(
      int value, FileSpan span, void Function(ShrubException) onError) {
    if (value.bitLength <= 32) {
      return integer32Type;
    } else if (value.bitLength <= 64) {
      return integer64Type;
    } else {
      onError(new ShrubException(ShrubExceptionSeverity.error, span,
          'The integer value "$value" is too large to fit into 64 bits.'));
      return unknownType;
    }
  }

// TODO: How to potentially handle overflows???
  IntegerType chooseSmallestIntegerType(IntegerType left, IntegerType right) {
    if (left is Integer32Type && right is Integer32Type) {
      return left;
    }

    return [left, right].firstWhere((t) => t is Integer64Type);
  }

  ShrubType chooseFloatType(
      int value, FileSpan span, void Function(ShrubException) onError) {
    if (value.bitLength <= 32) {
      return float32Type;
    } else if (value.bitLength <= 64) {
      return float64Type;
    } else {
      onError(new ShrubException(ShrubExceptionSeverity.error, span,
          'The float value "$value" is too large to fit into 64 bits.'));
      return unknownType;
    }
  }

// TODO: How to potentially handle overflows???
  FloatType chooseSmallestFloatType(FloatType left, FloatType right) {
    if (left is Float32Type && right is Float32Type) {
      return left;
    }

    return [left, right].firstWhere((t) => t is Float64Type);
  }
}
