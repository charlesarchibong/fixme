import 'package:quickfix/util/const.dart';

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
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['phoneNumber'] = phoneNumber;
    map['email'] = email;
    map['serviceArea'] = serviceArea;
    map['fullNumber'] = fullNumber;
    map['service_id'] = serviceId;
    map['imageUrl'] = imageUrl;
    map['bank_account_number'] = accountNumber;
    map['profilePicture'] = profilePicture;
    map['profile_views'] = profileViews;
    map['reviews'] = reviews;
    map['user_rating'] = userRating;
    map['status'] = status;
    map['user_address'] = address;
    return map;
  }

  User.fromjson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    serviceArea = json['serviceArea'];
    fullNumber = json['fullNumber'];
    serviceId = json['service_id'];
    imageUrl = json['profile_pic_file_name'];
    accountNumber = json['bank_account_number'];
    profilePicture = Constants.uploadUrl + json['profile_pic_file_name'];
    profileViews = json['profile_views'];
    reviews = json['reviews'];
    userRating = json['user_rating'];
    address = json['user_address'];
    status = json['status'];
  }
}
