import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/provider/hot_key_model.dart';

///使用provider模式加载搜索热词
class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  var _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (context) => HotKeyModel()..getHotKey(),
        child: Consumer<HotKeyModel>(
            builder: (context, hotKeyModel, _) => Scaffold(
                  appBar: AppBar(
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (text) => hotKeyModel.toSearch(
                          context, _searchTextController.text),
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
                        onPressed: () => hotKeyModel.toSearch(
                            context, _searchTextController.text),
                      )
                    ],
                  ),
                  body: hotKeyModel.hotKey.length > 0
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
                                  children: List.generate(
                                    hotKeyModel.hotKey.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        hotKeyModel.toSearch(
                                            context, hotKeyModel.hotKey[index]);
                                      },
                                      child: Chip(
                                        label: Text(hotKeyModel.hotKey[index]),
                                        backgroundColor:
                                            WidgetStyle.getRandomColor(),
                                      ),
                                    ),
                                  ).toList())
                            ],
                          ))
                      : Center(
                          child: CircularProgressIndicator(
                          strokeWidth: 4,
                        )),
                )));
  }

  void _clearText() {
    _searchTextController.clear();
  }
}
