import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

class ShrubPackage {
  final Map<String, ShrubPackage> children = {};
  final SymbolTable<ShrubObject> scope = new SymbolTable<ShrubObject>();
  final List<ShrubType> types = [];
  final ShrubPackage parent;
  final ShrubDirectory directory;
  final String name;
  final String version;

  // final CompilationUnit compilationUnit;

  ShrubPackage(this.parent, this.directory, this.name, this.version);

  String get qualifiedName =>
      parent == null ? name : '${parent.qualifiedName}::$name';
}
