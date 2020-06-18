class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String serviceArea;
  String fullNumber;
  int serviceId;

  User.name({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.serviceArea,
    this.serviceId,
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
  }
}
