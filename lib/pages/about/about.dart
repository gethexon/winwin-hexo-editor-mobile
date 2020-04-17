import 'package:after_layout/after_layout.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter/material.dart';
import 'package:winwin_hexo_editor_mobile/i18n/i18n.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with AfterLayoutMixin<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  void afterFirstLayout(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          IntlUtil.getString(
            context,
            Ids.aboutPageTitle,
          ),
        ),
      ),
      body: Container(
        child: Row(
          children: [
            
          ]
        ),
      ),
    );
  }
}
