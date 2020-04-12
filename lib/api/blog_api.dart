import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class BlogApi {
  static Future<dynamic> deploy() async {
    return await BaseApi().postRequestWithAuth(AppApiAddress.deployBlog, null);
  }
}