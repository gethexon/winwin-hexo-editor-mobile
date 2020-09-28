import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:winwin_hexo_editor_mobile/api/post_api.dart';
import 'package:winwin_hexo_editor_mobile/common/notification.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:winwin_hexo_editor_mobile/entity/post_item.dart';
import 'package:winwin_hexo_editor_mobile/helper/DateUtils.dart';
import 'package:winwin_hexo_editor_mobile/helper/WidgetList.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/pages/home/home_drawer.dart';
import 'package:winwin_hexo_editor_mobile/pages/home/home_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:toast/toast.dart';
import 'package:fluintl/fluintl.dart';
import 'package:fsuper/fsuper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  List<PostItem> _postLists = List();
  EasyRefreshController _refreshController = EasyRefreshController();
  GlobalKey _scaffoldKey;
  HomeHelper _homeHelper = HomeHelper();

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    AppNotification.checkNotification();
  }

  @override
  void afterFirstLayout(BuildContext context) async {}

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
        leading: item.published
            ? Icon(
                Icons.assignment_turned_in,
                color: Colors.green,
              )
            : Icon(
                Icons.assignment_returned,
                color: Colors.orange,
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.date != null
                ? Text(
                    DateUtils.instance.getFormartData(
                      item.date * 1000,
                      IntlUtil.getString(context, Ids.homeDateTemplateString),
                    ),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.0,
                      color: Colors.grey,
                    ),
                  )
                : SizedBox(),
            Text(
              item.title,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 4,
            )
          ],
        ),
        subtitle: Row(
          children: [
            Row(
              children:
                  WidgetList.foreachMatrixToWidget(item.categories, (element) {
                return FSuper(
                  margin: EdgeInsets.only(left: 4.0),
                  text: element,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  child1Alignment: Alignment.center,
                  backgroundColor: Colors.blue[100],
                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                  corner: FCorner(
                      rightTopCorner: 20,
                      rightBottomCorner: 20,
                      leftBottomCorner: 20,
                      leftTopCorner: 20),
                );
              }, () {
                return Text(
                  IntlUtil.getString(context, Ids.homePageListCategoriesEmpty),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[300],
                  ),
                );
              }),
            ),
            Spacer(),
            Row(
              children: WidgetList.foreachToWidget(item.tags, (element) {
                return FSuper(
                  margin: EdgeInsets.only(left: 4.0),
                  text: element,
                  style: TextStyle(color: Colors.black, fontSize: 10),
                  child1Alignment: Alignment.center,
                  backgroundColor: Colors.red[100],
                  padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                  corner: FCorner(
                      rightTopCorner: 20,
                      rightBottomCorner: 20,
                      leftBottomCorner: 20,
                      leftTopCorner: 20),
                );
              }, () {
                return Text(
                  IntlUtil.getString(context, Ids.homePageListTagsEmpty),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[300],
                  ),
                );
              }),
            ),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
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

  void createNewPost() {
    Navigator.pushNamed(context, Routing.newPostPage);
    // AppNotification().showNotification(
    //     IntlUtil.getString(context, Ids.homePageToastDeploySuccess));
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
          createNewPost();
        },
      ),
      drawer: HomeDrawer(),
      body: SafeArea(
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
    );
  }
}
