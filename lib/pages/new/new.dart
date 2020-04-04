import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:winwin_hexo_editor_mobile/api/post_api.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:fluintl/fluintl.dart';
import 'package:notus/convert.dart';
import 'package:toast/toast.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage>
    with AfterLayoutMixin<NewPostPage> {
  ZefyrController _controller;
  FocusNode _focusNode;
  String _titleString = '';

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _titleString = IntlUtil.getString(context, Ids.newPostPageDefaultTitle);
    });
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  save() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(IntlUtil.getString(context, Ids.newPostPageSaveDialogTitle)),
          content: Text(
              IntlUtil.getString(context, Ids.newPostPageSaveDialogContext)),
          actions: <Widget>[
            FlatButton(
              child: Text(IntlUtil.getString(context, Ids.no)),
              onPressed: () {
                Navigator.pop(context, '');
              },
            ),
            FlatButton(
              child: Text(IntlUtil.getString(context, Ids.yes)),
              onPressed: () {
                PostApi.savePost({
                  "title": _titleString,
                  "_content":
                      notusMarkdown.encode(_controller.document.toDelta()),
                }).then((responseValue) {
                  Navigator.pop(context, responseValue);
                });
              },
            )
          ],
        );
      },
    ).then((responseValue) {
      if (responseValue != '' && responseValue['success'] == true) {
        Navigator.pop(context);
      } else {
        Toast.show(responseValue['message'], context,
            duration: Toast.LENGTH_LONG);
      }
    });
  }

  changeTitle() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String stringValue = '';
        return AlertDialog(
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                  hintText: IntlUtil.getString(
                      context, Ids.newPostPageAlertPostTitle),
                ),
                onChanged: (value) {
                  stringValue = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, '');
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
                Navigator.pop(context, stringValue);
              },
              child: Text(
                IntlUtil.getString(context, Ids.yes),
              ),
            )
          ],
        );
      },
    ).then((value) {
      if (value != '') {
        setState(() {
          _titleString = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            _titleString,
          ),
          onTap: () {
            changeTitle();
          },
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.tab),
          //   onPressed: () {
          //     save();
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.category),
          //   onPressed: () {
          //     save();
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              save();
            },
          ),
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }
}
