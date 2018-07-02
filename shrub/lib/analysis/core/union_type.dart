import 'package:shrub/shrub.dart';

class UnionType extends ShrubType {
  final List<ShrubType> alternatives = [];

  UnionType(Module package) : super(package, null);

  @override
  String get name => alternatives.map((t) => name).join(' | ');

  @override
  String get qualifiedName {
    return alternatives.map((t) => t.qualifiedName).join(' | ');
  }

  @override
  bool isAssignableFrom(ShrubType other) {
    if (other is! UnionType) {
      return alternatives.any((t) => t.isAssignableFrom(other));
    }

    var union = other as UnionType;
    return union.alternatives
        .every((from) => alternatives.any((to) => to.isAssignableFrom(from)));
  }
}
