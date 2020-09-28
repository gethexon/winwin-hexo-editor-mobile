import 'package:flutter/material.dart';
import 'package:fluintl/fluintl.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winwin_hexo_editor_mobile/pages/user/login/qrcode.dart';

import 'login/account.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  void onWinwinGithubButtonClick() async {
    String url = 'https://github.com/YuJianghao/winwin-hexo-editor';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (value) =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  children: [
                    ScanQRcodePageView(),
                    AccountPageView(),
                  ],
                ),
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
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
