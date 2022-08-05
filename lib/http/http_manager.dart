import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wan_android/constant/http_code.dart';
import 'package:wan_android/entity/base_entity.dart';
import 'package:wan_android/global/user.dart';
import 'package:wan_android/http/api.dart';

class HttpManager {
  late Dio _dio;

  //单例模式
  HttpManager._internal() {
    print('dio赋值');
    BaseOptions options = BaseOptions(
      baseUrl: API.BASE_URL,
      connectTimeout: 15000,
      maxRedirects: 3,
      receiveTimeout: 10000,
    );
    _dio = Dio(options);
  }

  static HttpManager? _instance;

  static HttpManager getInstance() {
    if (_instance == null) {
      _instance = HttpManager._internal();
    }
    return _instance!;
  }

  ///get请求
  Future<BaseEntity> get(url, params) async {
    print('get请求-->url：$url ,body: $params');
    Response response;
    try {
      response = await _dio.get(url, queryParameters: params);
      if (response.statusCode == HttpStatus.ok) {
        print('get请求成功-->response data：${response.data}');
        return BaseEntity(
            HttpCode.SUCCESS, '', BaseData.fromJson(response.data));
      } else {
        print('get请求失败-->response：${response.statusCode}');
        return BaseEntity(HttpCode.FAIL, response.statusCode.toString(), null);
      }
    } catch (e) {
      print('get请求发生错误：$e');
      return BaseEntity(HttpCode.FAIL, e.toString(), null);
    }
  }

  ///get请求,带cookie，与用户相关的请求
  Future<BaseEntity> getWithCookie(url, params) async {
    print('get请求-->url：$url ,body: $params');
    List<String> cookies = User().cookies ?? [];
    Options options = Options(headers: {'Cookie': cookies});
    Response response;
    try {
      response = await _dio.get(url, queryParameters: params, options: options);
      if (response.statusCode == HttpStatus.ok) {
        print('get请求成功-->response data：${response.data}');
        return BaseEntity(
            HttpCode.SUCCESS, '', BaseData.fromJson(response.data));
      } else {
        print('get请求失败-->response：${response.statusCode}');
        return BaseEntity(HttpCode.FAIL, response.statusCode.toString(), null);
      }
    } catch (e) {
      print('get请求发生错误：$e');
      return BaseEntity(HttpCode.FAIL, e.toString(), null);
    }
  }

  ///post请求，请求数据要用form表单形式，否则请求失败
  ///异步请求，用Future处理返回数据
  Future<BaseEntity> post(url, params) async {
    print('post请求-->url：$url ,body: $params');
    Response response;
    try {
      response = await _dio.post(
        url,
        data: FormData.fromMap(params),
      );
      if (response.statusCode == HttpStatus.ok) {
        print('post请求成功-->response data：${response.data}');
        return BaseEntity(
            HttpCode.SUCCESS, '', BaseData.fromJson(response.data));
      } else {
        print('post请求失败-->response：${response.statusCode}');
        return BaseEntity(HttpCode.FAIL, response.statusCode.toString(), null);
      }
    } catch (e) {
      print('post请求失败：${e.toString()}');
      return BaseEntity(HttpCode.FAIL, e.toString(), null);
    }
  }

  ///post请求，带cookie的，与用户相关的请求
  Future<BaseEntity> postWithCookie(url, params) async {
    print('post请求-->url：$url ,body: $params');
    List<String> cookies = User().cookies ?? [];
    Options options = Options(headers: {'Cookie': cookies});
    Response response;
    try {
      response = await _dio.post(url,
          data: FormData.fromMap(params), options: options);
      if (response.statusCode == HttpStatus.ok) {
        print('post请求成功-->response data：${response.data}');
        return BaseEntity(
            HttpCode.SUCCESS, '', BaseData.fromJson(response.data));
      } else {
        print('post请求失败-->response：${response.statusCode}');
        return BaseEntity(HttpCode.FAIL, response.statusCode.toString(), null);
      }
    } catch (e) {
      print('post请求失败：${e.toString()}');
      return BaseEntity(HttpCode.FAIL, e.toString(), null);
    }
  }

  ///登录请求，需要保存cookie
  Future<BaseEntity> login(url, params) async {
    print('post请求-->url：$url ,body: $params');
    Response response;
    try {
      response = await _dio.post(
        url,
        data: FormData.fromMap(params),
      );
      if (response.statusCode == HttpStatus.ok) {
        print('post请求成功-->response data：${response.data}');
        User().saveCookies(response.headers['set-cookie'] ?? []);
        return BaseEntity(
            HttpCode.SUCCESS, '', BaseData.fromJson(response.data));
      } else {
        print('post请求失败-->response：${response.statusCode}');
        return BaseEntity(HttpCode.FAIL, response.statusCode.toString(), null);
      }
    } catch (e) {
      print('post请求失败：${e.toString()}');
      return BaseEntity(HttpCode.FAIL, e.toString(), null);
    }
  }
}
