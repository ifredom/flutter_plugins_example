import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:stacked_services/stacked_services.dart';

import './connectivity/connectivity_service.dart';
import './connectivity/connectivity_service_impl.dart';
import './hardware_info/hardware_info_service.dart';
import './hardware_info/hardware_info_service_impl.dart';
import './key_storage/key_storage_service.dart';
import './key_storage/key_storage_service_impl.dart';
import 'file_helper/file_helper.dart';
import 'file_helper/file_helper_impl.dart';

// import 'package:stacked_services/stacked_services.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator({bool test = false}) async {
  // Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());

  locator.registerLazySingleton<HardwareInfoService>(
    () => HardwareInfoServiceImpl(),
  );
  locator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(),
  );

  // http data sources

  // 用于展示乐谱的server

  if (!test) {
    await _setupSharedPreferences();
  }

  // Utils
  locator.registerLazySingleton<FileHelper>(() => FileHelperImpl());

  // External
  locator.registerLazySingleton<HiveInterface>(() => Hive);
}

Future<void> _setupSharedPreferences() async {
  final instance = await KeyStorageServiceImpl.getInstance();
  locator.registerLazySingleton<KeyStorageService>(() => instance);
}
