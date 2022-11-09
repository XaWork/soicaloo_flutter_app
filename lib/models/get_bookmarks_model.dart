// ignore_for_file: non_constant_identifier_names

class GetBookMarksModel {
  String? responseCode;
  String? message;
  List<Post>? post;
  String? status;

  GetBookMarksModel({this.responseCode, this.message, this.post, this.status});

  GetBookMarksModel.fromJson(Map<String, dynamic> json) {
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
  String? text;
  List<String>? image;
  String? video;
  String? pdf;
  String? pdf_name;
  String? pdf_size;
  String? location;
  String? postUserId;
  String? createDate;
  List<String>? allImage;
  String? username;
  String? profilePic;
  int? totalLikes;
  int? totalComments;
  String? isLikes;
  String? bookmark;
  bool? dataV;

  Post(
      {this.postId,
      this.text,
      this.image,
      this.video,
      this.pdf,
      this.pdf_name,
      this.pdf_size,
      this.location,
      this.postUserId,
      this.createDate,
      this.allImage,
      this.username,
      this.profilePic,
      this.totalLikes,
      this.totalComments,
      this.isLikes,
      this.bookmark,
      this.dataV});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    text = json['text'];
    image = json['image'].cast<String>();
    video = json['video'];
    pdf = json['pdf'];
    pdf_name = json['pdf_name'];
    pdf_size = json['pdf_size'];
    location = json['location'];
    postUserId = json['post_user_id'];
    createDate = json['create_date'];
    allImage = json['all_image'].cast<String>();
    username = json['username'];
    profilePic = json['profile_pic'];
    totalLikes = json['total_likes'];
    totalComments = json['total_comments'];
    isLikes = json['is_likes'];
    bookmark = json['bookmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['video'] = this.video;
    data['pdf'] = this.pdf;
    data['pdf_name'] = this.pdf_name;
    data['pdf_size'] = this.pdf_size;
    data['location'] = this.location;
    data['post_user_id'] = this.postUserId;
    data['create_date'] = this.createDate;
    data['all_image'] = this.allImage;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['total_likes'] = this.totalLikes;
    data['total_comments'] = this.totalComments;
    data['is_likes'] = this.isLikes;
    data['bookmark'] = this.bookmark;
    return data;
  }
}
