import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android/provider/search_result_model.dart';
import 'package:wan_android/util/widget_util.dart';

///使用provider方式
class SearchResultPage extends StatefulWidget {
  String keywords;

  SearchResultPage(this.keywords);

  @override
  _ResultPageState createState() => _ResultPageState(keywords);
}

class _ResultPageState extends State<SearchResultPage> {
  String keywords;

  _ResultPageState(this.keywords);

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
        create: (context) => SearchResultModel()..doSearch(keywords),
        child: Scaffold(
            appBar: AppBar(
              title: Text(keywords),
            ),
            body: Consumer<SearchResultModel>(
              builder: (context, searchResult, _) =>
                  searchResult.articles.length > 0
                      ? RefreshIndicator(
                          child: ListView.separated(
                            itemBuilder: (context, index) =>
                                _itemBuilder(context, index, searchResult),
                            separatorBuilder: (context, index) {
                              return Container(
                                constraints: BoxConstraints.tightFor(height: 2),
                              );
                            },
                            itemCount: searchResult.articles.length + 1,
                            controller: _scrollController
                              ..addListener(() {
                                if (_scrollController.position.pixels ==
                                    _scrollController
                                        .position.maxScrollExtent) {
                                  print('滑到了最底部,上拉加载');
                                  if (searchResult.hasMore() &&
                                      !searchResult.isLoadMore) {
                                    searchResult.changeLoadState();
                                    searchResult.addPage();
                                    searchResult.doSearch(keywords);
                                  }
                                }
                              }),
                          ),
                          onRefresh: () => searchResult.onRefresh(keywords),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                          ),
                        ),
            )));
  }

  Widget _itemBuilder(
      BuildContext context, int index, SearchResultModel searchResult) {
    if (index < searchResult.articles.length) {
      return cardWidget(context, index, searchResult.articles,
          searchResult.showArticleDetail, searchResult.collectArticle);
    }
    return loadMoreWidget(searchResult.isLoadMore);
  }
}
