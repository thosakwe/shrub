import 'package:shrub/shrub.dart';

class ShrubType {
  final Module module;
  final String name;

  // final TypeContext declaration;

  ShrubType(this.module, this.name);

  String get qualifiedName => '${module.qualifiedName}::$name';

  bool isExactly(ShrubType other) => other.qualifiedName == qualifiedName;

  bool isAssignableFrom(ShrubType other) => isExactly(other);
}
