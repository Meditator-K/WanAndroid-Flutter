import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/entity/tree_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/treedetail_page.dart';

class TreeWidget extends StatefulWidget {
  @override
  _TreeWidgetPage createState() => _TreeWidgetPage();
}

class _TreeWidgetPage extends State<TreeWidget> {
  List<TreeEntity> _treeArticles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTree();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _treeArticles.length > 0
          ? RefreshIndicator(
              child: ListView.separated(
                  itemBuilder: _itemBuilder,
                  separatorBuilder: (context, index) {
                    return Container(
                      constraints: BoxConstraints.tightFor(height: 1),
                      color: Colors.lightBlue,
                    );
                  },
                  itemCount: _treeArticles.length),
              onRefresh: onRefresh)
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
            _treeArticles[index].name??'',
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
    for (var tree in _treeArticles[index].children??[]) {
      widgets.add(GestureDetector(
          onTap: () => _toTreeDetail(context, index, tree.id),
          child: Chip(
              backgroundColor: WidgetStyle.getRandomColor(),
              label: Text(
                tree.name,
              ))));
    }
    return widgets;
  }

  Future<Null> onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _treeArticles.clear();
      loadTree();
    });
  }

  _toTreeDetail(BuildContext context, int index, int id) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TreeDetailPage(_treeArticles[index], id);
    }));
  }

  loadTree() {
    HttpManager.getInstance().get(API.TREE_URL, null).then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('请求体系文章成功');
        List<TreeEntity> treeArticles = [];
        var trees = baseEntity.data?.data;
        for (var item in trees) {
          TreeEntity treeEntity = TreeEntity.fromJson(item);
          treeArticles.add(treeEntity);
        }
        setState(() {
          _treeArticles = treeArticles;
        });
      } else {
        print('请求体系文章失败');
      }
    });
  }
}
