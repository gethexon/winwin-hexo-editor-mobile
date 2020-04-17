import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';

class TokenInterceptor extends Interceptor {
  final String authTag = "Authorization";

  @override
  onError(DioError error) async {
    if (error.response != null && error.response.statusCode == 401) {
      Dio dio = BaseApi.dio;
      dio.lock();
      var prefs = await SharedPreferences.getInstance();
      var jsonValue = await refreshToken(dio, prefs);
      prefs.setString(AppConstant.appAdminRefreshToken, jsonValue['refreshToken']);
      prefs.setString(AppConstant.appAdminUserToken, jsonValue['token']);
      var token = jsonValue['token'];
      Dio tokenDio = Dio();
      tokenDio.options.headers[authTag] = "Bearer $token";

      try {
        var newRequest = await tokenDio.request(error.request.path);
        return newRequest;
      } on DioError catch (e) {
        return e;
      } finally {
        dio.unlock();
      }
    }
    super.onError(error);
  }

  Future<dynamic> refreshToken(Dio dio, SharedPreferences prefs) async {
    var server = prefs.getString(AppConstant.appAdminServerAddrss);
    var refreshToken = prefs.getString(AppConstant.appAdminRefreshToken);
    var returnValue;
    
    try {
      var options = Options(
        headers: {authTag: "Bearer $refreshToken"},
      );
      Response response = await Dio()
          .get(server + AppApiAddress.refreshToken, options: options);
      returnValue = response.data['data'];
    } on DioError catch (onError) {
      if (onError.response.statusCode == 401) {
        prefs.setString(AppConstant.appAdminRefreshToken, '');
        prefs.setString(AppConstant.appAdminUserToken, '');
        dio.unlock();
        return Navigator.popAndPushNamed(AppConstant.navigatorKey.currentContext, Routing.loadingPage);
      }
    }
    return returnValue;
  }
}
