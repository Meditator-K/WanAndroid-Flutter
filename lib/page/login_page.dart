import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/base_entity.dart';
import 'package:wan_android/entity/user_entity.dart';
import 'package:wan_android/global/screen_info.dart';
import 'package:wan_android/global/user.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/widget/button_widget.dart';
import 'package:wan_android/widget/common_widget.dart';

import '../util/toast_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _accountController = TextEditingController();
  var _pwdController = TextEditingController();
  ValueNotifier<bool> _showPwd = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppbar('登录'),
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
                        onPressed: () => _accountController.text = '',
                      ),
                      hintText: '请输入账号'),
                ),
                ValueListenableBuilder(
                    valueListenable: _showPwd,
                    builder: (context, bool value, child) {
                      return TextField(
                          controller: _pwdController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => _showPwd.value = !_showPwd.value,
                            ),
                            hintText: '请输入密码',
                          ),
                          obscureText: !value);
                    }),
                const SizedBox(height: 50),
                SizedBox(
                    width: ScreenInfo().screenWidth - 80,
                    height: 40,
                    child: elevatedBtn('登录', onPress: () => _doLogin(context))),
                const SizedBox(height: 20),
                SizedBox(
                    width: ScreenInfo().screenWidth - 80,
                    height: 40,
                    child: elevatedBtn('注册',
                        padding: EdgeInsets.only(left: 50, right: 50),
                        onPress: () => _toRegister(context))),
              ],
            ))));
  }

  void _doLogin(BuildContext context) async {
    var account = _accountController.text;
    var pwd = _pwdController.text;
    if (account.isEmpty || pwd.isEmpty) {
      ToastUtil.showToast('请输入账号和密码');
      return;
    }
    var params = {'username': account, 'password': pwd};
    BaseEntity baseEntity =
        await HttpManager.getInstance().login(API.LOGIN_URL, params);
    if (HttpCode.SUCCESS == baseEntity.code) {
      BaseData? baseData = baseEntity.data;
      int? errorCode = baseData?.errorCode;
      if (errorCode == HttpCode.ERROR_CODE_SUC) {
        ToastUtil.showToast('登录成功');
        UserEntity userEntity = UserEntity.fromJson(baseData?.data);
        //账号和id保存在本地,跳转到首页
        User().saveUsername(userEntity.username ?? '');
      } else {
        ToastUtil.showToast('登录失败:$errorCode');
      }
    } else {
      ToastUtil.showToast('登录失败:${baseEntity.msg}');
    }
  }

  void _toRegister(context) {
    //跳转到注册页面
    Navigator.pushNamed(context, '/RegisterPage');
  }

  @override
  void dispose() {
    super.dispose();
    _showPwd.dispose();
  }
}
