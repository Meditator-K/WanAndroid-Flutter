class TreeEntity {
  int visible;
  List<Treechild> children;
  String name;
  bool userControlSetTop;
  int id;
  int courseId;
  int parentChapterId;
  int order;

  TreeEntity(
      {this.visible,
      this.children,
      this.name,
      this.userControlSetTop,
      this.id,
      this.courseId,
      this.parentChapterId,
      this.order});

  TreeEntity.fromJson(Map<String, dynamic> json) {
    visible = json['visible'];
    if (json['children'] != null) {
      children = new List<Treechild>();
      (json['children'] as List).forEach((v) {
        children.add(new Treechild.fromJson(v));
      });
    }
    name = json['name'];
    userControlSetTop = json['userControlSetTop'];
    id = json['id'];
    courseId = json['courseId'];
    parentChapterId = json['parentChapterId'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visible'] = this.visible;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['userControlSetTop'] = this.userControlSetTop;
    data['id'] = this.id;
    data['courseId'] = this.courseId;
    data['parentChapterId'] = this.parentChapterId;
    data['order'] = this.order;
    return data;
  }
}

class Treechild {
  int visible;
  List<Null> children;
  String name;
  bool userControlSetTop;
  int id;
  int courseId;
  int parentChapterId;
  int order;

  Treechild(
      {this.visible,
      this.children,
      this.name,
      this.userControlSetTop,
      this.id,
      this.courseId,
      this.parentChapterId,
      this.order});

  Treechild.fromJson(Map<String, dynamic> json) {
    visible = json['visible'];
    if (json['children'] != null) {
      children = new List<Null>();
    }
    name = json['name'];
    userControlSetTop = json['userControlSetTop'];
    id = json['id'];
    courseId = json['courseId'];
    parentChapterId = json['parentChapterId'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visible'] = this.visible;
    if (this.children != null) {
      data['children'] = [];
    }
    data['name'] = this.name;
    data['userControlSetTop'] = this.userControlSetTop;
    data['id'] = this.id;
    data['courseId'] = this.courseId;
    data['parentChapterId'] = this.parentChapterId;
    data['order'] = this.order;
    return data;
  }
}
