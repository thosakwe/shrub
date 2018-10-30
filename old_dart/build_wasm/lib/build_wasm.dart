import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:build/build.dart';
import 'package:scratch_space/scratch_space.dart';

Builder wasmBuilder(BuilderOptions builderOptions) =>
    new _WasmBuilder(builderOptions);

final Resource<ScratchSpace> _scratchSpace = new Resource<ScratchSpace>(
    () => new ScratchSpace(),
    dispose: (old) => old.delete());

class _WasmBuilder implements Builder {
  final BuilderOptions builderOptions;

  const _WasmBuilder(this.builderOptions);

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      '.wat': ['.wasm']
    };
  }

  Future<Stream<List<int>>> expectExitCode0(
      String executable, List<String> arguments,
      [Future Function(Process) onStart]) async {
    var process = await Process.start(executable, arguments);
    if (onStart != null) await onStart(process);
    var exec = (executable + ' ' + arguments.join(' ')).trim();
    var code = await process.exitCode;

    if (code != 0) {
      var s = await process.stderr.transform(utf8.decoder).join();
      await process.stdout.drain();

      throw s.isNotEmpty ? s : '`$exec` failed with exit code $code.';
    }

    return process.stdout;
  }

  @override
  Future build(BuildStep buildStep) async {
    var wat2wasm = builderOptions.config['wat2wasm']?.toString() ?? 'wat2wasm';
    var inputId = buildStep.inputId;
    var outputId = inputId.changeExtension('.wasm');
    var ss = await buildStep.fetchResource(_scratchSpace);
    var inputFile = ss.fileFor(inputId);
    var outputFile = ss.fileFor(outputId);
    await ss.ensureAssets([inputId], buildStep);
    var output = await expectExitCode0(
        wat2wasm, ['-o', outputFile.absolute.path, inputFile.absolute.path]);
    await output.drain();
    await ss.copyOutput(outputId, buildStep);
  }
}
