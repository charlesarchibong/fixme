import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickfix/modules/profile/model/user.dart';

class UsersService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection(
    'users',
  );
  final String userPhone;

  UsersService({this.userPhone});

  Future updateUserDate({
    @required User user,
    @required String imageUrl,
  }) async {
    Map<String, dynamic> userMap = {
      'phoneNumber': user.phoneNumber,
      'firstName': '${user.firstName}',
      'lastName': '${user.lastName}',
      'imageUrl': imageUrl,
      'mobile_device_token': user.firebaseToken,
    };
    return await _collectionReference.document(userPhone).setData(userMap);
  }

  Stream<User> get user {
    return _collectionReference
        .document(this.userPhone)
        .snapshots()
        .map(_getUserFromMap);
  }

  Stream<List<User>> get userList {
    return _collectionReference.snapshots().map(_getListUserFromMap);
  }

  User _getUserFromMap(DocumentSnapshot documentSnapshot) {
    return User.fromjson(documentSnapshot.data);
  }

  List<User> _getListUserFromMap(QuerySnapshot querySnapshot) {
    return querySnapshot.documents
        .map((user) => User.fromjson(user.data))
        .toList();
  }
}
