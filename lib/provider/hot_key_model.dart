import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/entity/hotkey_entity.dart';
import 'package:wan_android/page/search_result_page2.dart';
import 'package:wan_android/util/widget_util.dart';

///热词提供者
class HotKeyModel extends ChangeNotifier {
  List<String> _hotKey = [];

  get hotKey => _hotKey;

  getHotKey() {
    HttpManager.getInstance()
        .getWithCookie(API.HOTKEY_URL, null)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data.errorCode == HttpCode.ERROR_CODE_SUC) {
        var hotkeyEntities = baseEntity.data.data;
        List<String> hotkey = [];
        for (var item in hotkeyEntities) {
          HotkeyEntity hotkeyEntity = HotkeyEntity.fromJson(item);
          hotkey.add(hotkeyEntity.name);
        }
        _hotKey.addAll(hotkey);
        notifyListeners();
      } else {
        print('请求搜索热词失败');
      }
    });
  }

  void toSearch(BuildContext context, String text) {
    if (text.isEmpty) {
      ToastUtil.showToast(context, '请输入关键字后再搜索');
      return;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return SearchResultPage(text);
    }));
  }
}
