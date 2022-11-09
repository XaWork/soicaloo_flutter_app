class NotificationsModel {
  String? responseCode;
  String? message;
  String? status;
  List<Data>? data;

  NotificationsModel({this.responseCode, this.message, this.status, this.data});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? notId;
  String? fromUser;
  String? toUser;
  String? postId;
  String? title;
  String? message;
  String? readStatus;
  String? date;
  String? username;
  String? profilePic;

  Data(
      {this.notId,
      this.fromUser,
      this.toUser,
      this.postId,
      this.title,
      this.message,
      this.readStatus,
      this.date,
      this.username,
      this.profilePic});

  Data.fromJson(Map<String, dynamic> json) {
    notId = json['not_id'];
    fromUser = json['from_user'];
    toUser = json['to_user'];
    postId = json['post_id'];
    title = json['title'];
    message = json['message'];
    readStatus = json['read_status'];
    date = json['date'];
    username = json['username'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['not_id'] = this.notId;
    data['from_user'] = this.fromUser;
    data['to_user'] = this.toUser;
    data['post_id'] = this.postId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['read_status'] = this.readStatus;
    data['date'] = this.date;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
