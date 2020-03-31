import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {}

  _itemBuilder(List dataList, BuildContext context, int index) {
    // WorksheetTeam team = dataList[index];
    return Card(
        child: InkWell(
      onTap: () {
        // _onItemTab(team);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 6, 2),
            child: Text('團號：'),
          ),
        ],
      ),
    ));
  }

  Future<void> _initRequester() async {
    PostApi.getPosts().then((responseValue) {
      var valueString = responseValue.toString();
      print(valueString);
      if (responseValue['success'] == true) {
        _postLists.clear();
        for (var postItemValue in responseValue['data']['posts']) {
          PostItem postItem = PostItem.fromJson(postItemValue);
          print(postItem);
          _postLists.add(postItem);
        }
        setState(() {
          
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), onPressed: () {
          exit();
        },
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
