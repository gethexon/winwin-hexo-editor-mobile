import 'package:flutter/material.dart';
import 'package:winwin_hexo_editor_mobile/pages/about/about.dart';
import 'package:winwin_hexo_editor_mobile/pages/home/home.dart';
import 'package:winwin_hexo_editor_mobile/pages/loading.dart';
import 'package:winwin_hexo_editor_mobile/pages/new/new.dart';
import 'package:winwin_hexo_editor_mobile/pages/post_detail/post_detail.dart';
import 'package:winwin_hexo_editor_mobile/pages/user/login.dart';

class Routing {
  static final String loadingPage = '/';
  static final String loginPage = '/login';
  static final String homePage = '/home';
  static final String newPostPage = '/new_post';
  static final String aboutAppPage = '/about_app';
  static final String postDetailPage = '/detail_post/';

  static final Map<String, WidgetBuilder> routes = {
    loadingPage: (context) => LoadingPage(),
    loginPage: (context) => LoginPage(),
    homePage: (context) => HomePage(),
    aboutAppPage: (context) => AboutPage(),
    newPostPage: (context) => NewPostPage(),
  };

  static final RouteFactory generateRoute = (routing) {
    if (routing.name.contains(postDetailPage)) {
      return MaterialPageRoute(
        builder: (context) {
          return PostDetailPage(
            postId: routing.name.replaceFirst(postDetailPage, ''),
          );
        },
      );
    }
    return MaterialPageRoute(builder: (BuildContext context) {
      return null;
    });
  };
}
