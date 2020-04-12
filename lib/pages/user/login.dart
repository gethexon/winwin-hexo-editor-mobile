import 'package:flutter/material.dart';
import 'package:fluintl/fluintl.dart';
import 'package:after_layout/after_layout.dart';
import 'package:winwin_hexo_editor_mobile/api/user_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/widget/wave_backgroud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AfterLayoutMixin<LoginPage> {
  TextEditingController serverEditingController;
  TextEditingController nameEditingController;
  TextEditingController passwordEditingController;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    serverEditingController = TextEditingController();
    nameEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    serverEditingController.text =
        prefs.getString(AppConstant.appAdminServerAddrss);
    nameEditingController.text =
        prefs.getString(AppConstant.appAdminServerUserName);
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
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: IntlUtil.getString(context, Ids.loadingAlertText));
    pr.show();
    var server = serverEditingController.text.trim();
    prefs.setString(AppConstant.appAdminServerAddrss, server);
    var name = nameEditingController.text.trim();
    prefs.setString(AppConstant.appAdminServerUserName, name);
    var password = passwordEditingController.text.trim();
    UserApi.login(name, password).then((responseValue) {
      pr.hide();
      if (responseValue['success'] == true) {
        var userId = responseValue['data']['id'];
        prefs.setString(AppConstant.appAdminUserId, userId);
        var token = responseValue['data']['token'];
        prefs.setString(AppConstant.appAdminUserToken, token);
        Navigator.popAndPushNamed(context, Routing.homePage);
      } else {
        Toast.show(responseValue['message'], context,
            duration: Toast.LENGTH_LONG);
      }
    }).catchError((onError) {
      pr.hide();
      Toast.show(IntlUtil.getString(context, Ids.commonNetworkError), context,
          duration: Toast.LENGTH_LONG);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: WaveBackground(
        child: SafeArea(
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
                TextField(
                  controller: serverEditingController,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        IntlUtil.getString(context, Ids.loginPageServerHint),
                  ),
                ),
                TextField(
                  controller: nameEditingController,
                  obscureText: false,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        IntlUtil.getString(context, Ids.loginPageUserHint),
                  ),
                ),
                TextField(
                  controller: passwordEditingController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        IntlUtil.getString(context, Ids.loginPagePasswordHint),
                  ),
                ),
                FlatButton(
                  child: Text(
                    IntlUtil.getString(context, Ids.loginPageLoginButton),
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
      ),
    );
  }
}
