import 'dart:async';

abstract class ShrubFilesystem {
  ShrubDirectory directory(String path);
}

abstract class ShrubDirectory {
  String get path;

  ShrubDirectory child(String dirname);

  Stream<ShrubFile> listShrubFiles();

  ShrubFile findShrubFile(String name);
}

abstract class ShrubFile {
  String get path;

  Future<bool> get exists;

  ShrubFile changeExtension(String extension);

  Future<String> read();

  Future write(String contents);
}
