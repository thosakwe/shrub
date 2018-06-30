import 'package:shrub/shrub.dart';

/// An arbitrary view of the global module system.
abstract class ModuleSystemView {
  ShrubPackage findPackage(String name, String version);

  ShrubPackage findQualifiedPackage(String qualifiedName, String version) {
    var parts = qualifiedName.split('::');
    var pkg = findPackage(parts[0], version);

    for (var part in parts.skip(1)) {
      pkg = pkg.children.putIfAbsent(
          part,
          () => new ShrubPackage(
              pkg, pkg.directory.child(part), part, pkg.version));
    }

    return pkg;
  }
}
