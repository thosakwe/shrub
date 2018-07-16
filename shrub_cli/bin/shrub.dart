import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:shrub_cli/shrub_cli.dart';

main(List<String> args) async {
  try {
    return await commandRunner.run(args);
  } on UsageException catch (e) {
    stderr..writeln(red.wrap(e.message))..writeln()..writeln(red.wrap(e.usage));
    exitCode = ExitCode.usage.code;
  }
}
