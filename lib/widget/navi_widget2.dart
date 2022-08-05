import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/entity/navi_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';

///页面用联动方式
class NaviWidget extends StatefulWidget {
  @override
  _NaviWidgetState createState() => _NaviWidgetState();
}

class _NaviWidgetState extends State<NaviWidget>
    with AutomaticKeepAliveClientMixin {
  List<NaviEntity> _naviEntities = [];
  int _currentIndex = 0;
  Map<String, GlobalKey> itemKeys = {};
  GlobalKey rootKey = GlobalKey();
  bool shouldReloadKeys = true;
  ScrollController _typeScrollController = ScrollController();
  ScrollController _contentScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNaviArticles();
    _contentScrollController.addListener(() {
      var currentTypeIndex = getCurrentTypeIndex();
      if (currentTypeIndex != _currentIndex) {
        _currentIndex = currentTypeIndex;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (shouldReloadKeys) {
      itemKeys.clear();
    }
    Widget widget = Scaffold(
      key: rootKey,
      body: _naviEntities.length > 0
          ? RefreshIndicator(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                        controller: _typeScrollController,
                        itemBuilder: _titleItemBuilder,
                        itemCount: _naviEntities.length),
                  ),
                  Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                          controller: _contentScrollController,
                          child: Column(
                            children:
                                List.generate(_naviEntities.length, (index) {
                              if (shouldReloadKeys) {
                                GlobalKey itemKey = GlobalKey();
                                itemKeys[_naviEntities[index].name ?? ''] =
                                    itemKey;
                              }
                              return Padding(
                                key: itemKeys.values.elementAt(index),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        _naviEntities[index].name ?? '',
                                        style:
                                            WidgetStyle.TREE_TITLE_TEXT_STYLE2,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Container(
                                        child: Wrap(
                                            direction: Axis.horizontal,
                                            spacing: 5.0,
                                            runSpacing: 8.0,
                                            children:
                                                getWrapWidget(context, index)),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          )))
                ],
              ),
              onRefresh: _onRefresh)
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
    );
    shouldReloadKeys = false;
    return widget;
  }

  Widget _titleItemBuilder(BuildContext context, int index) {
    return Container(
        alignment: Alignment.center,
        color: _currentIndex == index ? Colors.white : Colors.black12,
        child: GestureDetector(
          onTap: () => _selectItem(context, index),
          child: Padding(
            padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
            child: Text(
              _naviEntities[index].name ?? '',
              style: TextStyle(
                  color: _currentIndex == index ? Colors.green : Colors.black),
            ),
          ),
        ));
  }

  void _selectItem(BuildContext context, int index) {
    print('点击了${_naviEntities[index].name}');
    if (index == _currentIndex) {
      return;
    }
    double offset =
        getOffsetForTargetTypeIndex(_contentScrollController.offset, index);
    if (offset != 0) {
      _contentScrollController.animateTo(offset,
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    }
  }

  List<Widget> getWrapWidget(BuildContext context, int index) {
    List<Widget> widgets = [];
    for (var item in (_naviEntities[index].articles ?? [])) {
      widgets.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return WebViewPage(
                  arguments: {'title': item.title, 'url': item.link});
            }));
          },
          child: Chip(
              backgroundColor: WidgetStyle.getRandomColor(),
              label: Text(
                item.title,
              ))));
    }
    return widgets;
  }

  void _loadNaviArticles() {
    HttpManager.getInstance()
        .getWithCookie(API.NAVI_URL, null)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('请求导航文章成功');
        List<NaviEntity> naviEntities = [];
        var navis = baseEntity.data?.data;
        for (var item in navis) {
          NaviEntity naviEntity = NaviEntity.fromJson(item);
          naviEntities.add(naviEntity);
        }
        setState(() {
          _naviEntities = naviEntities;
        });
        shouldReloadKeys = true;
      } else {
        print('请求导航文章失败');
      }
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _loadNaviArticles();
    });
  }

  ///获取当前在列表上第一个可见的导航分类序号
  int getCurrentTypeIndex() {
    try {
      if (itemKeys.length != _naviEntities.length) {
        return 0;
      }
      RenderBox? root =
          rootKey.currentContext!.findRenderObject() as RenderBox?;
      if (root == null) {
        return 0;
      }
      double rootDy = root.localToGlobal(Offset.zero).dy;
      for (int i = 0; i < itemKeys.length; i++) {
        BuildContext? context = itemKeys.values.elementAt(i).currentContext;
        if (context == null) {
          return 0;
        }
        RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null) {
          return 0;
        }
        if (i < itemKeys.length - 1) {
          BuildContext? contextNext =
              itemKeys.values.elementAt(i + 1).currentContext;
          if (contextNext == null) {
            return 0;
          }
          RenderBox? renderBoxNext =
              contextNext.findRenderObject() as RenderBox?;
          if (renderBoxNext == null) {
            return 0;
          }
          if ((renderBox.localToGlobal(Offset.zero).dy - rootDy) <= 0 &&
              (renderBoxNext.localToGlobal(Offset.zero).dy - rootDy) > 0) {
            return i;
          }
        } else {
          if ((renderBox.localToGlobal(Offset.zero).dy - rootDy) <= 0) {
            return i;
          }
        }
      }
    } catch (e) {
      print(e);
    }

    return 0;
  }

  ///获取指定导航分类需要滚动到列表最上方所需的偏移量
  double getOffsetForTargetTypeIndex(double currentOffset, int typeIndex) {
    try {
      if (itemKeys.length != _naviEntities.length ||
          typeIndex >= itemKeys.length) {
        return 0;
      }
      RenderBox? root =
          rootKey.currentContext!.findRenderObject() as RenderBox?;
      if (root == null) {
        return 0;
      }
      double rootDy = root.localToGlobal(Offset.zero).dy;
      BuildContext? context =
          itemKeys.values.elementAt(typeIndex).currentContext;
      if (context == null) {
        return 0;
      }
      RenderBox? renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) {
        return 0;
      }
      double offset = renderBox.localToGlobal(Offset.zero).dy - rootDy;
      return currentOffset + offset + 1;
    } catch (e) {
      print(e);
    }
    return 0;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
