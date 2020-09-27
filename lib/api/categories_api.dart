import 'package:winwin_hexo_editor_mobile/api/base_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_api.dart';

class CategoriesApi {
  static Future<dynamic> getAllCategories() async {
    return await BaseApi().getRequestWithAuth(AppApiAddress.categories, null);
  }
}
