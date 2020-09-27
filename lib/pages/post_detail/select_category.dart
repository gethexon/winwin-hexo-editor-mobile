import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:winwin_hexo_editor_mobile/api/categories_api.dart';
import 'package:winwin_hexo_editor_mobile/entity/category.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';
import 'package:winwin_hexo_editor_mobile/pages/post_detail/category_arguments.dart';

class SelectCategoryPage extends StatefulWidget {
  @override
  _SelectCategoryPageState createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  List<Category> _categories;
  List<Category> _selectedCategories;
  TextEditingController categoryEditingController;
  var listViewController = new ScrollController();

  @override
  void initState() {
    super.initState();
    categoryEditingController = TextEditingController();
    listViewController.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
    _categories = List<Category>();
    _getAllCategories();
  }

  _getAllCategories() async {
    CategoriesApi.getAllCategories().then((responseValue) {
      if (responseValue['success'] == true) {
        _categories.clear();
        for (var categoryItemValue in responseValue['data']['categories']) {
          Category category = Category.fromJson(categoryItemValue);
          _categories.add(category);
        }
        setState(() {});
      } else {
        Toast.show(responseValue['message'], context,
            duration: Toast.LENGTH_LONG);
        Navigator.pop(context, null);
      }
    });
  }

  _clickAddNewCategoryButton() {
    FocusScope.of(context).requestFocus(FocusNode());
    var inputCategory = categoryEditingController.text.trim();
    if (inputCategory.isEmpty) {
      Toast.show(
          IntlUtil.getString(
              context, Ids.selectCategoriesPageEmptyErrorMessage),
          context,
          duration: Toast.LENGTH_LONG);
      return;
    }
    Category category = Category();
    category.name = inputCategory;
    Navigator.pop(context, category);
  }

  @override
  Widget build(BuildContext context) {
    _selectedCategories =
        (ModalRoute.of(context).settings.arguments as CategoryArguments)
            .selectedCategories;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          IntlUtil.getString(context, Ids.categories),
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
            itemCount: _categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  title: TextField(
                    controller: categoryEditingController,
                    obscureText: false,
                    onSubmitted: (_) => _fieldFocusChange(context),
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: IntlUtil.getString(
                          context, Ids.selectCategoriesPageInputHolder),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () => _clickAddNewCategoryButton(),
                  ),
                );
              } else {
                var isHadItem = _selectedCategories.any(
                    (element) => element.slug == _categories[index - 1].slug);
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
                    _categories[index - 1].name,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () => Navigator.pop(
                      context, isHadItem ? null : _categories[index - 1]),
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
