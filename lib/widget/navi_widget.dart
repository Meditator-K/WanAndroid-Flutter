import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/entity/navi_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';

class NaviWidget extends StatefulWidget {
  @override
  _NaviWidgetState createState() => _NaviWidgetState();
}

class _NaviWidgetState extends State<NaviWidget> {
  List<NaviEntity> _naviEntities = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNaviArticles();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _naviEntities.length > 0
          ? RefreshIndicator(
              child: ListView.separated(
                  itemBuilder: _itemBuilder,
                  separatorBuilder: (context, index) {
                    return Container(
                      constraints: BoxConstraints.tightFor(height: 1),
                      color: Colors.lightBlue,
                    );
                  },
                  itemCount: _naviEntities.length),
              onRefresh: _onRefresh)
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            _naviEntities[index].name,
            style: WidgetStyle.TREE_TITLE_TEXT_STYLE,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Wrap(
                direction: Axis.horizontal,
                spacing: 5.0,
                runSpacing: 8.0,
                children: getTreeWidget(context, index)),
          ),
        )
      ],
    );
  }

  List<Widget> getTreeWidget(BuildContext context, int index) {
    List<Widget> widgets = [];
    for (var item in _naviEntities[index].articles) {
      widgets.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return WebViewPage(item.title, item.link);
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
          baseEntity.data.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('请求导航文章成功');
        List<NaviEntity> naviEntities = [];
        var navis = baseEntity.data.data;
        for (var item in navis) {
          NaviEntity naviEntity = NaviEntity.fromJson(item);
          naviEntities.add(naviEntity);
        }
        setState(() {
          _naviEntities = naviEntities;
        });
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
}
