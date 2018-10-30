import 'dart:async';

import 'package:build/build.dart';
import 'package:shrub/shrub.dart';
import 'package:path/path.dart' as p;
import 'filesystem.dart';

/*
Builder shrubBuilder(BuilderOptions builderOptions) =>
    new ShrubBuilder(builderOptions);

class ShrubBuilder implements Builder {
  final BuilderOptions builderOptions;

  ShrubBuilder(this.builderOptions);

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      '.shrub': ['.wat']
    };
  }

  @override
  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;
    var fileSystem = new ShrubAssetFilesystem.forBuildStep(buildStep);
    var moduleSystem = new ModuleSystem(fileSystem, const ShrubEmptyDirectory());
    var module = new Module(null, directory, name, '1.0.0');
    var moduleView = new LocalModuleSystemView(moduleSystem, module);
  }
}
*/