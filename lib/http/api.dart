class API {
  static const BASE_URL = 'https://www.wanandroid.com';

  static const LOGIN_URL = '/user/login';
  static const REGISTER_URL = '/user/register';
  static const BANNER_URL = '/banner/json';
  static const COLLECT_URL = '/lg/collect/add/json';
  static const TREE_URL = '/tree/json';
  static const NAVI_URL = '/navi/json';
  static const PROJECT_URL = '/project/tree/json';
  static const HOTKEY_URL = '/hotkey/json';
  static const ADD_TODO_URL = '/lg/todo/add/json';

  static String getArticleListUrl(int page) {
    return '/article/list/$page/json';
  }

  static String getCollectListUrl(int page) {
    return '/lg/collect/list/$page/json';
  }

  static String getCollectUrl(int id) {
    return '/lg/collect/$id/json';
  }

  static String getUnCollectUrl(int id) {
    return '/lg/uncollect_originId/$id/json';
  }

  static String getProjectListUrl(int page) {
    return '/project/list/$page/json';
  }

  static String getSearchUrl(int page) {
    return '/article/query/$page/json';
  }

  static String getToDoListUrl(int page) {
    return '/lg/todo/v2/list/$page/json';
  }

  static String changeToDoStatusUrl(int id) {
    return '/lg/todo/done/$id/json';
  }

  static String deleteToDoUrl(int id) {
    return '/lg/todo/delete/$id/json';
  }

  static String updateToDoUrl(int id) {
    return '/lg/todo/update/$id/json';
  }
}
