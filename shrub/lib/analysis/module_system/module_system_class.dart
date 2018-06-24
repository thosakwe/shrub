import 'package:shrub/shrub.dart';

class ShrubModuleSystem {
  final Map<String, List<ShrubPackage>> packageCache = {};
  final ShrubFilesystem filesystem;
  final ShrubDirectory globalCacheDirectory;

  ShrubModuleSystem(this.filesystem, this.globalCacheDirectory);

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

  ShrubPackage findPackage(String name, String version) {
    var list = packageCache.putIfAbsent(name, () => []);
    var matching = list.firstWhere(
        (p) => p.version == version || version == null,
        orElse: () => null);
    if (matching != null) return matching;

    var dir =
        globalCacheDirectory.child(filesystem.context.join(name, version));
    var pkg = new ShrubPackage(null, dir, name, version);
    list.add(pkg);
    return pkg;
  }
}
