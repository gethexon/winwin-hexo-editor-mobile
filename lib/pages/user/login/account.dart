import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:winwin_hexo_editor_mobile/api/user_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:after_layout/after_layout.dart';

class AccountPageView extends StatefulWidget {
  @override
  _AccountPageViewState createState() => _AccountPageViewState();
}

class _AccountPageViewState extends State<AccountPageView>
    with AfterLayoutMixin<AccountPageView> {
  TextEditingController serverEditingController;
  TextEditingController nameEditingController;
  TextEditingController passwordEditingController;
  SharedPreferences prefs;
  final FocusNode _serverEditingControllerFocus = FocusNode();
  final FocusNode _nameEditingControllerFocus = FocusNode();
  final FocusNode _passwordEditingControllerFocus = FocusNode();

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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void onLoginButtonClick() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var server = serverEditingController.text.trim();
    var name = nameEditingController.text.trim();
    var password = passwordEditingController.text.trim();
    if (server.endsWith('/')) {
      server = server.substring(0, server.length - 1);
      serverEditingController.text = server;
    }
    if (server.isEmpty) {
      Toast.show(
          IntlUtil.getString(context, Ids.loginPageServerEmptyError), context,
          duration: Toast.LENGTH_LONG);
      return;
    }
    if (name.isEmpty) {
      Toast.show(
          IntlUtil.getString(context, Ids.loginPageUserEmptyError), context,
          duration: Toast.LENGTH_LONG);
      return;
    }
    if (password.isEmpty) {
      Toast.show(
          IntlUtil.getString(context, Ids.loginPagePasswordEmptyError), context,
          duration: Toast.LENGTH_LONG);
      return;
    }
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: IntlUtil.getString(context, Ids.loadingAlertText));
    await pr.show();
    prefs.setString(AppConstant.appAdminServerAddrss, server);
    prefs.setString(AppConstant.appAdminServerUserName, name);
    UserApi.login(name, password).then((responseValue) async {
      await pr.hide();
      if (responseValue['success'] == true) {
        var userId = responseValue['data']['id'];
        prefs.setString(AppConstant.appAdminUserId, userId);
        var token = responseValue['data']['token'];
        prefs.setString(AppConstant.appAdminUserToken, token);
        var refreshToken = responseValue['data']['refreshToken'];
        prefs.setString(AppConstant.appAdminRefreshToken, refreshToken);
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 28.0, 18.0, 0),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? "assets/images/account_background_b.png"
                  : "assets/images/account_background.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          TextField(
            controller: serverEditingController,
            obscureText: false,
            focusNode: _serverEditingControllerFocus,
            onSubmitted: (_) => _fieldFocusChange(context,
                _serverEditingControllerFocus, _nameEditingControllerFocus),
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: IntlUtil.getString(context, Ids.loginPageServerHint),
            ),
          ),
          TextField(
            controller: nameEditingController,
            obscureText: false,
            focusNode: _nameEditingControllerFocus,
            onSubmitted: (_) => _fieldFocusChange(
              context,
              _nameEditingControllerFocus,
              _passwordEditingControllerFocus,
            ),
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: IntlUtil.getString(context, Ids.loginPageUserHint),
            ),
          ),
          TextField(
            controller: passwordEditingController,
            obscureText: true,
            focusNode: _passwordEditingControllerFocus,
            onSubmitted: (_) {
              _passwordEditingControllerFocus.unfocus();
              onLoginButtonClick();
            },
            textInputAction: TextInputAction.done,
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: IntlUtil.getString(context, Ids.loginPagePasswordHint),
            ),
          ),
          FlatButton(
            child: Text(
              IntlUtil.getString(context, Ids.loginPageLoginButton),
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).buttonColor,
              ),
            ),
            onPressed: onLoginButtonClick,
          ),
          Text(
            IntlUtil.getString(context, Ids.loginPageSwipeRight),
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
