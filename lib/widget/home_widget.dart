import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/article_entity.dart';
import 'package:wan_android/entity/banner_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';
import 'package:wan_android/util/data_helper.dart';
import 'package:wan_android/util/widget_util.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<BannerEntity> _banners = [];
  List<ArticleData> _articles = [];
  ScrollController _scrollController = ScrollController();
  int _page = 0;
  bool _isLoadMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBanner();
    loadArticle();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑到了最底部,上拉加载');
        if (!_isLoadMore) {
          setState(() {
            _isLoadMore = true;
          });
          _page++;
          loadArticle();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: RefreshIndicator(
            child: Column(
              children: <Widget>[
                Container(
                    width: size.width,
                    height: size.width * 0.48,
                    child: _banners.length > 0
                        ? Stack(
                            children: <Widget>[
                              Swiper(
                                itemCount: _banners.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _banners.length > 0
                                      ? Image.network(
                                          _banners[index].imagePath,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Container();
                                },
                                autoplay: true,
                                pagination: new SwiperPagination(
                                    margin: EdgeInsets.all(6.0)),
                                onTap: (int index) {
                                  onBannerClick(context, index);
                                },
                              ),
                              Container(
                                height: 30.0,
                                color: Colors.black12,
                              )
                            ],
                            alignment: Alignment.bottomCenter,
                          )
                        : Container(
                            width: size.width, height: size.width * 0.48)),
                Expanded(
                  child: _articles.length > 0
                      ? ListView.separated(
                          itemBuilder: _itemBuilder,
                          separatorBuilder: (context, index) {
                            return Container(
                              constraints: BoxConstraints.tightFor(height: 2),
                            );
                          },
                          itemCount: _articles.length + 1,
                          controller: _scrollController,
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                          ),
                        ),
                )
              ],
            ),
            onRefresh: _onRefresh));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index < _articles.length) {
      return cardWidget(
          context, index, _articles, _showArticleDetail, _collectArticle);
    }
    return loadMoreWidget(_isLoadMore);
  }

  void initBanner() {
    //获取首页banner信息
    HttpManager.getInstance().get(API.BANNER_URL, null).then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data.errorCode == HttpCode.ERROR_CODE_SUC) {
        List<BannerEntity> banners = [];
        var bannerList = baseEntity.data.data;
        for (var item in bannerList) {
          BannerEntity bannerEntity = BannerEntity.fromJson(item);
          banners.add(bannerEntity);
        }
        setState(() {
          _banners = banners;
        });
      } else {
        print('获取banner信息失败！');
      }
    });
  }

  void loadArticle() {
    //加载首页文章列表
    HttpManager.getInstance()
        .getWithCookie(API.getArticleListUrl(_page), null)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data.errorCode == HttpCode.ERROR_CODE_SUC) {
        ArticleEntity articleEntity =
            ArticleEntity.fromJson(baseEntity.data.data);
        List<ArticleData> articles = articleEntity.datas;
        setState(() {
          _isLoadMore = false;
          _articles.addAll(articles);
        });
      } else {
        print('获取文章列表失败！');
      }
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _articles.clear();
      _page = 0;
      loadArticle();
    });
  }

  void onBannerClick(BuildContext context, int index) {
    print('点击了banner');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return WebViewPage(_banners[index].title, _banners[index].url);
    }));
  }

  void _collectArticle(BuildContext context, int index) {
    int id = _articles[index].id;
    DataHelper.collectArticle(context, id, _articles[index].collect)
        .then((isSuccess) {
      if (isSuccess) {
        setState(() {
          _articles[index].collect = !_articles[index].collect;
        });
      }
    });
  }

  void _showArticleDetail(BuildContext context, int index) {
    //点击条目,跳转到webview页面
    print('点击了文章');
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return WebViewPage(_articles[index].title, _articles[index].link);
    }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}
