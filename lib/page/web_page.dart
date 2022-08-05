import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/log_util.dart';
import '../widget/common_widget.dart';

class WebViewPage extends StatefulWidget {
  final Map<String, dynamic> arguments;

  WebViewPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _WebViewPageState createState() => new _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String _title = "";
  String _url = "";
  late PullToRefreshController _pullToRefreshController;
  double _loadProgress = 0;
  InAppWebViewController? _webViewController;

  InAppWebViewGroupOptions _options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        clearCache: true,
        cacheEnabled: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
          alwaysBounceVertical: true,
          suppressesIncrementalRendering: true,
          ignoresViewportScaleLimits: true));

  @override
  void initState() {
    super.initState();
    _title = widget.arguments['title'] ?? '';
    _url = widget.arguments['url'] ?? '';

    _pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //isLeadingClick是否使用待定
          return _goBack(context, isLeadingClick: true);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: commonAppbar(_title),
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(_url)),
                initialUserScripts: UnmodifiableListView<UserScript>([]),
                initialOptions: _options,
                pullToRefreshController: _pullToRefreshController,
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {},
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  LogUtil.d('url:${uri.toString()}');
                  if (uri.toString().contains('tel:')) {
                    //拨打电话
                    LogUtil.d('拨打电话');
                    await launchUrl(Uri.parse(uri.toString()));
                    return NavigationActionPolicy.CANCEL;
                  }
                  if (uri.toString().startsWith('alipays') ||
                      uri.toString().startsWith('alipay://')) {
                    //打开支付宝
                    await launchUrl(Uri.parse(uri.toString()));
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  _pullToRefreshController.endRefreshing();
                },
                onLoadError: (controller, url, code, message) {
                  _pullToRefreshController.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    _pullToRefreshController.endRefreshing();
                  }
                  setState(() {
                    this._loadProgress = progress / 100;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  LogUtil.d('webview日志：$consoleMessage');
                },
              ),
              _loadProgress < 1.0
                  ? LinearProgressIndicator(
                      value: _loadProgress, color: Colors.blue, minHeight: 3)
                  : Container(),
            ],
          ),
        ));
  }

  //点击左上方返回箭头或全面屏返回手势
  Future<bool> _goBack(BuildContext context, {isLeadingClick = true}) async {
    if (_webViewController != null &&
        (await _webViewController?.canGoBack()) == true) {
      _webViewController?.goBack();
      return false;
    }
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    return true;
  }
}
