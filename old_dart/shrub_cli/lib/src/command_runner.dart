import 'package:args/command_runner.dart';
import 'compile_command.dart';

final CommandRunner commandRunner = new CommandRunner('shrub', '')
  ..addCommand(new CompileCommand());
