import 'dart:io';

String getData(String path) {
  String file = File(path).readAsStringSync();
  return file;
}
