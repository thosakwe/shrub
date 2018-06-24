import 'dart:async';

abstract class ShrubFilesystem {
  ShrubDirectory directory(String path);
}

abstract class ShrubDirectory {
  String get path;

  Future<List<ShrubFile>> listShrubFiles();

  Future<ShrubFile> findShrubFile(String name);
}

abstract class ShrubFile {
  String get path;

  Future<bool> get exists;

  Future<String> read();

  Future write(String contents);
}
