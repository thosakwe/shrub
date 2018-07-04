import 'dart:async';
import 'dart:convert';
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
  var dir = moduleSystem.fileSystem.root;
  var module = new Module(null, dir, p.basename(dir.path), '1.0.0');
  moduleSystem.packageCache[module.name] = [module];
  var context = new AnalysisContext(
      module, new LocalModuleSystemView(moduleSystem, module));
  var analyzer = new Analyzer(moduleSystem);
  var result = await analyzer.analyze(context);
  var wasmCompiler = new WasmCompiler(result.context.module);
  var wasm = wasmCompiler.compile();
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
    print(wasm);
    var wasmFile = new File(p.setExtension(module.name, '.wasm'));
    var wat2wasm =
        await Process.start('wat2wasm', ['-o', wasmFile.path, '/dev/stdin']);
    var wasmText =
        new Stream<List<int>>.fromIterable([utf8.encode(wasm.toString())]);
    wasmText.pipe(wat2wasm.stdin);
    wat2wasm.stdout.listen(stdout.add);
    wat2wasm.stderr.listen(stderr.add);
    var code = await wat2wasm.exitCode;

    if (code != 0) {
      stderr.writeln(red.wrap('`wat2wasm` failed with exit code $code.'));
      return;
    }

    var server = new Server();
    var s = await server.start('127.0.0.1', 3000);
    print('Listening at http://${s.address.address}:${s.port}');
  }
}
