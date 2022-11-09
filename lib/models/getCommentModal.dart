class GetCommentModal {
  int? status;
  String? message;
  List<Likes>? likes;

  GetCommentModal({this.status, this.message, this.likes});

  GetCommentModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['likes'] != null) {
      // ignore: deprecated_member_use
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(new Likes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Likes {
  String? commentId;
  String? userId;
  String? postId;
  String? text;
  String? date;
  String? username;
  String? profilePic;

  Likes(
      {this.commentId,
      this.userId,
      this.postId,
      this.text,
      this.date,
      this.username,
      this.profilePic});

  Likes.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    userId = json['user_id'];
    postId = json['post_id'];
    text = json['text'];
    date = json['date'];
    username = json['username'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['text'] = this.text;
    data['date'] = this.date;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
