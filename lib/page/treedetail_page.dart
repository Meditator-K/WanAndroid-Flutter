import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/article_entity.dart';
import 'package:wan_android/entity/tree_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';
import 'package:wan_android/util/data_helper.dart';
import 'package:wan_android/util/widget_util.dart';

class TreeDetailPage extends StatefulWidget {
  final TreeEntity treeEntity; //体系文章中的某一类
  final int id; //体系文章中的某一类的某一个tab

  TreeDetailPage(this.treeEntity, this.id);

  @override
  TreeDetailPageState createState() => TreeDetailPageState(treeEntity, id);
}

class TreeDetailPageState extends State<TreeDetailPage>
    with TickerProviderStateMixin {
  TreeEntity treeEntity;
  int id;

  late TabController _tabController;
  List<Treechild> _treeChildren = [];

  //存储每个tab下的文章列表
  List<List<ArticleData>> _articleList = [];
  int _index = 0;
  int _page = 0;
  ScrollController _scrollController = ScrollController();
  bool isLoadMore = false;

  TreeDetailPageState(this.treeEntity, this.id);

  @override
  void initState() {
    super.initState();
    _treeChildren = treeEntity.children ?? [];
    for (var item in _treeChildren) {
      _articleList.add([]);
      if (item.id == id) {
        _index = _treeChildren.indexOf(item);
      }
    }
    _tabController = TabController(
        initialIndex: _index, length: _treeChildren.length, vsync: this)
      ..addListener(() {
        if (_tabController.index.toDouble() ==
            _tabController.animation!.value) {
          //要加这个判断，否则点击tab，会请求两次
          _index = _tabController.index;
          _page = 0;
          if (_articleList[_index].length == 0) {
            _loadArticle();
          } else {
            setState(() {
              _index = _tabController.index;
            });
          }
        }
      });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑到了最底部,上拉加载');
        if (!isLoadMore) {
          _page++;
          setState(() {
            isLoadMore = true;
          });
          _loadArticle();
        }
      }
    });
    _loadArticle();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(treeEntity.name ?? ''),
        bottom: TabBar(
          isScrollable: true,
          tabs: _tabWidgets(),
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: _tabBarViewWidget(),
        controller: _tabController,
      ),
    );
  }

  List<Widget> _tabWidgets() {
    List<Widget> widgets = [];
    for (var item in _treeChildren) {
      widgets.add(Tab(
        text: item.name,
      ));
    }
    return widgets;
  }

  List<Widget> _tabBarViewWidget() {
    List<Widget> widgets = [];
    for (int i = 0; i < _treeChildren.length; i++) {
      widgets.add(RefreshIndicator(
          child: _articleList[i].length > 0
              ? ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _itemBuilder(context, index, i),
                  separatorBuilder: (context, index) {
                    return Container(
                      constraints: BoxConstraints.tightFor(height: 2),
                    );
                  },
                  itemCount: _articleList[i].length + 1,
                  controller: _scrollController,
                )
              : Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 4,
                )),
          onRefresh: _onRefresh));
    }
    return widgets;
  }

  Widget _itemBuilder(BuildContext context, int index, int i) {
    if (index < _articleList[i].length) {
      return cardWidget(
          context, index, _articleList[i], _showArticleDetail, _collectArticle);
    }
    return loadMoreWidget(isLoadMore);
  }

  void _loadArticle() {
    var params = {'cid': _treeChildren[_index].id};
    HttpManager.getInstance()
        .getWithCookie(API.getArticleListUrl(_page), params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        ArticleEntity articleEntity =
            ArticleEntity.fromJson(baseEntity.data?.data);
        List<ArticleData> articles = articleEntity.datas ?? [];
        setState(() {
          _articleList[_index].addAll(articles);
          isLoadMore = false;
        });
      } else {
        print('获取体系文章列表失败！');
      }
    });
  }

  void _showArticleDetail(BuildContext context, int index) {
    //点击条目,跳转到webview页面
    print('点击了文章');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return WebViewPage(arguments: {
        'title': _articleList[_index][index].title,
        'url': _articleList[_index][index].link
      });
    }));
  }

  void _collectArticle(BuildContext context, int index) {
    int id = _articleList[_index][index].id ?? 0;
    DataHelper.collectArticle(
            context, id, _articleList[_index][index].collect ?? false)
        .then((isSuccess) {
      if (isSuccess) {
        setState(() {
          _articleList[_index][index].collect =
              !(_articleList[_index][index].collect ?? false);
        });
      }
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _articleList[_index].clear();
      _page = 0;
      _loadArticle();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }
}
