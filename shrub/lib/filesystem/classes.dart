import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:shrub/shrub.dart';

abstract class ShrubFileSystem {
  p.Context get context;

  ShrubDirectory get root;

  ShrubDirectory directory(String path);
}

abstract class ShrubDirectory {
  String get path;

  Future<bool> get exists;

  Stream<ShrubFileChange> get changes;

  ShrubDirectory child(String dirname);

  Stream<ShrubFile> listShrubFiles();

  ShrubFile findFile(String basename);

  ShrubFile findShrubFile(String name) =>
      findFile(p.setExtension(name, shrubFileExtension));
}

abstract class ShrubFile {
  ShrubDirectory get directory;

  String get path;

  Future<bool> get exists;

  ShrubFile changeExtension(String extension);

  Future<String> read();

  Future write(String contents);
}

class ShrubFileChange {
  final bool isDeleted;
  final ShrubFile file;

  ShrubFileChange(this.isDeleted, this.file);
}

