import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry/sentry.dart';
import 'package:winwin_hexo_editor_mobile/common/app_constant.dart';

import 'common/routing.dart';
import 'i18n/i18n.dart';

final SentryClient _sentry = new SentryClient(dsn: AppConstant.sentryClientDSN);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

_reportError(dynamic error, dynamic stackTrace) async {
  if (isInDebugMode) {
    print(stackTrace);
    print('Caught error: $error');
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

void main() {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  setLocalizedValues(localizedValues);
  runZoned(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
