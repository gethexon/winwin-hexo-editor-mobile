import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:winwin_hexo_editor_mobile/api/blog_api.dart';
import 'package:winwin_hexo_editor_mobile/api/post_api.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:winwin_hexo_editor_mobile/entity/post_item.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/widget/wave_backgroud.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:toast/toast.dart';
import 'package:fluintl/fluintl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  List<PostItem> _postLists = List();
  EasyRefreshController _refreshController = EasyRefreshController();
  GlobalKey _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
  }

  @override
  void afterFirstLayout(BuildContext context) async {}

  _itemBuilder(List dataList, BuildContext context, int index) {
    PostItem item = dataList[index];
    return Dismissible(
      onDismissed: (direction) {
        PostApi.deletePost(item.sId).then((value) {
          print(value);
        });
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
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
              );
            },
          );
        }
        return false;
      },
      background: Container(),
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
                Icons.assignment_late,
                color: Colors.red,
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
    BlogApi.deploy();
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
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.publish,
                color: Colors.blue,
              ),
              title: Text(
                IntlUtil.getString(context, Ids.drawPublish),
              ),
              onTap: () {
                Navigator.pop(context);
                publish();
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
