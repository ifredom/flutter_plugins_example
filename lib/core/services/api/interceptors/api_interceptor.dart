import 'package:dio/dio.dart' show InterceptorsWrapper, RequestInterceptorHandler, RequestOptions;
import 'package:pluginexample/core/app/app.locator.dart';
import 'package:pluginexample/core/services/local_storage_service.dart';
import 'package:pluginexample/core/utils/res/local_storage_keys.dart';

import '../apicode/whiteList.dart';

class ApiInterceptors extends InterceptorsWrapper {
  final _localStorageService = locator<LocalStorageService>();
  // 白名单
  // ignore: unused_element
  _getUnWhitelistToken(String apiCode) async {
    String token = _localStorageService.get(StorageKeys.TOKEN_KEY);
    if (WhiteList.list.contains(apiCode)) {
      token = StorageKeys.DEFAULT_TOKEN_KEY;
    }
    return token;
  }
}
