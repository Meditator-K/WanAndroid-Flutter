import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/global/user.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/util/toast_util.dart';
import 'package:wan_android/util/widget_util.dart';

class DataHelper {
  static Future<bool> collectArticle(
      BuildContext context, int id, bool isCollected) async {
    List<String> cookies = User().cookies ?? [];
    if (cookies.isEmpty) {
      print('尚未登录');
      Navigator.pushNamed(context, '/LoginPage');
      return false;
    }
    bool isSuccess = false;
    await HttpManager.getInstance()
        .postWithCookie(
            isCollected ? API.getUnCollectUrl(id) : API.getCollectUrl(id),
            Map<String, dynamic>())
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        print((isCollected ? '取消' : '') + '收藏文章成功');
        ToastUtil.showToast((isCollected ? '取消' : '') + '收藏成功');
        isSuccess = true;
      } else {
        print((isCollected ? '取消' : '') + '收藏文章失败');
        ToastUtil.showToast((isCollected ? '取消' : '') + '收藏失败');
        isSuccess = false;
      }
    });
    return isSuccess;
  }
}
