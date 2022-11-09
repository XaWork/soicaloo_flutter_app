// class SearchUserModel {
//   String? id;
//   String? fullname;
//   String? username;
//   String? email;
//   String? mobileNumber;
//   String? salt;
//   String? password;
//   String? loginType;
//   String? googleId;
//   String? profilePic;
//   String? coverPic;
//   String? age;
//   String? gender;
//   String? country;
//   String? state;
//   String? city;
//   String? bio;
//   String? interestsId;
//   String? deviceToken;
//   String? status;
//   String? otp;
//   String? createDate;
//
//   SearchUserModel(
//       {this.id,
//       this.fullname,
//       this.username,
//       this.email,
//       this.mobileNumber,
//       this.salt,
//       this.password,
//       this.loginType,
//       this.googleId,
//       this.profilePic,
//       this.coverPic,
//       this.age,
//       this.gender,
//       this.country,
//       this.state,
//       this.city,
//       this.bio,
//       this.interestsId,
//       this.deviceToken,
//       this.status,
//       this.otp,
//       this.createDate});
//
//   SearchUserModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'] ?? '';
//     fullname = json['fullname'] ?? '';
//     username = json['username'] ?? '';
//     email = json['email'] ?? '';
//     mobileNumber = json['mobile_number'] ?? '';
//     salt = json['salt'] ?? '';
//     password = json['password'] ?? '';
//     loginType = json['login_type'] ?? '';
//     googleId = json['google_id'] ?? '';
//     profilePic = json['profile_pic'] ?? '';
//     coverPic = json['cover_pic'] ?? '';
//     age = json['age'] ?? '';
//     gender = json['gender'] ?? '';
//     country = json['country'] ?? '';
//     state = json['state'] ?? '';
//     city = json['city'] ?? '';
//     bio = json['bio'] ?? '';
//     interestsId = json['interests_id'] ?? '';
//     deviceToken = json['device_token'] ?? '';
//     status = json['status'] ?? '';
//     otp = json['otp'] ?? '';
//     createDate = json['create_date'] ?? '';
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['fullname'] = this.fullname;
//     data['username'] = this.username;
//     data['email'] = this.email;
//     data['mobile_number'] = this.mobileNumber;
//     data['salt'] = this.salt;
//     data['password'] = this.password;
//     data['login_type'] = this.loginType;
//     data['google_id'] = this.googleId;
//     data['profile_pic'] = this.profilePic;
//     data['cover_pic'] = this.coverPic;
//     data['age'] = this.age;
//     data['gender'] = this.gender;
//     data['country'] = this.country;
//     data['state'] = this.state;
//     data['city'] = this.city;
//     data['bio'] = this.bio;
//     data['interests_id'] = this.interestsId;
//     data['device_token'] = this.deviceToken;
//     data['status'] = this.status;
//     data['otp'] = this.otp;
//     data['create_date'] = this.createDate;
//     return data;
//   }
// }
