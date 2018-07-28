import 'package:shrub/shrub.dart';

class ObjectType extends ShrubType {
  final Map<String, ShrubType> fields = {};

  ObjectType(Module package) : super(package, null);

  @override
  String get name {
    var fieldString = fields.entries
        .map((entry) => '${entry.key}: ${entry.value.name}')
        .join(', ');
    return '{ ' + fieldString + ' }';
  }

  @override
  String get qualifiedName {
    var fieldString = fields.entries
        .map((entry) => '${entry.key}: ${entry.value.qualifiedName}')
        .join(', ');
    return '{ ' + fieldString + ' }';
  }

  @override
  bool isAssignableFrom(ShrubType other) {
    if (other is! ObjectType) return false;
    var obj = other as ObjectType;

    for (var key in fields.keys) {
      if (!fields[key].isAssignableFrom(obj.fields[key])) return false;
    }

    return true;
  }
}
