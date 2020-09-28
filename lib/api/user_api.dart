import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class UserApi {
  static Future<dynamic> login(String username, String password) async {
    return await BaseApi().login(username, password);
  }

  static Future<dynamic> registerDevice(
      String token, String deviceType, String deviceSystem) async {
    var parameters = {
      "deviceType": deviceType,
      "deviceSystem": deviceSystem,
    };
    String url = AppApiAddress.registeDevice;
    return await BaseApi().postRequestWithAuth(url, parameters, qrToken: token);
  }

  static Future<dynamic> getUserInfo() async {
    String url = AppApiAddress.userInfo;
    return await BaseApi().getRequestWithAuth(url, null);
  }
}
