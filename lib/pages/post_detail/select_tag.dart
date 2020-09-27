import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winwin_hexo_editor_mobile/api/tags_api.dart';
import 'package:winwin_hexo_editor_mobile/entity/tag.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/pages/post_detail/tag_arguments.dart';

class SelectTagPage extends StatefulWidget {
  @override
  _SelectTagPageState createState() => _SelectTagPageState();
}

class _SelectTagPageState extends State<SelectTagPage> {
  List<Tag> _tags;
  List<Tag> _selectedTags;
  TextEditingController tagEditingController;
  var listViewController = new ScrollController();

  @override
  void initState() {
    super.initState();
    tagEditingController = TextEditingController();
    listViewController.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    _tags = List<Tag>();
    _getAllTags();
  }

  _getAllTags() async {
    TagsApi.getAllTags().then((responseValue) {
      if (responseValue['success'] == true) {
        _tags.clear();
        for (var tagItemValue in responseValue['data']['tags']) {
          Tag tag = Tag.fromJson(tagItemValue);
          _tags.add(tag);
        }
        setState(() {});
      } else {
        Toast.show(responseValue['message'], context,
            duration: Toast.LENGTH_LONG);
        Navigator.pop(context, null);
      }
    });
  }

  _clickAddNewTagButton() {
    FocusScope.of(context).requestFocus(FocusNode());
    var inputTag = tagEditingController.text.trim();
    if (inputTag.isEmpty) {
      Toast.show(
          IntlUtil.getString(context, Ids.selectTagsPageEmptyErrorMessage),
          context,
          duration: Toast.LENGTH_LONG);
      return;
    }
    Tag tag = Tag();
    tag.name = inputTag;
    Navigator.pop(context, tag);
  }

  @override
  Widget build(BuildContext context) {
    _selectedTags = (ModalRoute.of(context).settings.arguments as TagArguments)
        .selectedTags;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          IntlUtil.getString(context, Ids.tags),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: ListView.builder(
            controller: listViewController,
            itemCount: _tags.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: TextField(
                    controller: tagEditingController,
                    obscureText: false,
                    onSubmitted: (_) => _fieldFocusChange(context),
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: IntlUtil.getString(
                          context, Ids.selectTagsPageInputHolder),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () => _clickAddNewTagButton(),
                  ),
                );
              } else {
                var isHadItem = _selectedTags
                    .any((element) => element.slug == _tags[index - 1].slug);
                return ListTile(
                  leading: isHadItem
                      ? Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.grey,
                        ),
                  title: Text(
                    _tags[index - 1].name,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () => Navigator.pop(
                      context, isHadItem ? null : _tags[index - 1]),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _fieldFocusChange(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
