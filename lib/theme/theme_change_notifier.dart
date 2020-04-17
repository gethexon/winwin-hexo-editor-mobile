import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/theme/theme.dart';

class ThemeNotifier with ChangeNotifier {
  bool _dark = true;
  bool _light = true;
  bool get dark => _dark;
  bool get light => _light;

  void init() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(AppConstant.appThemeDark) == null) {
      prefs.setBool(AppConstant.appThemeDark, true);
      prefs.setBool(AppConstant.appThemeLight, true);
    } else {
      _dark = prefs.getBool(AppConstant.appThemeDark);
      _light = prefs.getBool(AppConstant.appThemeLight);
      notifyListeners();
    }
  }

  AppThemeMode getAppThemeMode() {
    if (_dark && _light) {
      return AppThemeMode.followSystem;
    } else if (!_dark && _light) {
      return AppThemeMode.light;
    } else if (_dark && !_light) {
      return AppThemeMode.dark;
    }
    return AppThemeMode.followSystem;
  }

  void setFollowSystem() async {
    _dark = true;
    _light = true;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.appThemeDark, true);
    prefs.setBool(AppConstant.appThemeLight, true);
  }

  void setDark() async {
    _dark = true;
    _light = false;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.appThemeDark, true);
    prefs.setBool(AppConstant.appThemeLight, false);
  }

  void setLight() async {
    _dark = false;
    _light = true;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstant.appThemeDark, false);
    prefs.setBool(AppConstant.appThemeLight, true);
  }
}
