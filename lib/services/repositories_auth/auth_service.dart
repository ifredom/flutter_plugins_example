import 'dart:async';

import 'package:flutter_plugins_example/core/model/userinfo/user.dart';

abstract class AuthService {
  String get invitationCode;
  String get userType;
  Stream<User> get user;
  Future<void> disposeUserController();
}
