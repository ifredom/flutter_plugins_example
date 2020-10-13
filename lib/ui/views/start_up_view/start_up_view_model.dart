import 'package:flutter_plugins_example/utils/res/local_storage.dart';
import 'package:flutter_plugins_example/utils/res/local_storage_keys.dart';
import 'package:stacked/stacked.dart';

class StartUpViewModel extends BaseViewModel {
  Future handleStartUpLogic() async {
    String isLogin = await LocalStorage.get(LocalStorageKeys.IS_LOGIN);
    print("启动 isLogin: $isLogin");

    // if (isLogin) {
    //   unawaited(_navigationService.pushReplacementNamed(ViewRoutes.teacherHomePage));
    // } else {
    //   unawaited(_navigationService.pushReplacementNamed(ViewRoutes.homePage));
    // }
  }
}
