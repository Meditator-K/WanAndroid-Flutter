import 'package:wan_android/constant/data_keys.dart';
import 'package:wan_android/util/sp_util.dart';

class User {
  static User? _instance;

  factory User() => _getInstance();

  User._internal();

  static User _getInstance() {
    if (_instance == null) {
      _instance = User._internal();
    }
    return _instance!;
  }

  List<String>? cookies;
  String? username;
  bool fingerprintUnlock = false; //是否设置指纹识别
  String? gestureUnlock; //是否设置手势识别

  void saveCookies(List<String> cookies) {
    this.cookies = cookies;
    SpUtil.putStrList(DataKeys.COOKIE, cookies);
  }

  void saveUsername(String username) {
    this.username = username;
    SpUtil.putStr(DataKeys.USERNAME, username);
  }

  void saveFingerprint(bool fingerprint) {
    this.fingerprintUnlock = fingerprint;
    SpUtil.putBool(DataKeys.FINGERPRINT_UNLOCK, fingerprint);
  }

  void saveGesture(String gesture) {
    this.gestureUnlock = gesture;
    SpUtil.putStr(DataKeys.GESTURE_UNLOCK, gesture);
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
    SpUtil.getStr(DataKeys.GESTURE_UNLOCK).then((value) {
      if (value != null) {
        this.gestureUnlock = value;
      }
    });
  }

  void clearUserInfo() {
    SpUtil.putStr(DataKeys.USERNAME, '');
    SpUtil.putStrList(DataKeys.COOKIE, []);
    this.cookies = [];
    this.username = '';
  }
}
