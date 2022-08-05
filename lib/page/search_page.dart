import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/entity/hotkey_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/search_result_page.dart';
import 'package:wan_android/util/widget_util.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  var _searchTextController = TextEditingController();
  bool isInputing = false;

  List<String> _hotkey = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTextController.addListener(() {
      if (_searchTextController.text.isNotEmpty) {
        setState(() {
          print(_searchTextController.text);
          isInputing = true;
        });
      }
    });
    _getHotkey();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (text) => _doSearch(context, _searchTextController.text),
          autofocus: true,
          style: WidgetStyle.BTN_STYLE,
          controller: _searchTextController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              border: InputBorder.none,
              suffixIcon: isInputing
                  ? IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _clearText,
                    )
                  : Container(
                      width: 2,
                      height: 2,
                    ),
              hintText: '请输入搜索内容',
              hintStyle: WidgetStyle.BTN_STYLE),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () => _doSearch(context, _searchTextController.text),
          )
        ],
      ),
      body: _hotkey.length > 0
          ? Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '热门搜索',
                    style: WidgetStyle.COMMON_SEARCH_TEXT_STYLE,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 5,
                    children: _setCommonText(context),
                  )
                ],
              ))
          : Center(
              child: CircularProgressIndicator(
              strokeWidth: 4,
            )),
    );
  }

  List<Widget> _setCommonText(BuildContext context) {
    List<Widget> widgets = [];
    for (var item in _hotkey) {
      widgets.add(GestureDetector(
        onTap: () {
          _doSearch(context, item);
        },
        child: Chip(
          label: Text(item),
          backgroundColor: WidgetStyle.getRandomColor(),
        ),
      ));
    }
    return widgets;
  }

  void _clearText() {
    _searchTextController.clear();
    setState(() {
      isInputing = false;
    });
  }

  void _getHotkey() {
    HttpManager.getInstance().getWithCookie(API.HOTKEY_URL, null).then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        var hotkeyEntities = baseEntity.data?.data;
        List<String> hotkey = [];
        for (var item in hotkeyEntities) {
          HotkeyEntity hotkeyEntity = HotkeyEntity.fromJson(item);
          hotkey.add(hotkeyEntity.name??'');
        }
        setState(() {
          _hotkey.addAll(hotkey);
        });
      } else {
        print('请求搜索热词失败');
      }
    });
  }

  void _doSearch(BuildContext context, String text) {
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
