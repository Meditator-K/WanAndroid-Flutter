class BaseEntity {
  BaseData? data;
  int? code;
  String? msg;

  BaseEntity(this.code, this.msg, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    data = json['_data'] != null ? new BaseData.fromJson(json['_data']) : null;
    code = json['_code'];
    msg = json['_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['_data'] = this.data?.toJson();
    }
    data['_code'] = this.code;
    data['_msg'] = this.msg;
    return data;
  }
}

class BaseData {
  dynamic data;
  int? errorCode;
  String? errorMsg;

  BaseData({this.data, this.errorCode, this.errorMsg});

  BaseData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? json['data'] : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }


}
