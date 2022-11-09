class IntrestModel {
  String? responseCode;
  String? message;
  List<Interests>? interests;
  String? status;

  IntrestModel({this.responseCode, this.message, this.interests, this.status});

  IntrestModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['interests'] != null) {
      // ignore: deprecated_member_use
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(new Interests.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.interests != null) {
      data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Interests {
  String? id;
  String? type;
  String? createDate;

  Interests({this.id, this.type, this.createDate});

  Interests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['create_date'] = this.createDate;
    return data;
  }
}
