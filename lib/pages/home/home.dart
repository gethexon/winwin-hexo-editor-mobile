import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:winwin_hexo_editor_mobile/api/blog_api.dart';
import 'package:winwin_hexo_editor_mobile/api/post_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:winwin_hexo_editor_mobile/entity/post_item.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/pages/home/home_helper.dart';
import 'package:winwin_hexo_editor_mobile/widget/wave_backgroud.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:toast/toast.dart';
import 'package:fluintl/fluintl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  List<PostItem> _postLists = List();
  EasyRefreshController _refreshController = EasyRefreshController();
  GlobalKey _scaffoldKey;
  HomeHelper _homeHelper = HomeHelper();
  String _version = '';
  String _buildNumber = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    var prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(AppConstant.appAdminUserId);
  }

  _itemBuilder(List dataList, BuildContext context, int index) {
    PostItem item = dataList[index];
    return Dismissible(
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          PostApi.deletePost(item.sId).then((value) {
            _refreshController.callRefresh();
          });
        }
        if (direction == DismissDirection.startToEnd) {
          if (item.published) {
            PostApi.unpublishPost(item.sId).then((value) {
              _refreshController.callRefresh();
            });
          } else {
            PostApi.publishPost(item.sId).then((value) {
              _refreshController.callRefresh();
            });
          }
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return _homeHelper.getDeleteAlertDialog(context);
        }
        if (direction == DismissDirection.startToEnd) {
          return _homeHelper.getPublishOrUnpublishAlertDialog(
              context, item.published);
        }
        return false;
      },
      background: Container(
        color: item.published ? Colors.orange : Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 12.0,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                item.published
                    ? Icons.assignment_returned
                    : Icons.assignment_turned_in,
                color: Colors.white,
              ),
            ),
            Text(
              item.published
                  ? IntlUtil.getString(context, Ids.homePageUnPublish)
                  : IntlUtil.getString(context, Ids.homePagePublish),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            Text(
              IntlUtil.getString(context, Ids.delete),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 22.0,
            ),
          ],
        ),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: item.published
            ? Icon(
                Icons.assignment_turned_in,
                color: Colors.green,
              )
            : Icon(
                Icons.assignment_returned,
                color: Colors.orange,
              ),
        title: new Text(item.title),
        subtitle: Text(
          item.sContent,
          maxLines: 2,
        ),
        trailing: new Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.pushNamed(context, Routing.postDetailPage + item.sId);
        },
      ),
      key: UniqueKey(),
    );
  }

  Future<void> _initRequester() async {
    PostApi.getPosts().then((responseValue) {
      if (responseValue['success'] == true) {
        _postLists.clear();
        for (var postItemValue in responseValue['data']['posts']) {
          PostItem postItem = PostItem.fromJson(postItemValue);
          _postLists.add(postItem);
        }
        setState(() {});
      } else {
        Toast.show(responseValue['message'], context,
            duration: Toast.LENGTH_LONG);
      }
    }).catchError((onError) {
      Toast.show(IntlUtil.getString(context, Ids.commonNetworkError), context,
          duration: Toast.LENGTH_LONG);
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
          Toast.show(IntlUtil.getString(context, Ids.homePageToastDeploySuccess),
              context,
              duration: Toast.LENGTH_LONG);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, Ids.appTitle)),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Routing.newPostPage);
        },
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  _name,
                ),
                accountEmail: Text(
                  '$_version ($_buildNumber)',
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.publish,
                        color: Colors.blue,
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
                        color: Colors.orange,
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
                        exit();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
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
      ),
      body: WaveBackground(
        child: SafeArea(
          child: EasyRefresh(
            firstRefresh: true,
            controller: _refreshController,
            header: MaterialHeader(),
            footer: MaterialFooter(),
            onRefresh: _initRequester,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              itemCount: _postLists.length,
              itemBuilder: (context, index) {
                return _itemBuilder(_postLists, context, index);
              },
            ),
            emptyWidget: _postLists.length == 0
                ? Center(
                    child: Text(
                      IntlUtil.getString(context, Ids.homePageListEmptyText),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
