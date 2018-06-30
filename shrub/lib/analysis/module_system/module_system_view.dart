import 'package:shrub/shrub.dart';

/// An arbitrary view of the global module system.
abstract class ModuleSystemView {
  Module findModule(String name, String version);

  Module findQualifiedModule(String qualifiedName, String version) {
    var parts = qualifiedName.split('::');
    var pkg = findModule(parts[0], version);

    for (var part in parts.skip(1)) {
      pkg = pkg.children.putIfAbsent(
          part,
          () => new Module(
              pkg, pkg.directory.child(part), part, pkg.version));
    }

    return pkg;
  }
}
