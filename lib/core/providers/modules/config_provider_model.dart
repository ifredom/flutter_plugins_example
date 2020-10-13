import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugins_example/utils/res/local_storage.dart';
import 'package:flutter_plugins_example/utils/res/local_storage_keys.dart';
import 'package:stacked/stacked.dart';

/// 枚举: 支持的语言种类
enum SupportLocale {
  FOLLOW_SYSTEM,
  SIMPLIFIED_CHINESE,
  TRADITIONAL_CHINESE_TW,
  TRADITIONAL_CHINESE_HK,
  ENGLISH,
}

class ConfigProviderModel extends BaseViewModel {
  ThemeInfo _themeInfo = ThemeInfo(isDart: false);
  String get theme => _themeInfo.theme;

  FijkPlayer _audioPlayer = FijkPlayer();
  get audioPlayer => _audioPlayer;

  Future getTheme() async {
    String _theme = await LocalStorage.get(LocalStorageKeys.THEME);
    print('config get Theme $_theme');
    if (_theme != null) {
      await setTheme(_theme);
    }
  }

  Future<void> setTheme(String themeMode) async {
    _themeInfo.theme = themeMode;
    await LocalStorage.set(LocalStorageKeys.THEME, themeMode);

    notifyListeners();
  }

  Future intPlayer({String url = 'asset:///assets/audio/viper.mp3'}) async {
    await _audioPlayer.setDataSource(url, autoPlay: false);
  }

  Future disposePlayer() async {
    await _audioPlayer.release();
  }
}

class ThemeInfo {
  bool isDart;
  String theme = 'white';
  ThemeInfo({this.isDart, this.theme});
}

/// SupportLocale -> locale
Map<SupportLocale, Locale> mapLocales = {
  SupportLocale.FOLLOW_SYSTEM: null,
  SupportLocale.SIMPLIFIED_CHINESE: Locale("zh", "CN"),
  SupportLocale.TRADITIONAL_CHINESE_TW: Locale("zh", "TW"),
  SupportLocale.TRADITIONAL_CHINESE_HK: Locale("zh", "HK"),
  SupportLocale.ENGLISH: Locale("en", "")
};

/// SupportLocale 对应的含义
Map<SupportLocale, String> get mapSupportLocale => {
      SupportLocale.FOLLOW_SYSTEM: "跟随系统",
      SupportLocale.SIMPLIFIED_CHINESE: "简体中文",
      SupportLocale.TRADITIONAL_CHINESE_TW: "繁體中文(臺灣)",
      SupportLocale.TRADITIONAL_CHINESE_HK: "繁體中文(香港)",
      SupportLocale.ENGLISH: "English"
    };
