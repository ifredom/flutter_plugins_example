import 'dart:io';

import 'package:dio/dio.dart';

abstract class FileHelper {
  Future<String> getApplicationDocumentsDirectoryPath();

  Future<File> getFileFromUrl(String url);

  Future<MultipartFile> convertFileToMultipartFile(File file);
}
