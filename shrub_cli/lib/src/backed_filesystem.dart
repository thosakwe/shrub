import 'dart:async';

import 'package:file/file.dart';
import 'package:path/src/context.dart';
import 'package:shrub/shrub.dart';

class ShrubBackedFileSystem implements ShrubFileSystem {
  final FileSystem fileSystem;

  const ShrubBackedFileSystem(this.fileSystem);

  @override
  Context get context => fileSystem.path;

  @override
  ShrubDirectory get root =>
      new ShrubBackedDirectory(fileSystem.currentDirectory);

  @override
  ShrubDirectory directory(String path) =>
      new ShrubBackedDirectory(fileSystem.directory(path));
}

class ShrubBackedDirectory implements ShrubDirectory {
  final Directory directory;

  const ShrubBackedDirectory(this.directory);

  @override
  ShrubDirectory child(String dirname) =>
      new ShrubBackedDirectory(directory.childDirectory(dirname));

  @override
  Future<bool> get exists => directory.exists();

  @override
  ShrubFile findFile(String basename) =>
      new ShrubBackedFile(directory.childFile(basename));

  @override
  ShrubFile findShrubFile(String name) =>
      findFile(directory.fileSystem.path.setExtension(name, '.shrub'));

  @override
  Stream<ShrubFile> listShrubFiles() => directory
      .list()
      .where((s) => s is File)
      .cast<File>()
      .where((f) => directory.fileSystem.path.extension(f.path) == '.shrub')
      .map((f) => new ShrubBackedFile(f));

  @override
  String get path => directory.path;
}

class ShrubBackedFile implements ShrubFile {
  final File file;

  const ShrubBackedFile(this.file);

  @override
  ShrubFile changeExtension(String extension) => new ShrubBackedFile(file.parent
      .childFile(file.fileSystem.path.setExtension(path, extension)));

  @override
  ShrubDirectory get directory => new ShrubBackedDirectory(file.parent);

  @override
  Future<bool> get exists => file.exists();

  @override
  String get path => file.path;

  @override
  Future<String> read() => file.readAsString();

  @override
  Future write(String contents) => file.writeAsString(contents);
}
