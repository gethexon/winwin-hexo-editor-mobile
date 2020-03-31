import 'package:flutter/material.dart';
import 'package:winwin_hexo_editor_mobile/pages/home/home.dart';
import 'package:winwin_hexo_editor_mobile/pages/loading.dart';
import 'package:winwin_hexo_editor_mobile/pages/user/login.dart';

class Routing {
  static final String loadingPage = '/';
  static final String loginPage = '/login';
  static final String homePage = 'home';

  static final Map<String, WidgetBuilder> routes = {
    loadingPage: (context) => LoadingPage(),
    loginPage: (context) => LoginPage(),
    homePage: (context) => HomePage(),
  };
}
