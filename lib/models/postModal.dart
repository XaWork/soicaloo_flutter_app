// ignore_for_file: non_constant_identifier_names

class PostModal {
  int? status;
  String? msg;
  List<Follower>? follower;

  PostModal({this.status, this.msg, this.follower});

  PostModal.fromJson(Map<String, dynamic> json) {
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
  String? postId;
  String? userId;
  String? text;
  String? pdf_name;
  String? pdf_size;
  String? image;
  String? video;
  String? pdf;
  String? location;
  String? createDate;
  List<String>? allImage;
  String? thumbnail;

  Follower(
      {this.postId,
      this.userId,
      this.text,
      this.image,
      this.video,
      this.pdf,
      this.pdf_name,
      this.pdf_size,
      this.location,
      this.createDate,
      this.allImage,
      this.thumbnail});

  Follower.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    text = json['text'];
    image = json['image'];
    video = json['video'];
    pdf = json['pdf'];
    pdf_name = json['pdf_name'];
    pdf_size = json['pdf_size'];
    location = json['location'];
    createDate = json['create_date'];
    allImage = json['all_image'].cast<String>();
    thumbnail = json['video_thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['video'] = this.video;
    data['pdf'] = this.pdf;
    data['pdf_name'] = this.pdf_name;
    data['pdf_size'] = this.pdf_size;
    data['location'] = this.location;
    data['create_date'] = this.createDate;
    data['all_image'] = this.allImage;
    data['video_thumbnail'] = this.thumbnail;
    return data;
  }
}
