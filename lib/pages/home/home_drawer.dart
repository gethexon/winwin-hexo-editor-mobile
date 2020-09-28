import 'package:after_layout/after_layout.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:winwin_hexo_editor_mobile/api/blog_api.dart';
import 'package:winwin_hexo_editor_mobile/api/info_api.dart';
import 'package:winwin_hexo_editor_mobile/api/user_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/theme/theme.dart';
import 'package:winwin_hexo_editor_mobile/theme/theme_change_notifier.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer>
    with AfterLayoutMixin<HomeDrawer> {
  String _name = '';
  String _versionMobile = '';
  String _versionServer = '';
  AppThemeMode _selectedThemeValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _selectedThemeValue =
          Provider.of<ThemeNotifier>(context, listen: false).getAppThemeMode();
      _versionMobile = packageInfo.version;
    });
    InfoApi.version().then((responseValue) {
      setState(() {
        _versionServer = responseValue;
      });
    });
    UserApi.getUserInfo().then((responseValue) {
      if (responseValue['success']) {
        setState(() {
          _name = responseValue['data']['user']['username'];
        });
      }
    });
  }

  void exit() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstant.appAdminUserToken, '');
    Navigator.popAndPushNamed(context, Routing.loadingPage);
  }

  void publish() async {
    BlogApi.deploy().then(
      (responseValue) {
        if (responseValue['success']) {
          // AppNotification().showNotification(
          //     IntlUtil.getString(context, Ids.homePageToastDeploySuccess));
          // Toast.show(
          //     IntlUtil.getString(context, Ids.homePageToastDeploySuccess),
          //     context,
          //     duration: Toast.LENGTH_LONG);
        }
      },
    );
  }

  void cleanHexo() async {
    BlogApi.clean().then(
      (responseValue) {
        if (responseValue['success']) {
          Toast.show(IntlUtil.getString(context, Ids.homePageToastCleanSuccess),
              context,
              duration: Toast.LENGTH_LONG);
        }
      },
    );
  }

  void changedTheme(AppThemeMode appThemeMode) {
    Navigator.pop(context);
    switch (appThemeMode) {
      case AppThemeMode.followSystem:
        Provider.of<ThemeNotifier>(context, listen: false).setFollowSystem();
        break;
      case AppThemeMode.dark:
        Provider.of<ThemeNotifier>(context, listen: false).setDark();
        break;
      case AppThemeMode.light:
        Provider.of<ThemeNotifier>(context, listen: false).setLight();
        break;
    }
    setState(() {
      _selectedThemeValue = appThemeMode;
    });
  }

  void github() async {
    String github = 'https://github.com/maomishen/winwin-hexo-editor-mobile';
    if (await canLaunch(github)) {
      await launch(github);
    }
  }

  void aboutApp() {
    showAboutDialog(context: context);
    // showLicensePage(
    //           context: context,
    //         );
    // Navigator.pushNamed(context, Routing.aboutAppPage);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                _name,
              ),
              accountEmail: Text(
                '${IntlUtil.getString(context, Ids.drawVersionMobile)} ${_versionMobile} / ${IntlUtil.getString(context, Ids.drawVersionServer)} $_versionServer',
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.publish,
                      color: Colors.green,
                    ),
                    title: Text(
                      IntlUtil.getString(context, Ids.drawPublish),
                    ),
                    subtitle: Text(
                      IntlUtil.getString(context, Ids.drawPublishDetail),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      publish();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    title: Text(
                      IntlUtil.getString(context, Ids.drawClean),
                    ),
                    subtitle: Text(
                      IntlUtil.getString(context, Ids.drawCleanDetail),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      cleanHexo();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                    ),
                    title: Text(
                      IntlUtil.getString(context, Ids.drawAppInfo),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      aboutApp();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.theaters,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      IntlUtil.getString(context, Ids.drawThemeMode),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selectedThemeValue,
                        items: AppTheme.appThemeModeList(),
                        onChanged: (value) => changedTheme(value),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      LineAwesomeIcons.github,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    title: Text(
                      IntlUtil.getString(context, Ids.drawGithub),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      github();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.yellow,
                    ),
                    title: Text(
                      IntlUtil.getString(context, Ids.drawExit),
                    ),
                    onTap: () {
                      exit();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
