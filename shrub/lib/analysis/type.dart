import 'package.dart';

class ShrubType {
  final ShrubPackage package;
  final String name;

  // final TypeContext declaration;

  ShrubType(this.package, this.name);

  String get qualifiedName => '${package.qualifiedName}::$name';

  bool isAssignableFrom(ShrubType other) =>
      other.qualifiedName == qualifiedName;
}
