import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_plugins_example/core/services/auth_service.dart';
import 'package:flutter_plugins_example/core/services/connectivity_service.dart';
import 'package:flutter_plugins_example/core/services/file_service.dart';
import 'package:flutter_plugins_example/core/services/hardware_info_service.dart';
import 'package:flutter_plugins_example/core/services/local_storage_service.dart';
import 'package:flutter_plugins_example/core/services/share_service.dart';
import 'package:flutter_plugins_example/core/services/url_service.dart';
import 'package:flutter_plugins_example/ui/views/bluetooth/bluetooth.dart';
import 'package:flutter_plugins_example/ui/views/home/home_view/home.dart';
import 'package:flutter_plugins_example/ui/views/login/login_view.dart';
import 'package:flutter_plugins_example/ui/views/register/register_view.dart';
import 'package:flutter_plugins_example/ui/views/soundRecord/soundRecord.dart';
import 'package:flutter_plugins_example/ui/views/start_up/start_up_view.dart';
import 'package:flutter_plugins_example/ui/views/update/update_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

//  Using StackedApp for state management, generating routes and dependency injection.
//  需要預解析的 shared_preferences service 报错，所以不采用自动生成
@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: UpdateView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: SoundRecordScreen),
    MaterialRoute(page: BluetoothScreen),
  ],
  dependencies: [
    // Lazy singletons
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: Connectivity),

    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: OpenLinkService),
    LazySingleton(classType: ShareService),
    LazySingleton(classType: HardwareInfoService),
    LazySingleton(classType: FileServiceImpl),
    LazySingleton(classType: AuthService),
    // singletons

    // Presolve
    Presolve(
      classType: LocalStorageService,
      presolveUsing: SharedPreferences.getInstance,
    ),
  ],
  logger: StackedLogger(),
)
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality(除了附加注释之外，没有任何用途) **/
}
