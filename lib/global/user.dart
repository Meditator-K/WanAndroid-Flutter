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

  void saveCookies(List<String> cookies) {
    this.cookies = cookies;
    SpUtil.putStrList(DataKeys.COOKIE, cookies);
  }

  void saveUsername(String username) {
    this.username = username;
    SpUtil.putStr(DataKeys.USERNAME, username);
  }

  void loadUserInfo(){
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
  }

  void clearUserInfo() {
    SpUtil.putStr(DataKeys.USERNAME, null);
    SpUtil.putStrList(DataKeys.COOKIE, null);
    this.cookies = null;
    this.username = null;
  }
}
