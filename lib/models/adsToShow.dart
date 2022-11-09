class AdsToShow {
  String? adId;
  String? location;
  String? locationNames;
  String? startDate;
  String? days;
  String? price;
  String? text;
  String? mobileNumber;
  String? redirectLink;
  String? image;
  String? status;
  String? paymentStatus;
  String? paymentId;
  String? orderId;
  String? addedBy;
  String? userId;
  String? createdAt;
  String? updatedAt;

  AdsToShow(
      {this.adId,
      this.location,
      this.locationNames,
      this.startDate,
      this.days,
      this.price,
      this.text,
      this.mobileNumber,
      this.image,
      this.status,
      this.paymentStatus,
      this.paymentId,
      this.orderId,
      this.addedBy,
      this.userId,
      this.createdAt,
      this.updatedAt});

  AdsToShow.fromJson(Map<String, dynamic> json) {
    adId = json['ad_id'] ?? '';
    location = json['location'] ?? '';
    locationNames = json['location_names'] ?? '';
    startDate = json['start_date'] ?? '';
    days = json['days'] ?? '';
    price = json['price'] ?? '';
    text = json['text'] ?? '';
    mobileNumber = json['mobile_number'] ?? '';
    image = json['image'] ?? '';
    status = json['status'] ?? '';
    paymentStatus = json['payment_status'] ?? '';
    paymentId = json['payment_id'] ?? '';
    orderId = json['order_id'] ?? '';
    addedBy = json['added_by'] ?? '';
    userId = json['user_id'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ad_id'] = this.adId;
    data['location'] = this.location;
    data['location_names'] = this.locationNames;
    data['start_date'] = this.startDate;
    data['days'] = this.days;
    data['price'] = this.price;
    data['text'] = this.text;
    data['mobile_number'] = this.mobileNumber;
    data['image'] = this.image;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['payment_id'] = this.paymentId;
    data['order_id'] = this.orderId;
    data['added_by'] = this.addedBy;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class AdsLocationModel {
  String? id;
  String? location;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;

  AdsLocationModel(
      {this.id,
      this.location,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt});

  AdsLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    location = json['location'] ?? '';
    price = json['price'] ?? '';
    status = json['status'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
