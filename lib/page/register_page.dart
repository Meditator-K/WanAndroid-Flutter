import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/base_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/widget/common_widget.dart';

import '../global/screen_info.dart';
import '../util/toast_util.dart';
import '../widget/button_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _accountController = TextEditingController();
  var _pwdController = TextEditingController();
  var _rePwdController = TextEditingController();
  ValueNotifier<bool> _showPwd = ValueNotifier(false);
  ValueNotifier<bool> _showRePwd = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar('注册'),
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
                          hintText: '请输入密码'),
                      obscureText: !value,
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: _showRePwd,
                  builder: (context, bool value, child) {
                    return TextField(
                      controller: _pwdController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(value
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () =>
                                _showRePwd.value = !_showRePwd.value,
                          ),
                          hintText: '请再次输入密码'),
                      obscureText: !value,
                    );
                  }),
              const SizedBox(height: 30),
              SizedBox(
                  width: ScreenInfo().screenWidth - 80,
                  height: 40,
                  child: elevatedBtn('注册',
                      padding: EdgeInsets.only(left: 50, right: 50),
                      onPress: () => _doRegister(context))),
            ],
          ))),
    );
  }

  void _doRegister(BuildContext context) {
    String account = _accountController.text;
    String pwd = _pwdController.text;
    String rePwd = _rePwdController.text;
    if (account.isEmpty || pwd.isEmpty || rePwd.isEmpty) {
      ToastUtil.showToast('请输入账号和密码');
      return;
    }
    if (pwd != rePwd) {
      ToastUtil.showToast('请确保两次输入的密码一致');
      return;
    }
    var params = {'username': account, 'password': pwd, 'repassword': rePwd};
    HttpManager.getInstance().post(API.REGISTER_URL, params).then((baseEntity) {
      if (HttpCode.SUCCESS == baseEntity.code) {
        BaseData? baseData = baseEntity.data;
        int? errorCode = baseData?.errorCode;
        if (errorCode == HttpCode.ERROR_CODE_SUC) {
          ToastUtil.showToast('注册成功');
          //返回登录界面
          Navigator.pop(context);
        } else {
          ToastUtil.showToast('注册失败:$errorCode');
        }
      } else {
        ToastUtil.showToast('注册失败:${baseEntity.msg}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _showPwd.dispose();
    _showRePwd.dispose();
  }
}
