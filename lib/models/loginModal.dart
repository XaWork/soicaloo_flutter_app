class LoginModal {
  String? responseCode;
  String? message;
  String? status;
  User? user;
  String? userToken;

  LoginModal(
      {this.responseCode,
      this.message,
      this.status,
      this.user,
      this.userToken});

  LoginModal.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userToken = json['user_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['user_token'] = this.userToken;
    return data;
  }
}

class User {
  String? id;
  String? fullname;
  String? username;
  String? email;
  String? phone;
  String? salt;
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
  List<String>? interestsId;
  String? deviceToken;
  String? createDate;

  User(
      {this.id,
      this.fullname,
      this.username,
      this.email,
      this.phone,
      this.salt,
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
      this.interestsId,
      this.deviceToken,
      this.createDate});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    salt = json['salt'];
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
    interestsId = json['interests_id'].cast<String>();
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
    data['salt'] = this.salt;
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
    data['interests_id'] = this.interestsId;
    data['device_token'] = this.deviceToken;
    data['create_date'] = this.createDate;
    return data;
  }
}
