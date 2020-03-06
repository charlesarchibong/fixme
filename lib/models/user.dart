class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String address;
  String password;

  User.name(
      {this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.address,
      this.password});

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['phoneNumber'] = phoneNumber;
    map['email'] = email;
    map['password'] = password;
    map['address'] = address;
    return map;
  }

  User.fromjson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    address = json['address'];
  }
}
