class GetStoryModal {
  String? status;
  String? msg;
  List<Post>? post;

  GetStoryModal({this.status, this.msg, this.post});

  GetStoryModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['post'] != null) {
      // ignore: deprecated_member_use
      post = <Post>[];
      json['post'].forEach((v) {
        post!.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.post != null) {
      data['post'] = this.post!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Post {
  String? storyId;
  String? userId;
  String? url;
  String? type;
  String? createDate;
  String? username;
  String? profilePic;
  List<StoryImage>? storyImage;

  Post(
      {this.storyId,
      this.userId,
      this.url,
      this.type,
      this.createDate,
      this.username,
      this.profilePic,
      this.storyImage});

  Post.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'];
    userId = json['user_id'];
    url = json['url'];
    type = json['type'];
    createDate = json['create_date'];
    username = json['username'];
    profilePic = json['profile_pic'];
    if (json['story_image'] != null) {
      // ignore: deprecated_member_use
      storyImage = <StoryImage>[];
      json['story_image'].forEach((v) {
        storyImage!.add(new StoryImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['story_id'] = this.storyId;
    data['user_id'] = this.userId;
    data['url'] = this.url;
    data['type'] = this.type;
    data['create_date'] = this.createDate;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    if (this.storyImage != null) {
      data['story_image'] = this.storyImage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoryImage {
  String? url;
  String? type;

  StoryImage({this.url, this.type});

  StoryImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}
