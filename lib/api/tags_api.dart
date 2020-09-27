import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class TagsApi {
  static Future<dynamic> getAllTags() async {
    return await BaseApi().getRequestWithAuth(AppApiAddress.tags, null);
  }
}
