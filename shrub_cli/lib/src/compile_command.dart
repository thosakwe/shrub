import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:file/local.dart';
import 'package:io/ansi.dart';
import 'package:path/path.dart' as p;
import 'package:shrub/shrub.dart';
import 'package:shrub_cli/shrub_cli.dart';

class CompileCommand extends Command {
  @override
  String get name => 'compile';

  @override
  String get description => 'Compiles Shrub code into native code.';

  CompileCommand() {
    argParser
      ..addFlag('monolithic',
          abbr: 'm',
          negatable: false,
          help: 'Whether to build the entire project into one object.')
      ..addMultiOption('define',
          abbr: 'D', help: 'Additional preprocessor definitions.');
  }

  @override
  run() async {
    var fileSystem = const ShrubBackedFileSystem(const LocalFileSystem());
    var moduleSystem =
        new ModuleSystem(fileSystem, const ShrubEmptyDirectory());
    var dir = moduleSystem.fileSystem.root;
    var module = new Module(null, dir, p.basename(dir.path), '1.0.0');
    moduleSystem.packageCache[module.name] = [module];
    var context = new AnalysisContext(
        module, new LocalModuleSystemView(moduleSystem, module));
    var analyzer = new Analyzer(moduleSystem);
    var result = await analyzer.analyze(context);

    var wasmCompiler = new WasmCompiler(result.context.module);
    var asm = wasmCompiler.compile();

    result.errors.addAll(wasmCompiler.errors);

    for (var error in result.foldErrors()) {
      AnsiCode color;

      switch (error.severity) {
        case ShrubExceptionSeverity.error:
          color = red;
          break;
        case ShrubExceptionSeverity.warning:
          color = yellow;
          break;
        case ShrubExceptionSeverity.hint:
          color = blue;
          break;
        case ShrubExceptionSeverity.info:
          color = lightGray;
          break;
      }

      stderr
        ..writeln(color.wrap(error.toString()))
        ..writeln(color.wrap(error.span.highlight()));

      if (error.additionalDetails != null) {
        stderr
          ..writeln()
          ..writeln(color.wrap(error.additionalDetails))
          ..writeln();
      }
    }

    if (result.type == AnalysisResultType.failure) {
      var length = result.criticalErrors.length;
      stderr.writeln(
          red.wrap('Compilation failed with $length critical error(s).'));
    } else {
      print(asm);
      //var wasmFile = new File(p.setExtension(module.name, '.asm'));

    }
  }
}
