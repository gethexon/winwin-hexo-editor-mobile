import 'dart:core';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:fsuper/fsuper.dart';
import 'package:winwin_hexo_editor_mobile/api/post_api.dart';
import 'package:toast/toast.dart';
import 'package:winwin_hexo_editor_mobile/entity/post_item.dart';
import 'package:winwin_hexo_editor_mobile/helper/WidgetList.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatefulWidget {
  PostDetailPage({
    @required this.postId,
  });

  final String postId;

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>
    with AfterLayoutMixin<PostDetailPage> {
  PostItem post;

  @override
  void initState() {
    super.initState();
  }

  void afterFirstLayout(BuildContext context) async {
    PostApi.getPost(widget.postId).then((responseValue) {
      if (responseValue['success'] == true) {
        setState(() {
          post = PostItem.fromJson(responseValue['data']['post']);
        });
      } else {
        Toast.show(responseValue['message'], context,
            duration: Toast.LENGTH_LONG);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post?.title ?? IntlUtil.getString(context, Ids.loading),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.edit),
        //     onPressed: () {
        //       // save();
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    IntlUtil.getString(context, Ids.detailCategories),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Row(
                    children: WidgetList.foreachMatrixToWidget(post?.categories,
                        (element) {
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
                        IntlUtil.getString(
                            context, Ids.homePageListCategoriesEmpty),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    IntlUtil.getString(context, Ids.detailTags),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Row(
                    children: WidgetList.foreachToWidget(post?.tags, (element) {
                      return FSuper(
                        margin: EdgeInsets.only(left: 4.0),
                        text: element,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
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
            ),
            Expanded(
              child: Markdown(
                data: post?.sContent ?? '',
                onTapLink: (url) async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    Toast.show(
                        IntlUtil.getString(
                            context, Ids.detailPostPageErrorLunchWeb),
                        context,
                        duration: Toast.LENGTH_LONG);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
