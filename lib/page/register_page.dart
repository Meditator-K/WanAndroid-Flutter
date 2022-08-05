import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/entity/base_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/util/widget_util.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _accountController = TextEditingController();
  var _pwdController = TextEditingController();
  var _rePwdController = TextEditingController();
  bool _isHidePwd = true;
  bool _isHideRePwd = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
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
              TextField(
                controller: _rePwdController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: _showRePwd,
                    ),
                    hintText: '请再次输入密码'),
                obscureText: _isHideRePwd,
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
                      child: Text('注册', style: WidgetStyle.BTN_STYLE),
                      onPressed: () {
                        _doRegister(context);
                      },
                      color: Colors.lightBlue,
                    ),
                  )
                ],
              ),
            ],
          ))),
    );
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

  _showRePwd() {
    if (_rePwdController.text.isEmpty) {
      return;
    }
    setState(() {
      if (_isHideRePwd) {
        _isHideRePwd = false;
      } else {
        _isHideRePwd = true;
      }
    });
  }

  void _doRegister(BuildContext context) {
    String account = _accountController.text;
    String pwd = _pwdController.text;
    String rePwd = _rePwdController.text;
    if (account.isEmpty || pwd.isEmpty || rePwd.isEmpty) {
      ToastUtil.showToast(context, '请输入账号和密码');
      return;
    }
    if (pwd != rePwd) {
      ToastUtil.showToast(context, '请确保两次输入的密码一致');
      return;
    }
    var params = {'username': account, 'password': pwd, 'repassword': rePwd};
    HttpManager.getInstance().post(API.REGISTER_URL, params).then((baseEntity) {
      if (HttpCode.SUCCESS == baseEntity.code) {
        BaseData? baseData = baseEntity.data;
        int? errorCode = baseData?.errorCode;
        if (errorCode == HttpCode.ERROR_CODE_SUC) {
          print('注册成功');
          ToastUtil.showToast(context, '注册成功');
          //返回登录界面
          Navigator.pop(context);
        } else {
          print('注册失败');
          ToastUtil.showToast(context, '注册失败:$errorCode');
        }
      } else {
        print('注册失败');
        ToastUtil.showToast(context, '注册失败:${baseEntity.msg}');
      }
    });
  }
}
