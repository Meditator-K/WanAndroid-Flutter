import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/project_entity.dart';
import 'package:wan_android/entity/project_list_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/page/web_page.dart';
import 'package:wan_android/util/data_helper.dart';
import 'package:wan_android/util/widget_util.dart';

class ProjectWidget extends StatefulWidget {
  @override
  _ProjectWidgetState createState() => _ProjectWidgetState();
}

class _ProjectWidgetState extends State<ProjectWidget>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<ProjectEntity> _projects;

  List<List<ProjectListData>> _projectList = [];
  ScrollController _scrollController = ScrollController();
  int _index = 0;
  int _page = 1;
  bool isLoadMore = false;
  bool isInitComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTab();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑到了最底部,上拉加载');
        getMore();
      }
    });
  }

  void initTabController() {
    _tabController = TabController(length: _projects.length, vsync: this)
      ..addListener(() {
        if (_tabController.index.toDouble() == _tabController.animation.value) {
          //要加这个判断，否则点击tab，会请求两次
          _index = _tabController.index;
          _page = 1;
          if (_projectList[_index].length == 0) {
            _loadTabView();
          } else {
            setState(() {
              _index = _tabController.index;
            });
          }
        }
      });
    setState(() {
      isInitComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: isInitComplete
              ? TabBar(
                  isScrollable: true,
                  tabs: _tabWidgets(),
                  controller: _tabController,
                )
              : Text('')),
      body: isInitComplete
          ? TabBarView(
              children: _tabBarViewWidgets(),
              controller: _tabController,
            )
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
    );
  }

  List<Widget> _tabWidgets() {
    List<Widget> widgets = [];
    for (var item in _projects) {
      widgets.add(Tab(
        text: item.name,
      ));
    }
    return widgets;
  }

  List<Widget> _tabBarViewWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < _projects.length; i++) {
      widgets.add(RefreshIndicator(
          child: _projectList[i].length > 0
              ? ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),//始终能滚动，否则条目不占满屏幕时无法触发下拉刷新
                  itemBuilder: (context, index) =>
                      _itemBuilder(context, index, i),
                  separatorBuilder: (context, index) {
                    return Container(
                      constraints: BoxConstraints.tightFor(height: 1),
                    );
                  },
                  itemCount: _projectList[i].length + 1,
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
    if (index < _projectList[i].length) {
      return Card(
          elevation: 10.0,
          child: InkWell(
            //点击带水波效果
            onTap: () => _showArticleDetail(context, index),
            child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 4,
                                    child: Text(
                                      _projectList[i][index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(_projectList[i][index].collect
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      color: _projectList[i][index].collect
                                          ? Colors.red
                                          : null,
                                      onPressed: () =>
                                          _collectArticle(context, index),
                                    ))
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: <Widget>[
                                Text(_projectList[i][index].author),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(_projectList[i][index].niceDate),
                              ],
                            )),
                      ],
                    )),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 2, 6, 2),
                      child: Image.network(
                        _projectList[i][index].envelopePic,
                        width: 60,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    )
                  ],
                )),
          ));
    }
    return loadMoreWidget(isLoadMore);
  }

  void _loadTab() {
    HttpManager.getInstance().get(API.PROJECT_URL, null).then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data.errorCode == HttpCode.ERROR_CODE_SUC) {
        List<ProjectEntity> projects = [];
        for (var item in baseEntity.data.data) {
          ProjectEntity projectEntity = ProjectEntity.fromJson(item);
          projects.add(projectEntity);
        }
        _projects = projects;
        _projects.forEach((item) {
          _projectList.add([]);
        });
        _loadTabView();
      } else {
        print('项目Tab请求失败');
      }
    });
  }

  void _loadTabView() {
    var params = {'cid': _projects[_index].id};
    HttpManager.getInstance()
        .getWithCookie(API.getProjectListUrl(_page), params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('项目列表请求成功');
        ProjectListEntity projectListEntity =
            ProjectListEntity.fromJson(baseEntity.data.data);
        if (!isInitComplete) {
          _projectList[_index].addAll(projectListEntity.datas);
          initTabController();
        } else {
          setState(() {
            isLoadMore = false;
            _projectList[_index].addAll(projectListEntity.datas);
          });
        }
      } else {
        print('项目列表请求失败');
      }
    });
  }

  getMore() {
    if (!isLoadMore) {
      _page++;
      setState(() {
        isLoadMore = true;
      });
      _loadTabView();
    }
  }

  void _showArticleDetail(BuildContext context, int index) {
    //点击条目,跳转到webview页面
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return WebViewPage(
          _projectList[_index][index].title, _projectList[_index][index].link);
    }));
  }

  void _collectArticle(BuildContext context, int index) {
    int id = _projectList[_index][index].id;
    DataHelper.collectArticle(context, id, _projectList[_index][index].collect)
        .then((isSuccess) {
      if (isSuccess) {
        setState(() {
          _projectList[_index][index].collect =
              !_projectList[_index][index].collect;
        });
      }
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _page = 1;
      _projectList[_index].clear();
      _loadTabView();
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
