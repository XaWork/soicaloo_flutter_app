class FollowersModal {
  int? status;
  String? msg;
  List<Follower>? follower;

  FollowersModal({this.status, this.msg, this.follower});

  FollowersModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['follower'] != null) {
      // ignore: deprecated_member_use
      follower = <Follower>[];
      json['follower'].forEach((v) {
        follower!.add(new Follower.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.follower != null) {
      data['follower'] = this.follower!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Follower {
  String? followId;
  String? fromUser;
  String? toUser;
  String? date;
  String? status;
  String? username;
  String? profilePic;
  String? coverPic;
  String? country;
  String? followUserId;

  Follower(
      {this.followId,
      this.fromUser,
      this.toUser,
      this.date,
      this.status,
      this.username,
      this.profilePic,
      this.coverPic,
      this.country,
      this.followUserId});

  Follower.fromJson(Map<String, dynamic> json) {
    followId = json['follow_id'];
    fromUser = json['from_user'];
    toUser = json['to_user'];
    date = json['date'];
    status = json['status'];
    username = json['username'];
    profilePic = json['profile_pic'];
    coverPic = json['cover_pic'];
    country = json['country'];
    followUserId = json['follow_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['follow_id'] = this.followId;
    data['from_user'] = this.fromUser;
    data['to_user'] = this.toUser;
    data['date'] = this.date;
    data['status'] = this.status;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['cover_pic'] = this.coverPic;
    data['country'] = this.country;
    data['follow_user_id'] = this.followUserId;
    return data;
  }
}
