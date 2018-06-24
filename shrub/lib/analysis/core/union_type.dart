import '../package.dart';
import '../type.dart';

class ShrubUnionType extends ShrubType {
  final List<ShrubType> alternatives = [];

  ShrubUnionType(ShrubPackage package, String name) : super(package, name);

  @override
  String get qualifiedName {
    return alternatives.map((t) => t.qualifiedName).join(' | ');
  }

  @override
  bool isAssignableFrom(ShrubType other) {
    if (other is! ShrubUnionType) {
      return alternatives.any((t) => t.isAssignableFrom(other));
    }

    var union = other as ShrubUnionType;
    return union.alternatives
        .every((from) => alternatives.any((to) => to.isAssignableFrom(from)));
  }
}
