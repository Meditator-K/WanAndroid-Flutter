import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/page/search_result_page.dart';
import 'package:wan_android/provider/hot_key_model.dart';
import 'package:wan_android/util/widget_util.dart';

///使用provider模式加载搜索热词
class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  var _searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
        builder: (context) => HotKeyModel()..getHotKey(),
        child: Scaffold(
            appBar: AppBar(
              title: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (text) =>
                    _doSearch(context, _searchTextController.text),
                autofocus: true,
                style: WidgetStyle.BTN_STYLE,
                controller: _searchTextController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _clearText,
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
                  onPressed: () =>
                      _doSearch(context, _searchTextController.text),
                )
              ],
            ),
            body: Consumer<HotKeyModel>(
              builder: (context, hotKeyModel, _) =>
                  hotKeyModel.hotKey.length > 0
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
                                children: _setCommonText(context, hotKeyModel),
                              )
                            ],
                          ))
                      : Center(
                          child: CircularProgressIndicator(
                          strokeWidth: 4,
                        )),
            )));
  }

  List<Widget> _setCommonText(BuildContext context, HotKeyModel hotKeyModel) {
    List<Widget> widgets = [];
    for (var item in hotKeyModel.hotKey) {
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
