import 'package:shrub/analysis/analysis.dart';
import 'package:symbol_table/symbol_table.dart';

class ShrubPackage {
  final SymbolTable<ShrubObject> scope = new SymbolTable<ShrubObject>();
  final List<ShrubType> types = [];
  final ShrubPackage parent;
  final String name;

  // final CompilationUnit compilationUnit;

  ShrubPackage(this.parent, this.name);

  String get qualifiedName =>
      parent == null ? name : '${parent.qualifiedName}::$name';
}
