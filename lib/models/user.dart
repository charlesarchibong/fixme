class User {
  String _firstname;
  String _lastname;
  String _phoneNumber;
  String _email;
  String _address;
  String _password;

  User.name(this._firstname, this._lastname, this._phoneNumber, this._email,
      this._password, this._address);

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['name'] = _firstname;
    map['phoneNumber'] = _phoneNumber;
    map['email'] = _email;
    map['password'] = _password;
    map['address'] = _address;
    return map;
  }

  User.fromjson(Map<String, dynamic> json) {
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _phoneNumber = json['phoneNumber'];
    _email = json['email'];
    _address = json['address'];
  }
}
