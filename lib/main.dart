import 'package:flutter/material.dart';
import 'package:wan_android/page/collect_list_page.dart';
import 'package:wan_android/page/fingerprint_login_page.dart';
import 'package:wan_android/page/home_page.dart';
import 'package:wan_android/page/login_page.dart';
import 'package:wan_android/page/register_page.dart';
import 'package:wan_android/page/search_page2.dart';
import 'package:wan_android/page/todo_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wan_android/util/sp_util.dart';

import 'constant/data_keys.dart';
import 'global/user.dart';

void main() {
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
        //日历控件设置中文需要
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: const Locale('zh'),
      title: 'Wan Android',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/RegisterPage': (context) => RegisterPage(),
        '/LoginPage': (context) => LoginPage(),
        '/HomePage': (context) => HomePage(),
        '/SearchPage': (context) => SearchPage(),
        '/CollectListPage': (context) => CollectListPage(),
        '/ToDoPage': (context) => ToDoPage(),
        '/FingerprintLoginPage': (context) => FingerprintLoginPage(),
      },
    );
  }
}
