
## 简介

根据鸿洋大神的WanAndroid开放api开发的一个简单的flutter版本的WanAndroid客户端

![][./pic/screenshot1.jpg]
![][./pic/screenshot2.jpg]
## 功能

* 登录
* 注册
* 首页banner和文章列表
* 体系
* 导航
* 项目
* 收藏
* TODO（便签）
* 搜索

## 涉及技术点

``` 
dio: 2.1.7  //网络请求库
toast: ^0.1.5  //Toast
flutter_swiper : ^1.1.6  //滚动页面，类似ViewPager
shared_preferences: ^0.5.3+4  //sp存储
flutter_webview_plugin: ^0.3.5  //webview
date_format: ^1.0.6  //日期格式化
``` 

## 学习总结

* 1.启动页默认是白屏，可在android/app/src/main/res/drawable/launch_background.xml中设置一张图片来作为闪屏页

```
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />

    <!-- You can insert your own image assets here -->
     <item>
        <bitmap
            android:gravity="center"
            android:src="@mipmap/splash" />
    </item>
</layer-list>
```

* 2.页面跳转，两种方式：新建路由和注册路由

```
//新建路由
Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return WebViewPage(title, url);
    }));
    
//注册路由
Navigator.pushNamed(context, '/LoginPage');
MaterialApp(//main.dart中要先注册该路由
routes: <String, WidgetBuilder>{
        '/LoginPage': (context) => LoginPage(),},);
```

* 3.网络请求使用Dio库，可通过设置BaseOptions来配置基本信息，如baseUrl、超时时间等

```
BaseOptions options = BaseOptions(
      baseUrl: API.BASE_URL,
      connectTimeout: 15000,
      maxRedirects: 3,
      receiveTimeout: 10000,
    );
    Dio _dio = Dio(options);
```
如果需要在某个请求中单独设置请求头，如cookie等，可单独配置Options，Dio会自动合并BaseOptions和Options:

```
Options options = Options(headers: {'Cookie': cookies});
response = await _dio.get(url, queryParameters: params, options: options);
...
```