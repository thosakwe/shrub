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
    process.stderr
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .listen(log.severe);
    var code = await process.exitCode;

    if (code != 0) {
      process.stdout.drain();
      throw '`$exec` failed with exit code $code.';
    }

    return process.stdout;
  }

  @override
  Future build(BuildStep buildStep) async {
    var wat2wasm = builderOptions.config['wat2wasm']?.toString() ?? 'wat2wasm';
    var inputId = buildStep.inputId;
    var outputId = inputId.changeExtension('.wasm');

    if (Platform.isWindows) {
      var ss = await buildStep.fetchResource(_scratchSpace);
      var inputFile = ss.fileFor(inputId);
      var outputFile = ss.fileFor(outputId);
      await ss.ensureAssets([inputId], buildStep);
      var output = await expectExitCode0(
          wat2wasm, ['-o', outputFile.absolute.path, inputFile.absolute.path]);
      await output.drain();
      await ss.copyOutput(outputId, buildStep);
    } else {
      var output = await expectExitCode0(
          wat2wasm, ['-o', '/dev/stdout', '/dev/stdin'], (process) async {
        var bytes = await buildStep.readAsBytes(inputId);
        process.stdin.add(bytes);
        await process.stdin.flush();
        process.stdin.close();
      });

      var bytes = await output
          .fold<BytesBuilder>(BytesBuilder(), (bb, buf) => bb..add(buf))
          .then((bb) => bb.takeBytes());
      buildStep.writeAsBytes(outputId, bytes);
    }
  }
}
