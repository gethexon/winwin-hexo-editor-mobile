import 'package:winwin_hexo_editor_mobile/api/base_api.dart';

class UserApi {
  static Future<dynamic> login(String username, String password) async {
    return await BaseApi().login(username, password);
  }
}
