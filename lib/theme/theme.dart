import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getThemeData({bool isDarkMode = false}) { 
    return ThemeData(
      errorColor: isDarkMode ? Colors.red : Colors.red,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      // primaryColor: isDarkMode ? Colors.dark_app_main : Colors.blue,
      // accentColor: isDarkMode ? Colors.dark_app_main : Colors.app_main,
      // Tab指示器颜色
      // indicatorColor: isDarkMode ? Colors.dark_app_main : Colors.app_main,
      // 页面背景色
      // scaffoldBackgroundColor: isDarkMode ? Colors.dark_bg_color : Colors.white,
      // 主要用于Material背景色
      canvasColor: isDarkMode ? Colors.black87 : Colors.white,
      // 文字选择色（输入框复制粘贴菜单）
      textSelectionColor: Colors.black.withAlpha(70),
      textSelectionHandleColor: Colors.blue,
      // textTheme: TextTheme(
      //   // TextField输入文字颜色
      //   subhead: isDarkMode ? TextStyles.textDark : TextStyles.text,
      //   // Text默认文字样式
      //   body1: isDarkMode ? TextStyles.textDark : TextStyles.text,
      //   // 这里用于小文字样式
      //   subtitle:
      //       isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
      // ),
      // inputDecorationTheme: InputDecorationTheme(
      //   hintStyle:
      //       isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
      // ),
      // appBarTheme: AppBarTheme(
      //   elevation: 0.0,
      //   color: isDarkMode ? Colors.dark_bg_color : Colors.white,
      //   brightness: isDarkMode ? Brightness.dark : Brightness.light,
      // ),
      // dividerTheme: DividerThemeData(
      //   color: isDarkMode ? Colors.dark_line : Colors.line,
      //   space: 0.6,
      //   thickness: 0.6,
      // ),
    );
  }
}
