class UserPost {
  String? postId;
  String? userId;
  String? text;
  String? image;
  String? video;
  String? videoThumbnail;
  String? pdf;
  String? pdfName;
  String? pdfSize;
  String? location;
  String? status;
  String? createDate;
  List<String>? allImage;
  String? username;
  String? profilePic;
  int? totalLikes;
  int? totalShared;
  int? totalComments;
  FoundData? foundData;
  String? isLikes;
  String? bookmark;
  String? postsReport;
  String? profileBlock;
  MissingData? missingData;
  DeadData? deadData;

  UserPost(
      {this.postId,
      this.userId,
      this.text,
      this.image,
      this.video,
      this.videoThumbnail,
      this.pdf,
      this.pdfName,
      this.pdfSize,
      this.location,
      this.status,
      this.createDate,
      this.allImage,
      this.username,
      this.profilePic,
      this.totalLikes,
      this.totalShared,
      this.totalComments,
      this.isLikes,
      this.bookmark,
      this.postsReport,
      this.profileBlock,
      this.missingData,
      this.foundData,
      this.deadData});

  UserPost.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    text = json['text'];
    image = json['image'];
    video = json['video'];
    videoThumbnail = json['video_thumbnail'];
    pdf = json['pdf'];
    pdfName = json['pdf_name'];
    pdfSize = json['pdf_size'];
    location = json['location'];
    status = json['status'];
    createDate = json['create_date'];
    allImage = json['all_image'].cast<String>();
    username = json['username'];
    profilePic = json['profile_pic'];
    totalLikes = json['total_likes'];
    totalShared = json['total_shared'];
    totalComments = json['total_comments'];
    isLikes = json['is_likes'];
    bookmark = json['bookmark'];
    postsReport = json['posts_report'];
    profileBlock = json['profile_block'];
    missingData = json['missing_data'] != null
        ? new MissingData.fromJson(json['missing_data'])
        : null;
    foundData = json['found_data'] != null
        ? new FoundData.fromJson(json['found_data'])
        : null;
    deadData = json['dead_data'] != null
        ? new DeadData.fromJson(json['dead_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['image'] = this.image;
    data['video'] = this.video;
    data['video_thumbnail'] = this.videoThumbnail;
    data['pdf'] = this.pdf;
    data['pdf_name'] = this.pdfName;
    data['pdf_size'] = this.pdfSize;
    data['location'] = this.location;
    data['status'] = this.status;
    data['create_date'] = this.createDate;
    data['all_image'] = this.allImage;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    data['total_likes'] = this.totalLikes;
    data['total_shared'] = this.totalShared;
    data['total_comments'] = this.totalComments;
    data['is_likes'] = this.isLikes;
    data['bookmark'] = this.bookmark;
    data['posts_report'] = this.postsReport;
    data['profile_block'] = this.profileBlock;
    if (this.missingData != null) {
      data['missing_data'] = this.missingData!.toJson();
    }
    if (this.foundData != null) {
      data['found_data'] = this.foundData!.toJson();
    }
    if (this.deadData != null) {
      data['dead_data'] = this.deadData!.toJson();
    }
    return data;
  }
}

class MissingData {
  String? id;
  String? postId;
  String? fullName;
  String? fatherName;
  String? gender;
  String? age;
  String? resendencePlace;
  String? nativePlace;
  String? dateMissing;
  String? placeMissing;
  String? state;
  String? district;
  String? pincode;
  String? bodyMark;
  String? remarks;
  String? foundStatus;
  String? firDdNumber;
  String? dateOfFir;
  String? policeStation;
  String? contactNumber;
  String? height;
  Null? complaintPerson;
  Null? complaintPersonNo;
  String? policeStationNo;
  String? policeStationLocation;
  String? policeIo;
  Null? locationLat;
  Null? locationLng;
  String? createdAt;
  String? updatedAt;

  MissingData(
      {this.id,
      this.postId,
      this.fullName,
      this.fatherName,
      this.gender,
      this.age,
      this.resendencePlace,
      this.nativePlace,
      this.dateMissing,
      this.placeMissing,
      this.state,
      this.district,
      this.pincode,
      this.bodyMark,
      this.remarks,
      this.foundStatus,
      this.firDdNumber,
      this.dateOfFir,
      this.policeStation,
      this.contactNumber,
      this.height,
      this.complaintPerson,
      this.complaintPersonNo,
      this.policeStationNo,
      this.policeStationLocation,
      this.policeIo,
      this.locationLat,
      this.locationLng,
      this.createdAt,
      this.updatedAt});

  MissingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    fullName = json['full_name'];
    fatherName = json['father_name'];
    gender = json['gender'];
    age = json['age'];
    resendencePlace = json['resendence_place'];
    nativePlace = json['native_place'];
    dateMissing = json['date_missing'];
    placeMissing = json['place_missing'];
    state = json['state'];
    district = json['district'];
    pincode = json['pincode'];
    bodyMark = json['body_mark'];
    remarks = json['remarks'];
    foundStatus = json['found_status'];
    firDdNumber = json['fir_dd_number'];
    dateOfFir = json['date_of_fir'];
    policeStation = json['police_station'];
    contactNumber = json['contact_number'];
    height = json['height'];
    complaintPerson = json['complaint_person'];
    complaintPersonNo = json['complaint_person_no'];
    policeStationNo = json['police_station_no'];
    policeStationLocation = json['police_station_location'];
    policeIo = json['police_io'];
    locationLat = json['location_lat'];
    locationLng = json['location_lng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['full_name'] = this.fullName;
    data['father_name'] = this.fatherName;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['resendence_place'] = this.resendencePlace;
    data['native_place'] = this.nativePlace;
    data['date_missing'] = this.dateMissing;
    data['place_missing'] = this.placeMissing;
    data['state'] = this.state;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    data['body_mark'] = this.bodyMark;
    data['remarks'] = this.remarks;
    data['found_status'] = this.foundStatus;
    data['fir_dd_number'] = this.firDdNumber;
    data['date_of_fir'] = this.dateOfFir;
    data['police_station'] = this.policeStation;
    data['contact_number'] = this.contactNumber;
    data['height'] = this.height;
    data['complaint_person'] = this.complaintPerson;
    data['complaint_person_no'] = this.complaintPersonNo;
    data['police_station_no'] = this.policeStationNo;
    data['police_station_location'] = this.policeStationLocation;
    data['police_io'] = this.policeIo;
    data['location_lat'] = this.locationLat;
    data['location_lng'] = this.locationLng;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class FoundData {
  String? id;
  String? fullName;
  String? fatherName;
  String? gender;
  String? age;
  String? residencePlace;
  String? nativePlace;
  String? date;
  String? place;
  String? height;
  String? ddFir;
  String? ddFirDate;
  String? policeIoName;
  String? policePhone;
  String? policeStation;
  String? contactNumber;
  String? photo;
  String? type;
  String? postId;
  String? ngoOrUsername;
  String? state;
  String? district;
  String? pincode;
  String? bodyMark;
  String? remarks;
  Null? locationLat;
  Null? locationLng;
  String? createdAt;
  String? updatedAt;

  FoundData(
      {this.id,
      this.fullName,
      this.fatherName,
      this.gender,
      this.age,
      this.residencePlace,
      this.nativePlace,
      this.date,
      this.place,
      this.height,
      this.ddFir,
      this.ddFirDate,
      this.policeIoName,
      this.policePhone,
      this.policeStation,
      this.contactNumber,
      this.photo,
      this.type,
      this.postId,
      this.ngoOrUsername,
      this.state,
      this.district,
      this.pincode,
      this.bodyMark,
      this.remarks,
      this.locationLat,
      this.locationLng,
      this.createdAt,
      this.updatedAt});

  FoundData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    fatherName = json['father_name'];
    gender = json['gender'];
    age = json['age'];
    residencePlace = json['residence_place'];
    nativePlace = json['native_place'];
    date = json['date'];
    place = json['place'];
    height = json['height'];
    ddFir = json['dd_fir'];
    ddFirDate = json['dd_fir_date'];
    policeIoName = json['police_io_name'];
    policePhone = json['police_phone'];
    policeStation = json['police_station'];
    contactNumber = json['contact_number'];
    photo = json['photo'];
    type = json['type'];
    postId = json['post_id'];
    ngoOrUsername = json['ngo_or_username'];
    state = json['state'];
    district = json['district'];
    pincode = json['pincode'];
    bodyMark = json['body_mark'];
    remarks = json['remarks'];
    locationLat = json['location_lat'];
    locationLng = json['location_lng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['father_name'] = this.fatherName;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['residence_place'] = this.residencePlace;
    data['native_place'] = this.nativePlace;
    data['date'] = this.date;
    data['place'] = this.place;
    data['height'] = this.height;
    data['dd_fir'] = this.ddFir;
    data['dd_fir_date'] = this.ddFirDate;
    data['police_io_name'] = this.policeIoName;
    data['police_phone'] = this.policePhone;
    data['police_station'] = this.policeStation;
    data['contact_number'] = this.contactNumber;
    data['photo'] = this.photo;
    data['type'] = this.type;
    data['post_id'] = this.postId;
    data['ngo_or_username'] = this.ngoOrUsername;
    data['state'] = this.state;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    data['body_mark'] = this.bodyMark;
    data['remarks'] = this.remarks;
    data['location_lat'] = this.locationLat;
    data['location_lng'] = this.locationLng;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class DeadData {
  String? id;
  String? postId;
  String? fullName;
  String? fatherName;
  String? gender;
  String? age;
  String? resendencePlace;
  String? nativePlace;
  String? dateFound;
  String? placeFound;
  String? state;
  String? district;
  String? pincode;
  String? bodyMark;
  String? remarks;
  Null? foundStatus;
  String? firDdNumber;
  String? dateOfFir;
  String? policeStation;
  String? contactNumber;
  String? height;
  Null? complaintPerson;
  Null? complaintPersonNo;
  String? policeStationNo;
  String? policeIo;
  Null? locationLat;
  Null? locationLng;
  String? createdAt;
  String? updatedAt;

  DeadData(
      {this.id,
      this.postId,
      this.fullName,
      this.fatherName,
      this.gender,
      this.age,
      this.resendencePlace,
      this.nativePlace,
      this.dateFound,
      this.placeFound,
      this.state,
      this.district,
      this.pincode,
      this.bodyMark,
      this.remarks,
      this.foundStatus,
      this.firDdNumber,
      this.dateOfFir,
      this.policeStation,
      this.contactNumber,
      this.height,
      this.complaintPerson,
      this.complaintPersonNo,
      this.policeStationNo,
      this.policeIo,
      this.locationLat,
      this.locationLng,
      this.createdAt,
      this.updatedAt});

  DeadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    fullName = json['full_name'];
    fatherName = json['father_name'];
    gender = json['gender'];
    age = json['age'];
    resendencePlace = json['resendence_place'];
    nativePlace = json['native_place'];
    dateFound = json['date_found'];
    placeFound = json['place_found'];
    state = json['state'];
    district = json['district'];
    pincode = json['pincode'];
    bodyMark = json['body_mark'];
    remarks = json['remarks'];
    foundStatus = json['found_status'];
    firDdNumber = json['fir_dd_number'];
    dateOfFir = json['date_of_fir'];
    policeStation = json['police_station'];
    contactNumber = json['contact_number'];
    height = json['height'];
    complaintPerson = json['complaint_person'];
    complaintPersonNo = json['complaint_person_no'];
    policeStationNo = json['police_station_no'];
    policeIo = json['police_io'];
    locationLat = json['location_lat'];
    locationLng = json['location_lng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['full_name'] = this.fullName;
    data['father_name'] = this.fatherName;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['resendence_place'] = this.resendencePlace;
    data['native_place'] = this.nativePlace;
    data['date_found'] = this.dateFound;
    data['place_found'] = this.placeFound;
    data['state'] = this.state;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    data['body_mark'] = this.bodyMark;
    data['remarks'] = this.remarks;
    data['found_status'] = this.foundStatus;
    data['fir_dd_number'] = this.firDdNumber;
    data['date_of_fir'] = this.dateOfFir;
    data['police_station'] = this.policeStation;
    data['contact_number'] = this.contactNumber;
    data['height'] = this.height;
    data['complaint_person'] = this.complaintPerson;
    data['complaint_person_no'] = this.complaintPersonNo;
    data['police_station_no'] = this.policeStationNo;
    data['police_io'] = this.policeIo;
    data['location_lat'] = this.locationLat;
    data['location_lng'] = this.locationLng;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
