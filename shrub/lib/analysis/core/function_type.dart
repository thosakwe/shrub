import 'package:shrub/shrub.dart';

class FunctionType extends ShrubType {
  final List<ShrubType> parameters = [];
  ShrubType returnType;

  FunctionType(Module package, String name) : super(package, name);

  @override
  String get qualifiedName {
    var paramString =
        '(' + parameters.map((t) => t.qualifiedName).join(', ') + ')';
    return paramString + ' => ' + returnType.qualifiedName;
  }

  @override
  bool isAssignableFrom(ShrubType other) {
    if (other is! FunctionType) return false;
    var fn = other as FunctionType;

    for (int i = 0; i < parameters.length; i++) {
      if (!parameters[i].isAssignableFrom(fn.parameters[i])) return false;
    }

    return returnType.isAssignableFrom(fn.returnType);
  }
}
