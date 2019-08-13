import 'package:wan_android/entity/article_entity.dart';
import 'package:wan_android/entity/banner_entity.dart';
import 'package:wan_android/entity/collect_entity.dart';
import 'package:wan_android/entity/hotkey_entity.dart';
import 'package:wan_android/entity/navi_entity.dart';
import 'package:wan_android/entity/project_entity.dart';
import 'package:wan_android/entity/project_list_entity.dart';
import 'package:wan_android/entity/to_do_entity.dart';
import 'package:wan_android/entity/tree_entity.dart';
import 'package:wan_android/entity/user_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ArticleEntity") {
      return ArticleEntity.fromJson(json) as T;
    } else if (T.toString() == "BannerEntity") {
      return BannerEntity.fromJson(json) as T;
    } else if (T.toString() == "CollectEntity") {
      return CollectEntity.fromJson(json) as T;
    } else if (T.toString() == "HotkeyEntity") {
      return HotkeyEntity.fromJson(json) as T;
    } else if (T.toString() == "NaviEntity") {
      return NaviEntity.fromJson(json) as T;
    } else if (T.toString() == "ProjectEntity") {
      return ProjectEntity.fromJson(json) as T;
    } else if (T.toString() == "ProjectListEntity") {
      return ProjectListEntity.fromJson(json) as T;
    } else if (T.toString() == "ToDoEntity") {
      return ToDoEntity.fromJson(json) as T;
    } else if (T.toString() == "TreeEntity") {
      return TreeEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}