import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDown();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image.asset(
      'images/splash.png',
      fit: BoxFit.cover,
    );
  }

  void countDown() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/HomePage');
    });
  }
}
