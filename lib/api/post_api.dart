import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class PostApi {
  static Future<dynamic> getPosts() async {
    return await BaseApi().getRequestWithAuth(AppApiAddress.post, null);
  }
}
