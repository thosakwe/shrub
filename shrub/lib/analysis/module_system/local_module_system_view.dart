import 'package:shrub/shrub.dart';

/// A view of the global module system, from the perspective of a certain
/// [package].
///
/// This is the basis of encapsulation of Shrub modules.
class LocalModuleSystemView extends ModuleSystemView {
  final ModuleSystemView moduleSystem;
  final ShrubPackage package;

  LocalModuleSystemView(this.moduleSystem, this.package);

  @override
  ShrubPackage findPackage(String name, String version) {
    return package.children[name] ?? moduleSystem.findPackage(name, version);
  }
}
