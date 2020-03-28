import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

enum AuthRequestType {
  authRequestTypeGet,
  authRequestTypePost,
}

class BaseApi {

  static const String _AT = "Authorization";

  getRequest(String url, Map<String, dynamic> parameters) async {
    try {
      var options = Options(
        headers: {_AT: ""},
      );
      Response response = await Dio().get(url,
          queryParameters: parameters, options: options);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
