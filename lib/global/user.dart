import 'package:wan_android/constant/data_keys.dart';
import 'package:wan_android/util/sp_util.dart';

class User {
  static final User singleton = User._internal();

  User._internal();

  factory User() {
    return singleton;
  }

  List<String> cookies;
  String username;
  bool fingerprintUnlock; //是否设置指纹识别
  bool gestureUnlock; //是否设置手势识别

  void saveCookies(List<String> cookies) {
    this.cookies = cookies;
    SpUtil.putStrList(DataKeys.COOKIE, cookies);
  }

  void saveUsername(String username) {
    this.username = username;
    SpUtil.putStr(DataKeys.USERNAME, username);
  }

  void saveFingerprint(bool fingerprint){
    this.fingerprintUnlock = fingerprint;
    SpUtil.putBool(DataKeys.FINGERPRINT_UNLOCK, fingerprint);
  }

  void saveGesture(bool gesture){
    this.gestureUnlock = gesture;
    SpUtil.putBool(DataKeys.GESTURE_UNLOCK, gesture);
  }

  void loadUserInfo() {
    SpUtil.getStrList(DataKeys.COOKIE).then((cookie) {
      if (cookie != null) {
        this.cookies = cookie;
      }
    });
    SpUtil.getStr(DataKeys.USERNAME).then((username) {
      if (username != null) {
        this.username = username;
      }
    });
    SpUtil.getBool(DataKeys.FINGERPRINT_UNLOCK).then((value) {
      if (value != null) {
        this.fingerprintUnlock = value;
      }
    });
    SpUtil.getBool(DataKeys.GESTURE_UNLOCK).then((value) {
      if (value != null) {
        this.gestureUnlock = value;
      }
    });
  }

  void clearUserInfo() {
    SpUtil.putStr(DataKeys.USERNAME, null);
    SpUtil.putStrList(DataKeys.COOKIE, null);
    this.cookies = null;
    this.username = null;
  }
}
