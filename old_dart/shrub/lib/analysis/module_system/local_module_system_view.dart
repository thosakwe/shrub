import 'package:shrub/shrub.dart';

/// A view of the global module system, from the perspective of a certain
/// [module].
///
/// This is the basis of encapsulation of Shrub modules.
class LocalModuleSystemView extends ModuleSystemView {
  final ModuleSystemView moduleSystem;
  final Module module;

  LocalModuleSystemView(this.moduleSystem, this.module);

  @override
  Module findModule(String name, String version) {
    return module.children[name] ?? moduleSystem.findModule(name, version);
  }
}
