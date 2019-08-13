import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  String title;
  String url;

  WebViewPage(this.title, this.url);

  @override
  WebPageState createState() => WebPageState(this.title, this.url);
}

class WebPageState extends State<WebViewPage> {
  String title;
  String url;
  FlutterWebviewPlugin webviewPlugin = FlutterWebviewPlugin();

//  final Completer<WebViewController> _controller =
//      Completer<WebViewController>();

  WebPageState(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('title:$title');
    print('url:$url');
    return WebviewScaffold(
      url: url,
      withJavascript: true,
      withZoom: false,
      withLocalStorage: true,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              webviewPlugin.reload();
            },
          )
        ],
      ),
    );
//      Scaffold(
//        appBar: AppBar(
//          title: Text(
//            title,
//            style: TextStyle(fontSize: 16),
//          ),
//          actions: <Widget>[
//            PopupMenuButton<String>(
//              onSelected: (String value) {
////                _controller.future.then((webViewController){
////                  //刷新页面
////                  webViewController.loadUrl(url);
////                });
//              },
//              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//                PopupMenuItem(
//                  child: Text('刷新'),
//                  value: '刷新',
//                )
//              ],
//              offset: Offset(0.0, 50.0),
//              padding: EdgeInsets.zero,
//            )
//          ],
//        ),
//        body:
//        Builder(builder: (BuildContext context) {
//          return WebView(
//            initialUrl: url,
//            javascriptMode: JavascriptMode.unrestricted,
//            onWebViewCreated: (WebViewController controller) {
//              _controller.complete(controller);
//            },
//          );
//        }
//        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    webviewPlugin.close();
  }
}
