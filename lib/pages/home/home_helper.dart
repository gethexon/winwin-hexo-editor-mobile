import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';

class HomeHelper {
  Future<bool> getPublishOrUnpublishAlertDialog(
      BuildContext context, bool isPublished) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          IntlUtil.getString(
              context,
              isPublished
                  ? Ids.homePageAlertUnpublishText
                  : Ids.homePageAlertPublishText),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              IntlUtil.getString(context, Ids.no),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              IntlUtil.getString(context, Ids.yes),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> getDeleteAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          IntlUtil.getString(context, Ids.homePageAlertDeleteText),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(
              IntlUtil.getString(context, Ids.no),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              IntlUtil.getString(context, Ids.yes),
            ),
          )
        ],
      ),
    );
  }
}
