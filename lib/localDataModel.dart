///本地数据模型
class LocalData {
  String code;
  String name;
  bool checkFlag;
  List children;

  LocalData({this.code, this.name, this.checkFlag, this.children});

  LocalData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    checkFlag = json['checkFlag'];
    children = json['children'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['checkFlag'] = this.checkFlag;
    data['children'] = this.children;
    return data;
  }
}