import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';

class AppNotification {
  static checkNotification() async {
    var prefs = await SharedPreferences.getInstance();
    var isNever = prefs.getBool(AppConstant.appRequestNotificationPermissions);
    if (isNever != null && isNever != true) {
      NotificationPermissions.getNotificationPermissionStatus().then((status) {
        switch (status) {
          case PermissionStatus.denied:
            showDialog(
              context: AppConstant.navigatorKey.currentContext,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    IntlUtil.getString(
                        context, Ids.notificationPermissionsRequest),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        prefs.setBool(
                            AppConstant.appRequestNotificationPermissions,
                            true);
                        Navigator.pop(context);
                      },
                      child: Text(
                        IntlUtil.getString(context, Ids.never),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                        NotificationPermissions.requestNotificationPermissions(
                            iosSettings: const NotificationSettingsIos(
                                sound: true, badge: true, alert: true));
                      },
                      child: Text(
                        IntlUtil.getString(context, Ids.yes),
                      ),
                    )
                  ],
                );
              },
            );
            return null;
          case PermissionStatus.granted:
            return null;
          case PermissionStatus.unknown:
            NotificationPermissions.requestNotificationPermissions(
                iosSettings: const NotificationSettingsIos(
                    sound: true, badge: true, alert: true));
            return null;
          default:
            return null;
        }
      });
    }
  }

  void showNotification(String message) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // var initializationSettings = InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: selectNotification);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}
