import 'package:flutter/material.dart';
import 'package:wan_android/constant/custom_arguments.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/entity/base_entity.dart';
import 'package:wan_android/entity/user_entity.dart';
import 'package:wan_android/global/user.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/util/widget_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _accountController = TextEditingController();
  var _pwdController = TextEditingController();
  bool _isHidePwd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                TextField(
                  controller: _accountController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_box),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: _clearAccount,
                      ),
                      hintText: '请输入账号'),
                ),
                TextField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: _showPwd,
                      ),
                      hintText: '请输入密码'),
                  obscureText: _isHidePwd,
                ),
                Container(
                  height: 30,
                  color: Colors.transparent,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        child: Text('登录', style: WidgetStyle.BTN_STYLE),
                        onPressed: () {
                          _doLogin(context);
                        },
                        color: Colors.lightBlue,
                      ),
                    )
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        child: Text('注册', style: WidgetStyle.BTN_STYLE),
                        onPressed: _toRegister,
                        color: Colors.lightBlue,
                      ),
                    )
                  ],
                ),
              ],
            ))));
  }

  _clearAccount() {
    _accountController.text = '';
  }

  _showPwd() {
    if (_pwdController.text.isEmpty) {
      return;
    }
    setState(() {
      if (_isHidePwd) {
        _isHidePwd = false;
      } else {
        _isHidePwd = true;
      }
    });
  }

  void _doLogin(BuildContext context) {
    var account = _accountController.text;
    var pwd = _pwdController.text;
    if (account.isEmpty || pwd.isEmpty) {
      ToastUtil.showToast(context, '请输入账号和密码');
      return;
    }
    var params = {'username': account, 'password': pwd};
    HttpManager.getInstance().login(API.LOGIN_URL, params).then((baseEntity) {
      if (HttpCode.SUCCESS == baseEntity.code) {
        BaseData baseData = baseEntity.data;
        int errorCode = baseData.errorCode;
        if (errorCode == HttpCode.ERROR_CODE_SUC) {
          print('登录成功');
          ToastUtil.showToast(context, '登录成功');
          UserEntity userEntity = UserEntity.fromJson(baseData.data);
          //账号和id保存在本地,跳转到首页
          User().saveUsername(userEntity.username);
          Navigator.pop(context);
        } else {
          print('登录失败');
          ToastUtil.showToast(context, '登录失败:$errorCode');
        }
      } else {
        print('登录失败');
        ToastUtil.showToast(context, '登录失败:${baseEntity.msg}');
      }
    });
  }

  void _toRegister() {
    //跳转到注册页面
    Navigator.pushNamed(context, '/RegisterPage');
  }
}
