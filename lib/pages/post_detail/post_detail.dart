import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:winwin_hexo_editor_mobile/api/post_api.dart';
import 'package:toast/toast.dart';
import 'package:winwin_hexo_editor_mobile/entity/post_item.dart';
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
      body: Markdown(
        data: post?.sContent ?? '',
        onTapLink: (url) async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            Toast.show(
                IntlUtil.getString(context, Ids.detailPostPageErrorLunchWeb),
                context,
                duration: Toast.LENGTH_LONG);
          }
        },
      ),
    );
  }
}
