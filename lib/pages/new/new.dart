import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:fsuper/fsuper.dart';
import 'package:winwin_hexo_editor_mobile/api/post_api.dart';
import 'package:winwin_hexo_editor_mobile/common/routing.dart';
import 'package:winwin_hexo_editor_mobile/entity/tag.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/pages/post_detail/tag_arguments.dart';
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
  bool isInputAnything = false;
  List<List<String>> _categories;
  List<Tag> _tags;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    _categories = List<List<String>>();
    _categories.add(List<String>());
    _tags = List<Tag>();
    _controller.addListener(() {
      if (_controller.document.toPlainText().trim().isEmpty) {
        isInputAnything = false;
      } else {
        isInputAnything = true;
      }
      setState(() {});
    });
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
                  "layout": "draft",
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

  _addCategories() {
    setState(() {
      _categories[0].add("aaa");
    });
  }

  _deleteCategories() {
    setState(() {
      _categories[0].add("bbb");
    });
  }

  _addTags() {
    Navigator.pushNamed(
      context,
      Routing.tagsPage,
      arguments: TagArguments(_tags),
    ).then((value) {
      if (value != null) {
        setState(() {
          _tags.add(value);
        });
      }
    });
  }

  _deleteTags(Tag tag) {
    setState(() {
      _tags.remove(tag);
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
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              save();
            },
          ),
        ],
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
                  Expanded(
                    child: Container(
                      height: 26,
                      child: ListView.builder(
                        itemCount: _categories[0].length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: FSuper(
                              text: _categories[0][index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              backgroundColor: Colors.blue[100],
                              padding: EdgeInsets.fromLTRB(
                                  8, 6, (4 + 12 + 8).toDouble(), 6),
                              corner: FCorner.all(18),
                              child1: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 11,
                              ),
                              child1Alignment: Alignment.centerRight,
                              child1Margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              onChild1Click: () => _deleteCategories(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  FSuper(
                    text: IntlUtil.getString(context, Ids.newPostPageAdd),
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                      fontSize: 10,
                    ),
                    padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                    corner: FCorner.all(18),
                    onClick: () => _addCategories(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  Text(
                    IntlUtil.getString(context, Ids.detailTags),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      height: 26,
                      child: ListView.builder(
                        itemCount: _tags.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                            child: FSuper(
                              text: _tags[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                              backgroundColor: Colors.red[100],
                              padding: EdgeInsets.fromLTRB(
                                  8, 6, (4 + 12 + 8).toDouble(), 6),
                              corner: FCorner.all(18),
                              child1: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 11,
                              ),
                              child1Alignment: Alignment.centerRight,
                              child1Margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                              onChild1Click: () => _deleteTags(_tags[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  FSuper(
                    text: IntlUtil.getString(context, Ids.newPostPageAdd),
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                      fontSize: 10,
                    ),
                    padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
                    corner: FCorner.all(18),
                    onClick: () => _addTags(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
                  child: Text(
                    isInputAnything
                        ? ''
                        : IntlUtil.getString(
                            context, Ids.newPostPageEditorHolder),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ZefyrScaffold(
                  child: ZefyrEditor(
                    padding: EdgeInsets.all(16),
                    controller: _controller,
                    focusNode: _focusNode,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
