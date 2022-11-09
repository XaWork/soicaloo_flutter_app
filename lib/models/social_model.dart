class SocialModel {
  String? responseCode;
  String? message;
  GolbalUser? user;
  String? status;

  SocialModel({this.responseCode, this.message, this.user, this.status});

  SocialModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    user = json['user'] != null ? new GolbalUser.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class GolbalUser {
  String? id;
  String? fullname;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? loginType;
  String? googleId;
  String? profilePic;
  String? coverPic;
  String? age;
  String? gender;
  String? country;
  String? state;
  String? city;
  String? bio;
  String? deviceToken;
  String? createDate;

  GolbalUser(
      {this.id,
      this.fullname,
      this.username,
      this.email,
      this.phone,
      this.password,
      this.loginType,
      this.googleId,
      this.profilePic,
      this.coverPic,
      this.age,
      this.gender,
      this.country,
      this.state,
      this.city,
      this.bio,
      this.deviceToken,
      this.createDate});

  GolbalUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    loginType = json['login_type'];
    googleId = json['google_id'];
    profilePic = json['profile_pic'];
    coverPic = json['cover_pic'];
    age = json['age'];
    gender = json['gender'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    bio = json['bio'];
    deviceToken = json['device_token'];
    createDate = json['create_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['login_type'] = this.loginType;
    data['google_id'] = this.googleId;
    data['profile_pic'] = this.profilePic;
    data['cover_pic'] = this.coverPic;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['bio'] = this.bio;
    data['device_token'] = this.deviceToken;
    data['create_date'] = this.createDate;
    return data;
  }
}
