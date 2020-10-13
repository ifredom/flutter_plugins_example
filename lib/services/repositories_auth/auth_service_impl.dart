import 'dart:async';

import 'package:flutter_plugins_example/core/model/userinfo/user.dart';
import 'package:logging/logging.dart';

import 'auth_service.dart';

//  service 控制层，定义数据变化，定义异步接口请求
// view_model 视图层，连接service,
class AuthServiceImpl implements AuthService {
  final _log = Logger('AuthServiceImpl');
  User _currentUser;
  User get currentUser => _currentUser;

  // 使用stream数据传输通信, 入口sink,出口stream 文章:https://juejin.im/post/5baa4b90e51d450e6d00f12e
  StreamController<User> _userController = StreamController<User>();
  Stream<User> get user => _userController.stream;

  String get userType => currentUser.userType;

  String _invitationCode;
  String get invitationCode => _invitationCode;

  @override
  Future<void> disposeUserController() {
    _userController.close();
    return Future.value();
  }
}
