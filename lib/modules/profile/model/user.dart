class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String serviceArea;
  String accountNumber;
  String fullNumber;
  int serviceId;
  String imageUrl;
  String profilePicture;
  int profileViews;
  int reviews;
  int userRating;
  String status;
  String bio;
  String address;

  User.name({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.profilePicture,
    this.accountNumber,
    this.fullNumber,
    this.imageUrl,
    this.address,
    this.reviews,
    this.userRating,
    this.serviceArea,
    this.serviceId,
    this.bio,
    this.status,
    this.profileViews,
  });

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map['user_first_name'] = firstName;
    map['user_last_name'] = lastName;
    map['user_mobile'] = phoneNumber;
    map['email'] = email;
    map['service_area'] = serviceArea;
    map['full_number'] = fullNumber;
    map['service_id'] = serviceId;
    map['profile_pic_file_name'] = imageUrl;
    map['bank_account_number'] = accountNumber;
    map['profile_pic_file_name'] = profilePicture;
    map['profile_views'] = profileViews;
    map['reviews'] = reviews;
    map['user_rating'] = userRating;
    map['status'] = status;
    map['user_address'] = address;
    return map;
  }

  User.fromjson(Map<String, dynamic> json) {
    firstName = json['user_first_name'];
    lastName = json['user_last_name'];
    phoneNumber = json['user_mobile'];
    email = json['email'];
    serviceArea = json['service_area'];
    fullNumber = json['full_number'];
    serviceId = json['service_id'];
    imageUrl = json['profile_pic_file_name'];
    accountNumber = json['bank_account_number'];
    profilePicture = json['profile_pic_file_name'];
    profilePicture = json['profile_views'];
    reviews = json['reviews'];
    userRating = json['user_rating'];
    address = json['user_address'];
    status = json['status'];
  }
}
