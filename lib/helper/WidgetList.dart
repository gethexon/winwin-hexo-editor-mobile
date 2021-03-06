import 'package:flutter/material.dart';

class WidgetList {
  static List<Widget> foreachToWidget(
      List list, Widget f(element), Widget emptyf()) {
    var returnValue = List<Widget>();
    if (list == null || list.length == 0) {
      returnValue.add(emptyf());
      return returnValue;
    }
    list.forEach((element) {
      returnValue.add(f(element));
    });
    return returnValue;
  }

  static List<Widget> foreachMatrixToWidget(
      List list, Widget f(element), Widget emptyf()) {
    var returnValue = List<Widget>();
    if (list == null || list.length == 0) {
      returnValue.add(emptyf());
      return returnValue;
    }
    List firstItem = list[0];
    firstItem.forEach((element) {
      returnValue.add(f(element));
    });
    return returnValue;
  }
}
