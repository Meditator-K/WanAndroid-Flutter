import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gesture_password_widget/widget/gesture_password_widget.dart';

class GestureUnlockPage extends StatefulWidget {
  @override
  _GestureUnlockState createState() => _GestureUnlockState();
}

class _GestureUnlockState extends State<GestureUnlockPage> {
  String _result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图案识别'),
      ),
      body: Column(
        children: [
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
            answer: [0, 1, 2, 4, 7],
            color: Colors.grey,
            onComplete: (data) {
              setState(() {
                _result = data.join(', ');
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
      ),
    );
  }
}
