import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluintl/fluintl.dart';
import 'package:after_layout/after_layout.dart';
import 'package:winwin_hexo_editor_mobile/api/user_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:device_info/device_info.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  SharedPreferences prefs;
  String deviceType;
  String deviceSystem;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceSystem = "Android";
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceType = androidInfo.model;
    } else if (Platform.isIOS) {
      deviceSystem = "iOS";
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceType = iosInfo.utsname.machine;
    }
  }

  void onWinwinGithubButtonClick() async {
    String url = 'https://github.com/YuJianghao/winwin-hexo-editor';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onLoginButtonClick() async {
    var result = await BarcodeScanner.scan();
    // 如果是错误或者取消扫描，则什么都不做
    if (result.type == ResultType.Cancelled ||
        result.type == ResultType.Error) {
      return;
    }

    print(result.type); // The result type (barcode, cancelled, failed)
    print(result.rawContent); // The barcode content
    print(result.format); // The barcode format (as enum)
    print(result
        .formatNote); // If a unknown format was scanned this field contains a note

    final jsonMap = json.decode(result.rawContent);
    var server = jsonMap['url'].toString();
    var token = jsonMap['token'].toString();

    prefs.setString(AppConstant.appAdminServerAddrss, server);
    prefs.setString(AppConstant.appScanQRToken, token);

    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: IntlUtil.getString(context, Ids.loadingAlertText));
    await pr.show();
    UserApi.registerDevice(
      token,
      deviceType,
      deviceSystem,
    ).then((responseValue) async {
      await pr.hide();
      if (responseValue['success'] == true) {
        print(responseValue);
        var apikey = responseValue['data']['apikey'];
        prefs.setString(AppConstant.appAdminUserToken, apikey);
        Navigator.popAndPushNamed(context, Routing.homePage);
      } else {
        Toast.show(responseValue['message'], context,
            duration: Toast.LENGTH_LONG);
      }
    }).catchError((onError) async {
      await pr.hide();
      Toast.show(IntlUtil.getString(context, Ids.commonNetworkError), context,
          duration: Toast.LENGTH_LONG);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    IntlUtil.getString(context, Ids.loginPageWelcomBack),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 36.0,
                    ),
                  ),
                ),
              ),
              FlatButton(
                child: Text(
                  IntlUtil.getString(context, Ids.loginPageScanQrCodeButton),
                ),
                onPressed: onLoginButtonClick,
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                child: Text(
                  IntlUtil.getString(context, Ids.loginPageGithubButton),
                  style: TextStyle(color: Colors.green, fontSize: 12.0),
                ),
                onPressed: onWinwinGithubButtonClick,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
