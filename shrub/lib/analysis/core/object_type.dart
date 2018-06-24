import 'package:shrub/analysis/analysis.dart';

class ShrubObjectType extends ShrubType {
  final Map<String, ShrubType> fields = {};

  ShrubObjectType(ShrubPackage package, String name) : super(package, name);

  @override
  String get qualifiedName {
    var fieldString = fields.entries.map((entry) => '${entry.key}: ${entry
        .value
        .qualifiedName}').join(', ');
    return '{ ' + fieldString + ' }';
  }

  @override
  bool isAssignableFrom(ShrubType other) {
    if (other is! ShrubObjectType) return false;
    var obj = other as ShrubObjectType;

    for (var key in fields.keys) {
      if (!fields[key].isAssignableFrom(obj.fields[key])) return false;
    }

    return true;
  }
}
