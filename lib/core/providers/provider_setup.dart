import 'package:flutter_plugins_example/core/model/userinfo/user.dart';
import 'package:flutter_plugins_example/services/connectivity/connectivity_service.dart';
import 'package:flutter_plugins_example/services/locator.dart';
import 'package:flutter_plugins_example/services/repositories_auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'modules/config_provider_model.dart';

// https://stackoverflow.com/questions/59590673/flutter-app-crash-after-converting-provider-3-to-4
List<SingleChildWidget> providers = [...independentServices, ...dependentServices, ...uiConsumableProviders];

List<SingleChildWidget> independentServices = [
  Provider(create: (_) => ConfigProviderModel()),
];

List<SingleChildWidget> dependentServices = [];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<ConnectivityStatus>(
    create: (context) => locator<ConnectivityService>().connectivity$,
  ),
  // 解释: StreamProvider<数据模型>  Provider.of<数据服务>   设置为false,不监听变化数据变化 listen: false
  StreamProvider<User>(
    create: (context) => Provider.of<AuthService>(context, listen: false).user,
  )
];
