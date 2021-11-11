import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesture_password_widget/widget/gesture_password_widget.dart';
import 'package:wan_android/global/user.dart';

class GestureUnlockPage extends StatefulWidget {
  @override
  _GestureUnlockState createState() => _GestureUnlockState();
}

class _GestureUnlockState extends State<GestureUnlockPage> {
  String _result = "";
  String _gesture = "";
  String _notice = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gesture = User().gestureUnlock ?? '';
    if (_gesture == '') {
      _notice = '请设置手势';
    } else {
      _notice = '请绘制手势';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图案识别'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            _notice,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(
            height: 20,
          ),
          GesturePasswordWidget(
            lineColor: const Color(0xff0C6BFE),
            errorLineColor: const Color(0xffFB2E4E),
            singleLineCount: 3,
            identifySize: 80.0,
            minLength: 4,
            errorItem: Image.asset(
              'images/error.png',
              color: const Color(0xffFB2E4E),
            ),
            normalItem: Image.asset('images/normal.png'),
            selectedItem: Image.asset(
              'images/selected.png',
              color: const Color(0xff0C6BFE),
            ),
            arrowItem: Image.asset(
              'images/arrow.png',
              width: 20.0,
              height: 20.0,
              color: const Color(0xff0C6BFE),
              fit: BoxFit.fill,
            ),
            errorArrowItem: Image.asset(
              'images/arrow.png',
              width: 20.0,
              height: 20.0,
              fit: BoxFit.fill,
              color: const Color(0xffFB2E4E),
            ),
            answer: _gesture.length > 0
                ? _gesture.split(',').map<int>((e) => int.parse(e)).toList()
                : null,
            color: Colors.lightGreen,
            onComplete: (data) {
              if (data.length >= 4) {
                if (_gesture == '') {
                  _gesture = data.join(',');
                  setState(() {
                    _notice = '请再次确认手势';
                  });
                } else {
                  if (_gesture == data.join(',')) {
                    if ((User().gestureUnlock ?? '') == '') {
                      setState(() {
                        _notice = '设置成功！';
                      });
                    } else {
                      setState(() {
                        _notice = '绘制成功！';
                      });
                    }
                    User().saveGesture(_gesture);
                  } else {
                    if ((User().gestureUnlock ?? '') == '') {
                      setState(() {
                        _notice = '与上次图案不符，请重试！';
                      });
                    } else {
                      setState(() {
                        _notice = '密码错误，请重试！';
                      });
                    }
                  }
                }
              } else {
                setState(() {
                  _notice = '请至少连接4个点';
                });
              }
              setState(() {
                _result = data.join(',');
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            _result,
            style: TextStyle(fontSize: 16, color: Colors.black),
          )
        ],
      )),
    );
  }
}
