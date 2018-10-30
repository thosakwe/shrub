import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

class Module {
  final Map<String, Module> children = {};
  final SymbolTable<ShrubObject> scope = new SymbolTable<ShrubObject>();
  final List<ShrubType> types = [];
  final Module parent;
  final ShrubDirectory directory;
  final String name;
  final String version;

  // final CompilationUnit compilationUnit;

  Module(this.parent, this.directory, this.name, this.version);

  String get qualifiedName =>
      parent == null ? name : '${parent.qualifiedName}::$name';
}
