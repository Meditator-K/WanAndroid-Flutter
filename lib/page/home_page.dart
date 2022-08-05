import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wan_android/constant/data_keys.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/global/user.dart';
import 'package:wan_android/page/login_page.dart';
import 'package:wan_android/util/navigator_util.dart';
import 'package:wan_android/util/sp_util.dart';
import 'package:wan_android/widget/home_widget.dart';
import 'package:wan_android/widget/navi_widget2.dart';
import 'package:wan_android/widget/project_widget.dart';
import 'package:wan_android/widget/tree_widget.dart';

import '../global/screen_info.dart';
import '../util/toast_util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectIndex = 0;
  String _username = DataKeys.DEFAULT_USERNAME;
  BuildContext? _context;
  bool isBack = false;

  List<Widget> _widgets = <Widget>[
    HomeWidget(),
    TreeWidget(),
    NaviWidget(),
    ProjectWidget()
  ];

  static const List<String> titles = <String>['首页', '体系', '导航', '项目'];

  @override
  Widget build(BuildContext context) {
    _context = context;
    ToastContext().init(context);
    ScreenInfo().setScreenData(context);

    loadUsername();
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_selectIndex]),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: _toSearch,
            )
          ],
        ),
        body: IndexedStack(
          //防止切换底部标签界面重绘
          children: _widgets, index: _selectIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.equalizer), label: '体系'),
            BottomNavigationBarItem(icon: Icon(Icons.near_me), label: '导航'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '项目'),
          ],
          currentIndex: _selectIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemSelected,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black45,
        ),
        drawer: _drawer,
      ),
      onWillPop: _onBack,
    );
  }

  get _drawer => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Image.asset(
                    'images/logo.png',
                    fit: BoxFit.contain,
                    width: 60.0,
                  ),
                  backgroundColor: Colors.white,
                ),
                accountEmail: null,
                accountName: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toLogin,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
                        child: Text(_username, style: WidgetStyle.BTN_STYLE)))),
            ListTile(
              leading: Icon(Icons.collections_bookmark),
              title: Text(
                '收藏',
                style: WidgetStyle.DRAWER_TEXT_STYLE,
              ),
              onTap: _toCollectList,
            ),
            ListTile(
              leading: Icon(Icons.label),
              title: Text('便签', style: WidgetStyle.DRAWER_TEXT_STYLE),
              onTap: _showToDo,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('退出', style: WidgetStyle.DRAWER_TEXT_STYLE),
              onTap: _showDialog,
            )
          ],
        ),
      );

  void _showDialog() {
    if (User().cookies == null) {
      return;
    }
    showDialog(
        context: _context!,
        builder: (_) => AlertDialog(
              title: Text('提示！'),
              content: Text('确认退出吗？'),
              actions: <Widget>[
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(_context!).pop();
                  },
                ),
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    _logout();
                    Navigator.of(_context!).pop();
                  },
                )
              ],
            ));
  }

  loadUsername() {
    SpUtil.getStr(DataKeys.USERNAME).then((username) {
      if (username != null && username.isNotEmpty) {
        //已经登录了，本地有缓存的账号
        setState(() {
          _username = username;
        });
      }
    });
  }

  setUsername(username) {
    setState(() {
      _username = username;
    });
  }

  //监听返回键，按两次退出程序
  Future<bool> _onBack() {
    if (!isBack) {
      isBack = true;
      ToastUtil.showToast('再按一次退出程序');
      Future.delayed(Duration(seconds: 2), () {
        isBack = false;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  //切换页面
  void _onItemSelected(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  //进入搜索页
  void _toSearch() {
    Navigator.pushNamed(context, '/SearchPage');
  }

  //进入收藏页
  void _toCollectList() {
    if (User().cookies == null) {
      Navigator.pushNamed(context, '/LoginPage');
    } else {
      Navigator.pushNamed(context, '/CollectListPage');
    }
  }

  //进入TODO页
  void _showToDo() {
    if (User().cookies != null) {
      Navigator.pushNamed(context, '/ToDoPage');
    } else {
      Navigator.pushNamed(context, '/LoginPage');
    }
  }

  //如果没登录，跳转到登录页面
  void _toLogin() {
    if ((User().cookies ?? []).isEmpty) {
      NavigatorUtil.push(context, LoginPage());
    }
  }

  //退出登录
  void _logout() {
    User().clearUserInfo();
    setUsername(DataKeys.DEFAULT_USERNAME);
  }
}
