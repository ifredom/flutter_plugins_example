import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}

final _log = Logger('network_utils');

void checkForNetworkExceptions(Response response) {
  if (response.statusCode != 200) {
    throw NetworkException('无法连接到网络');
  }
}

void showLoadingProgress(received, total) {
  if (total != -1) {
    // 暂时不用打印
    // _log.fine('${(received / total * 100).toStringAsFixed(0)}%');
  }
}

dynamic decodeResponseBodyToJson(String body) {
  try {
    final data = convert.jsonDecode(body);
    return data;
  } on FormatException catch (e) {
    _log.severe('Network Utils: 解码 response body 失败 ${e.message}');
    throw NetworkException(e.message);
  }
}
