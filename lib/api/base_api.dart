import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winwin_hexo_editor_mobile/api/token_interceptor.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';

enum AuthRequestType {
  authRequestTypeGet,
  authRequestTypePost,
}

class BaseApi {
  var prefs;

  factory BaseApi() => _sharedInstance();

  static BaseApi _instance;
  static Dio dio;

  BaseApi._();

  static BaseApi _sharedInstance() {
    if (_instance == null) {
      _instance = BaseApi._();
      dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };
      dio.interceptors.add(TokenInterceptor());
    }
    return _instance;
  }

  final String authTag = "Authorization";

  Future<dynamic> getRequestWithAuth(
      String url, Map<String, dynamic> parameters) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    var server = prefs.getString(AppConstant.appAdminServerAddrss);
    var token = prefs.getString(AppConstant.appAdminUserToken);
    var returnValue;
    try {
      var options = Options(
        headers: {authTag: "Bearer $token"},
      );
      Response response = await dio
          .get(server + url, queryParameters: parameters, options: options);
      returnValue = response.data;
    } on DioError catch (onError) {
      returnValue = onError.response.data;
    }
    return returnValue;
  }

  Future<dynamic> postRequestWithAuth(
      String url, Map<String, dynamic> parameters) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    var server = prefs.getString(AppConstant.appAdminServerAddrss);
    var token = prefs.getString(AppConstant.appAdminUserToken);
    var returnValue;
    try {
      var options = Options(
        headers: {authTag: "Bearer $token"},
      );
      Response response = await dio
          .post(server + url, data: parameters, options: options);
      returnValue = response.data;
    } on DioError catch (onError) {
      returnValue = onError.response.data;
    }
    return returnValue;
  }

  Future<dynamic> deleteRequestWithAuth(
      String url, Map<String, dynamic> parameters) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    var server = prefs.getString(AppConstant.appAdminServerAddrss);
    var token = prefs.getString(AppConstant.appAdminUserToken);
    var returnValue;
    try {
      var options = Options(
        headers: {authTag: "Bearer $token"},
      );
      Response response = await dio
          .delete(server + url, data: parameters, options: options);
      returnValue = response.data;
    } on DioError catch (onError) {
      returnValue = onError.response.data;
    }
    return returnValue;
  }

  Future<dynamic> login(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var options = new Options(
      headers: {authTag: basicAuth},
    );

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    var server = prefs.getString(AppConstant.appAdminServerAddrss);
    var returnValue;
    try {
      Response response = await dio.get('$server/token', options: options);
      returnValue = response.data;
    } on DioError catch (onError) {
      returnValue = onError.response.data;
    }
    return returnValue;
  }
}
