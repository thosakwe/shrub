import 'dart:async';
import 'package:shrub/shrub.dart';
import 'package:path/path.dart';

class ShrubEmptyFileSystem implements ShrubFileSystem {
  const ShrubEmptyFileSystem();

  @override
  Context get context => new Context();

  @override
  ShrubDirectory get root => const ShrubEmptyDirectory();

  @override
  ShrubDirectory directory(String path) {
    return const ShrubEmptyDirectory();
  }
}

class ShrubEmptyDirectory implements ShrubDirectory {
  const ShrubEmptyDirectory();

  @override
  ShrubDirectory child(String dirname) => this;

  @override
  Future<bool> get exists async => false;

  @override
  ShrubFile findFile(String basename) => const ShrubEmptyFile();

  @override
  ShrubFile findShrubFile(String name) => const ShrubEmptyFile();

  @override
  Stream<ShrubFile> listShrubFiles() => new Stream<ShrubFile>.empty();

  @override
  String get path => '';
}

class ShrubEmptyFile implements ShrubFile {
  const ShrubEmptyFile();

  @override
  ShrubFile changeExtension(String extension) => this;

  @override
  ShrubDirectory get directory => const ShrubEmptyDirectory();

  @override
  Future<bool> get exists async => false;

  @override
  String get path => '';

  @override
  Future<String> read() async => '';

  @override
  Future write(String contents) => new Future.value();
}
