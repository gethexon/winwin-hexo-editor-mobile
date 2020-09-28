import 'package:winwin_hexo_editor_mobile/entity/category.dart';
import 'package:winwin_hexo_editor_mobile/entity/tag.dart';

class ListToJson {
  static List<String> foreachToListItem(List<Tag> list) {
    var returnValue = List<String>();
    if (list == null || list.length == 0) {
      return returnValue;
    }
    list.forEach((element) {
      returnValue.add(element.name);
    });
    return returnValue;
  }

  static List<List<String>> foreachToListListItem(List<Category> list) {
    var returnValue = List<List<String>>();
    if (list == null || list.length == 0) {
      return returnValue;
    }
    returnValue.add(List<String>());
    list.forEach((element) {
      returnValue[0].add(element.name);
    });
    return returnValue;
  }
}
