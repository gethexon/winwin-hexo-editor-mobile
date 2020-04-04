import 'package:flutter/material.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/routing.dart';
import 'i18n/i18n.dart';

void main() {
  setLocalizedValues(localizedValues);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => IntlUtil.getString(context, Ids.appTitle),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routing.loadingPage,
      onGenerateRoute: Routing.generateRoute,
      routes: Routing.routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizations.delegate
      ],
      supportedLocales: CustomLocalizations.supportedLocales,
    );
  }
}
