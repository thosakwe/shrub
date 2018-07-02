import 'dart:io';

import 'package:args/args.dart';
import 'package:shrub/shrub.dart';
import 'package:shrub_cli/shrub_cli.dart';
import 'package:file/local.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart' as p;

main() async {
  var fileSystem = const ShrubBackedFileSystem(const LocalFileSystem());
  var moduleSystem = new ModuleSystem(fileSystem, const ShrubEmptyDirectory());
  var module = new Module(null, moduleSystem.fileSystem.root, 'todo', '1.0.0');
  moduleSystem.packageCache[module.name] = [module];
  var context = new AnalysisContext(
      module, new LocalModuleSystemView(moduleSystem, module));
  var analyzer = new Analyzer(moduleSystem);
  var result = await analyzer.analyze(context);

  if (result.type == AnalysisResultType.failure) {
    for (var error in result.foldErrors()) {
      stderr
        ..writeln(red.wrap(error.toString()))
        ..writeln(red.wrap(error.span.highlight()));
    }
  } else {

  }
}
