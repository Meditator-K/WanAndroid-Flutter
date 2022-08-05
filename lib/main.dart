import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wan_android/page/collect_list_page.dart';
import 'package:wan_android/page/gesture_unlock_page.dart';
import 'package:wan_android/page/home_page.dart';
import 'package:wan_android/page/login_page.dart';
import 'package:wan_android/page/register_page.dart';
import 'package:wan_android/page/search_page2.dart';
import 'package:wan_android/page/todo_page.dart';
import 'package:wan_android/util/sp_util.dart';

import 'constant/data_keys.dart';
import 'global/user.dart';

void main() {
  final SystemUiOverlayStyle _style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark);
  SystemChrome.setSystemUIOverlayStyle(_style);
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  SpUtil.getStrList(DataKeys.COOKIE).then((cookie) {
    if (cookie != null) {
      User().cookies = cookie;
    }
  });
  SpUtil.getStr(DataKeys.USERNAME).then((username) {
    if (username != null) {
      User().username = username;
    }
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/RegisterPage': (context) => RegisterPage(),
        '/LoginPage': (context) => LoginPage(),
        '/HomePage': (context) => HomePage(),
        '/SearchPage': (context) => SearchPage(),
        '/CollectListPage': (context) => CollectListPage(),
        '/ToDoPage': (context) => ToDoPage(),
        // '/FingerprintLoginPage': (context) => FingerprintLoginPage(),
        '/GestureUnlockPage': (context) => GestureUnlockPage(),
      },
      builder: FlutterSmartDialog.init(),
    );
  }
}
