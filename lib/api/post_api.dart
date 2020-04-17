import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class PostApi {
  static Future<dynamic> getPosts() async {
    return await BaseApi().getRequestWithAuth(AppApiAddress.posts, null);
  }

  static Future<dynamic> getPost(String id) async {
    String url = AppApiAddress.post.replaceAll('{id}', id);
    return await BaseApi().getRequestWithAuth(url, null);
  }

  static Future<dynamic> savePost(Map<String, dynamic> parameters) async {
    String url = AppApiAddress.post.replaceAll('/{id}', '');
    return await BaseApi().postRequestWithAuth(url, parameters);
  }

  static Future<dynamic> deletePost(String id) async {
    String url = AppApiAddress.post.replaceAll('{id}', id);
    return await BaseApi().deleteRequestWithAuth(url, null);
  }

  static Future<dynamic> publishPost(String id) async {
    String url = AppApiAddress.postPublish.replaceAll('{id}', id);
    return await BaseApi().postRequestWithAuth(url, null);
  }

  static Future<dynamic> unpublishPost(String id) async {
    String url = AppApiAddress.postUnpublish.replaceAll('{id}', id);
    return await BaseApi().postRequestWithAuth(url, null);
  }
}
