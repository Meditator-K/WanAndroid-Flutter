import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/article_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';
import 'package:wan_android/util/data_helper.dart';
import 'package:wan_android/util/widget_util.dart';

class SearchResultPage extends StatefulWidget {
  String keywords;

  SearchResultPage(this.keywords);

  @override
  _ResultPageState createState() => _ResultPageState(keywords);
}

class _ResultPageState extends State<SearchResultPage> {
  String keywords;
  int page = 0;
  List<ArticleData> _articles = [];
  bool isLoadMore = false;
  ScrollController _scrollController = ScrollController();

  _ResultPageState(this.keywords);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doSearch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑到了最底部,上拉加载');
        if (!isLoadMore) {
          setState(() {
            isLoadMore = true;
          });
          page++;
          _doSearch();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(keywords),
      ),
      body: _articles.length > 0
          ? RefreshIndicator(
              child: ListView.separated(
                itemBuilder: _itemBuilder,
                separatorBuilder: (context, index) {
                  return Container(
                    constraints: BoxConstraints.tightFor(height: 2),
                  );
                },
                itemCount: _articles.length + 1,
                controller: _scrollController,
              ),
              onRefresh: _onRefresh,
            )
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index < _articles.length) {
      return cardWidget(
          context, index, _articles, _showArticleDetail, _collectArticle);
    }
    return loadMoreWidget(isLoadMore);
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _articles.clear();
      page = 0;
      _doSearch();
    });
  }

  void _collectArticle(BuildContext context, int index) {
    int id = _articles[index].id??0;
    DataHelper.collectArticle(context, id, _articles[index].collect??false)
        .then((isSuccess) {
      if (isSuccess) {
        setState(() {
          _articles[index].collect = !(_articles[index].collect??false);
        });
      }
    });
  }

  void _showArticleDetail(BuildContext context, int index) {
    //点击条目,跳转到webview页面
    print('点击了文章');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return WebViewPage(arguments: {
        'title': _articles[index]
            .title
            ?.replaceAll("<em class='highlight'>", '')
            .replaceAll("<\/em>", ''),
        'url': _articles[index].link
      });
    }));
  }

  void _doSearch() {
    var params = {'k': keywords};
    HttpManager.getInstance()
        .post(API.getSearchUrl(page), params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        ArticleEntity articleEntity =
            ArticleEntity.fromJson(baseEntity.data?.data);
        List<ArticleData> articles = articleEntity.datas??[];
        setState(() {
          _articles.addAll(articles);
          isLoadMore = false;
        });
      } else {
        print('搜索失败！');
        ToastUtil.showToast(context, '搜索失败');
      }
    });
  }
}
