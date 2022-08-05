import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/collect_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';
import 'package:wan_android/util/data_helper.dart';
import 'package:wan_android/util/widget_util.dart';

class CollectListPage extends StatefulWidget {
  @override
  _CollectListPageState createState() => _CollectListPageState();
}

class _CollectListPageState extends State<CollectListPage> {
  int _page = 0;
  List<CollectData> _collectList = [];
  ScrollController _scrollController = ScrollController();
  bool _isLoadMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCollect();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑到了最底部,上拉加载');
        if (!_isLoadMore) {
          setState(() {
            _isLoadMore = true;
          });
          _page++;
          _loadCollect();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('我的收藏')),
      body: RefreshIndicator(
          child: _collectList.length > 0
              ? ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Container(
                      constraints: BoxConstraints.tightFor(height: 1),
                      color: Colors.blueGrey,
                    );
                  },
                  itemBuilder: (context, index) => _itemBuilder(context, index),
                  itemCount: _collectList.length + 1,
                  controller: _scrollController,
                )
              : Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 4,
                )),
          onRefresh: _onRefresh),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index < _collectList.length) {
      return InkWell(
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WebViewPage(arguments: {
            'title': _collectList[index].title,
            'url': _collectList[index].link
          });
        })),
        onLongPress: () => _onItemLongPress(context, index),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _collectList[index].title??'',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Text(_collectList[index].author??''),
                  Expanded(
                    child: Container(),
                  ),
                  Text(_collectList[index].niceDate??''),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return loadMoreWidget(_isLoadMore);
    }
  }

  void _onItemLongPress(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('提示！'),
              content: Text('是否取消该条收藏？'),
              actions: <Widget>[
                FlatButton(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _unCollect(index);
                  },
                )
              ],
            ));
  }

  void _unCollect(int index) {
    DataHelper.collectArticle(context, _collectList[index].originId??0, true)
        .then((isSuccess) {
      if (isSuccess) {
        setState(() {
          _collectList.removeAt(index);
        });
      }
    });
  }

  void _loadCollect() {
    HttpManager.getInstance()
        .getWithCookie(API.getCollectListUrl(_page), Map<String, dynamic>())
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        CollectEntity collectEntity =
            CollectEntity.fromJson(baseEntity.data?.data);
        setState(() {
          _collectList.addAll(collectEntity.datas??[]);
          _isLoadMore = false;
        });
      } else {
        print('请求收藏列表失败');
      }
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _collectList.clear();
      _page = 0;
      _loadCollect();
    });
  }
}
