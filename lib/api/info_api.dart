import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class InfoApi {
  /// 获取服务器版本号
  static Future<dynamic> version() async {
    String url = AppApiAddress.serverVersion;
    return await BaseApi().getRequestWithoutAuth(url, null);
  }
}
