import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wan_android/entity/article_entity.dart';


Widget loadMoreWidget(bool isLoading) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(isLoading ? '加载中...' : ''),
    ),
  );
}

Widget cardWidget(BuildContext context, int index, List<ArticleData> articles,
    Function showArticleDetail, Function collectArticle) {
  return Card(
      elevation: 10.0,
      child: InkWell(
        //点击带水波效果
        onTap: () => showArticleDetail(context, index),
        child: Padding(
            padding: EdgeInsets.all(5.0),
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
                              articles[index]
                                      .title
                                      ?.replaceAll("<em class='highlight'>", '')
                                      .replaceAll("<\/em>", '') ??
                                  '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon((articles[index].collect ?? false)
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              color: (articles[index].collect ?? false)
                                  ? Colors.red
                                  : null,
                              onPressed: () => collectArticle(context, index),
                            ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(articles[index].author ?? ''),
                        Expanded(
                          child: Container(),
                        ),
                        Text(articles[index].niceDate ?? ''),
                      ],
                    )),
              ],
            )),
      ));
}

void onShowDialog(context, text, onCancel, onConfirm) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text('提示！'),
            content: Text(text),
            actions: <Widget>[
              ElevatedButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onCancel();
                },
              ),
              ElevatedButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              )
            ],
          ));
}
