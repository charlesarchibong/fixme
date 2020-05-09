import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  File _profilePicture;
  List<File> _images = List();
  List<File> get images => _images;
  File get profilePicture => _profilePicture;

  Future<void> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _profilePicture = image;
    notifyListeners();
  }

  Future<void> getServiceImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _images.add(image);
    notifyListeners();
  }

  Future<void> removeImage(int index) async {
    _images.removeAt(index);
    notifyListeners();
  }

  Future<void> addSubCategory(String subCategory) {
    print(subCategory);
  }
}
