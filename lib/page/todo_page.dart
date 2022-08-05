import 'package:date_format/date_format.dart' as DataFormat;
import 'package:flutter/material.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/constant/widget_style.dart';
import 'package:wan_android/entity/to_do_entity.dart';
import 'package:wan_android/http/api.dart';
import 'package:wan_android/http/http_manager.dart';
import 'package:wan_android/util/widget_util.dart';

import '../util/toast_util.dart';

class ToDoPage extends StatefulWidget {
  @override
  ToDoPageState createState() => ToDoPageState();
}

class ToDoPageState extends State<ToDoPage> with TickerProviderStateMixin {
  int _page = 1;
  List<ToDoData> _datas = [];
  List<ToDoData> _toDoSolved = [];
  List<ToDoData> _toDoPending = [];
  late TabController _tabController;
  var _titleController = TextEditingController();
  var _contentController = TextEditingController();
  String _completeTime = DataFormat.formatDate(DateTime.now(),
      [DataFormat.yyyy, '-', DataFormat.mm, '-', DataFormat.dd]);
  bool _isAdd = true; //添加还是更新

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadToDoList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('便签'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: () => _addToDo(context))
        ],
      ),
      body: _datas.length > 0
          ? RefreshIndicator(
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            height: 48,
                            color: ThemeData().primaryColor,
                            child: TabBar(
                              labelStyle: TextStyle(fontSize: 16),
                              labelPadding:
                                  EdgeInsets.only(left: 50, right: 50),
                              indicatorColor: Colors.white,
                              tabs: <Widget>[
                                Tab(
                                  text: '未完成',
                                ),
                                Tab(
                                  text: '已完成',
                                )
                              ],
                              isScrollable: true,
                              controller: _tabController,
                            )))
                  ]),
                  Expanded(
                      child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                        ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                _itemBuilder(context, index, _toDoPending),
                            separatorBuilder: _separatedBuilder,
                            itemCount: _toDoPending.length),
                        ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                _itemBuilder(context, index, _toDoSolved),
                            separatorBuilder: _separatedBuilder,
                            itemCount: _toDoSolved.length),
                      ]))
                ],
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

  Widget _separatedBuilder(BuildContext context, int index) {
    return Container(
      constraints: BoxConstraints.tightFor(height: 1),
      color: Colors.black45,
    );
  }

  Widget _itemBuilder(
      BuildContext context, int index, List<ToDoData> todoList) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    todoList[index].title ?? '',
                    style: WidgetStyle.TREE_TITLE_TEXT_STYLE,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 8,
                  ),
                  Text(
                    todoList[index].content ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Text(todoList[index].dateStr ?? ''),
                      Expanded(
                        child: Container(),
                      ),
                      Text(todoList[index].status == 1
                          ? '完成：${todoList[index].completeDateStr}'
                          : '')
                    ],
                  )
                ],
              ),
            ),
            Container(
                width: 30,
                height: 100,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black54,
                          ),
                          onPressed: () =>
                              _deleteItem(context, index, todoList)),
                    ),
                    Expanded(
                        child: IconButton(
                            icon: Icon(
                                todoList[index].status == 0
                                    ? Icons.check_box
                                    : Icons.reply,
                                color: Colors.black54),
                            onPressed: () =>
                                _changeStatus(context, index, todoList)))
                  ],
                ))
          ],
        ),
      ),
      onTap: () => _showToDoDetail(context, index, todoList),
    );
  }

  void _addToDo(BuildContext context) {
    _isAdd = true;
    _titleController.text = '';
    _contentController.text = '';
    _completeTime = DataFormat.formatDate(DateTime.now(),
        [DataFormat.yyyy, '-', DataFormat.mm, '-', DataFormat.dd]);
    _showToDoDialog(context, 0, []);
  }

  void _showToDoDialog(
      BuildContext context, int index, List<ToDoData> todoList) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return AlertDialog(
              title: Text('便签'),
              content: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        hintText: '标题', border: OutlineInputBorder()),
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    controller: _contentController,
                    maxLines: 6,
                    decoration: InputDecoration(
                        hintText: '详情', border: OutlineInputBorder()),
                  ),
                  Container(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Text('预计完成时间：'),
                      GestureDetector(
                        child: Text(
                          _completeTime,
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onTap: () {
                          showDatePicker(
                                  locale: Locale('zh'),
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 30)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 30)))
                              .then((dateTime) {
                            state(() {
                              _completeTime = DataFormat.formatDate(dateTime!, [
                                DataFormat.yyyy,
                                '-',
                                DataFormat.mm,
                                '-',
                                DataFormat.dd
                              ]);
                            });
                          });
                        },
                      )
                    ],
                  ),
                ],
              )),
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
                    if (_isAdd) {
                      _addToDoConfirm();
                    } else {
                      _updateToDo(index, todoList);
                    }
                  },
                )
              ],
            );
          });
        });
  }

  void _addToDoConfirm() {
    String title = _titleController.text;
    String content = _contentController.text;
    if (title.isEmpty) {
      ToastUtil.showToast( '请输入标题');
      return;
    }
    var params = {'title': title, 'content': content, 'date': _completeTime};
    HttpManager.getInstance()
        .postWithCookie(API.ADD_TODO_URL, params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('添加便签成功');
        _onRefresh();
      } else {
        print('添加便签失败');
      }
    });
  }

  void _showToDoDetail(
      BuildContext context, int index, List<ToDoData> todoList) {
    _isAdd = false;
    _titleController.text = todoList[index].title ?? '';
    _contentController.text = todoList[index].content ?? '';
    _completeTime = todoList[index].dateStr ?? '';
    _showToDoDialog(context, index, todoList);
  }

  void _updateToDo(int index, List<ToDoData> todoList) {
    String title = _titleController.text;
    String content = _contentController.text;
    if (title.isEmpty) {
      ToastUtil.showToast( '请输入标题');
      return;
    }
    int id = todoList[index].id ?? 0;
    var params = {'title': title, 'content': content, 'date': _completeTime};
    HttpManager.getInstance()
        .postWithCookie(API.updateToDoUrl(id), params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('更新便签成功');
        _onRefresh();
      } else {
        print('更新便签失败');
      }
    });
  }

  void _deleteItem(BuildContext context, int index, List<ToDoData> todoList) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('提示'),
              content: Text('确定删除该条便签？'),
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
                    _deleteStatus(index, todoList);
                  },
                )
              ],
            ));
  }

  void _changeStatus(BuildContext context, int index, List<ToDoData> todoList) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('提示'),
              content: Text(todoList[index].status == 0
                  ? '是否将该条标记为已完成？'
                  : '是否将该条标记为未完成？'),
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
                    _updateStatus(index, todoList);
                  },
                )
              ],
            ));
  }

  void _deleteStatus(int index, List<ToDoData> todoList) {
    int id = todoList[index].id ?? 0;
    HttpManager.getInstance()
        .postWithCookie(API.deleteToDoUrl(id), Map<String, dynamic>())
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('删除便签成功');
        _onRefresh();
      } else {
        print('删除便签失败');
      }
    });
  }

  void _updateStatus(int index, List<ToDoData> todoList) {
    int oldStatus = todoList[index].status ?? 0;
    int newStatus = oldStatus == 1 ? 0 : 1;
    int id = todoList[index].id ?? 0;
    var params = {'status': newStatus};
    HttpManager.getInstance()
        .postWithCookie(API.changeToDoStatusUrl(id), params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        print('更新便签状态成功');
        _onRefresh();
      } else {
        print('更新便签状态失败');
      }
    });
  }

  void _loadToDoList() {
    //orderby 1:完成日期顺序；2.完成日期逆序；3.创建日期顺序；4.创建日期逆序(默认)；
    var params = {'orderby': 4};
    HttpManager.getInstance()
        .getWithCookie(API.getToDoListUrl(_page), params)
        .then((baseEntity) {
      if (baseEntity.code == HttpCode.SUCCESS &&
          baseEntity.data?.errorCode == HttpCode.ERROR_CODE_SUC) {
        ToDoEntity entity = ToDoEntity.fromJson(baseEntity.data?.data);
        List<ToDoData> datas = entity.datas ?? [];
        _datas.addAll(datas);
        for (var item in _datas) {
          if (item.status == 1) {
            _toDoSolved.add(item);
          } else {
            _toDoPending.add(item);
          }
        }
        setState(() {});
      } else {
        print('请求TODO列表失败');
      }
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      _page = 1;
      _datas.clear();
      _toDoSolved.clear();
      _toDoPending.clear();
      _loadToDoList();
    });
  }
}
