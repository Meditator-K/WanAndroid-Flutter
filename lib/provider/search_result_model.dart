import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/article_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';
import 'package:wan_android/util/data_helper.dart';

///搜索结果提供者
class SearchResultModel extends ChangeNotifier {
  List<ArticleData> _articles = [];

  bool _isLoadMore = false;

  int _page = 0;

  int _currentPage = 0;

  int _pageCount = 0;

  get articles => _articles;

  get isLoadMore => _isLoadMore;

  changeLoadState() {
    _isLoadMore = !_isLoadMore;
    notifyListeners();
  }

  addPage() {
    _page++;
  }

  doSearch(String keywords) {
    var params = {'k': keywords};
    HttpManager.getInstance()
        .post(API.getSearchUrl(_page), params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        ArticleEntity articleEntity =
            ArticleEntity.fromJson(baseEntity.data?.data);
        _currentPage = articleEntity.curPage ?? 0;
        _pageCount = articleEntity.pageCount ?? 0;
        List<ArticleData> articles = articleEntity.datas ?? [];
        _articles.addAll(articles);
        _isLoadMore = false;
        notifyListeners();
      } else {
        print('搜索失败！');
      }
    });
  }

  Future<void> onRefresh(String keywords) async {
    await Future.delayed(Duration(seconds: 1), () {
      _articles.clear();
      _page = 0;
      doSearch(keywords);
    });
  }

  void collectArticle(BuildContext context, int index) {
    int id = _articles[index].id ?? 0;
    DataHelper.collectArticle(context, id, _articles[index].collect ?? false)
        .then((isSuccess) {
      if (isSuccess) {
        _articles[index].collect = !(_articles[index].collect ?? false);
        notifyListeners();
      }
    });
  }

  void showArticleDetail(BuildContext context, int index) {
    //点击条目,跳转到webview页面
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

  bool hasMore() {
    return _currentPage < _pageCount;
  }
}
