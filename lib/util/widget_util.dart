import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wan_android/entity/article_entity.dart';

class ToastUtil {
  static showToast(BuildContext context, String msg) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}

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
                                  .replaceAll("<em class='highlight'>", '')
                                  .replaceAll("<\/em>", ''),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(articles[index].collect
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              color:
                                  articles[index].collect ? Colors.red : null,
                              onPressed: () => collectArticle(context, index),
                            ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Text(articles[index].author),
                        Expanded(
                          child: Container(),
                        ),
                        Text(articles[index].niceDate),
                      ],
                    )),
              ],
            )),
      ));
}
