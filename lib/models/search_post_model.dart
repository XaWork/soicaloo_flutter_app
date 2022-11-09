class SearchPostModel {
  String? responseCode;
  String? message;
  List<Post>? post;
  String? status;

  SearchPostModel({this.responseCode, this.message, this.post, this.status});

  SearchPostModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['post'] != null) {
      // ignore: deprecated_member_use
      post = <Post>[];
      json['post'].forEach((v) {
        post!.add(new Post.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.post != null) {
      data['post'] = this.post!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Post {
  String? postId;
  String? userId;
  String? text;
  List<String>? image;
  String? video;
  String? location;
  String? createDate;
  List<String>? allImage;
  String? username;
  String? profilePic;
  int? totalLikes;
  int? totalComments;
  String? isLikes;
  String? bookmark;
  String? userBlok;
  String? postReport;
  Post(
      {this.postId,
      this.userId,
      this.text,
      this.image,
      this.video,
      this.location,
      this.createDate,
      this.allImage,
      this.username,
      this.profilePic,
      this.totalLikes,
      this.totalComments,
      this.isLikes,
      this.bookmark});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    text = json['text'];
    image = json['image'].cast<String>();
    video = json['video'];
    location = json['location'];
    createDate = json['create_date'];
    allImage = json['all_image'].cast<String>();
    username = json['username'];
    profilePic = json['profile_pic'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    isLikes = json['is_likes'];
    bookmark = json['bookmark'];
    postReport = json['posts_report'];
    userBlok = json['profile_block'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['video'] = this.video;
    data['location'] = this.location;
    data['create_date'] = this.createDate;
    data['all_image'] = this.allImage;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['total_likes'] = this.totalLikes;
    data['total_comments'] = this.totalComments;
    data['is_likes'] = this.isLikes;
    data['bookmark'] = this.bookmark;
    data['posts_report'] = this.postReport;
    data['profile_block'] = this.userBlok;
    return data;
  }
}
