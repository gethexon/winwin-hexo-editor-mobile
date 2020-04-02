import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class PostApi {
  static Future<dynamic> getPosts() async {
    return await BaseApi().getRequestWithAuth(AppApiAddress.posts, null);
  }

  static Future<dynamic> savePost(String id, Map<String, dynamic> parameters) async {
    String url = AppApiAddress.post.replaceAll('/{id}', '');
    return await BaseApi().postRequestWithAuth(url, parameters);
  }
}
