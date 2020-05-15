import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickfix/models/user.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

class ProfileProvider extends ChangeNotifier {
  File _profilePicture;
  List<File> _images = List();
  List<File> get images => _images;
  File get profilePicture => _profilePicture;
  bool loading = false;

  void setNotLoading() {
    loading = false;
    notifyListeners();
  }

  void setLoading() {
    loading = true;
    notifyListeners();
  }

  Future<void> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _profilePicture = image ?? null;
    notifyListeners();
  }

  Future<void> uploadImage(File file, User user) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "ifo": await MultipartFile.fromFile(file.path, filename: fileName),
      'firstName': user.firstName,
      'mobile': user.phoneNumber,
      'uploadType': 'servicePictures',
    });

    String key = await Utils.getApiKey();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $key'
    };
    Response response = await NetworkService().upload(
        url: 'https://uploads.quickfixnaija.com/uploads-processing',
        body: formData,
        headers: headers,
        contentType: ContentType.URL_ENCODED);
  }

  Future<void> getServiceImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    image != null ? _images.add(image) : print('no file seleected');
    notifyListeners();
  }

  Future<void> removeImage(int index) async {
    _images.removeAt(index);
    notifyListeners();
  }

  Future<void> addSubCategory(String subCategory) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = Constants.baseUrl + Constants.addSubService;
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
        'email': currentUser.email,
        'subservice': subCategory
      };
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: 'Bearer $apiKey'
      };
      print(headers);
      Response response = await NetworkService().post(
          url: url,
          body: {},
          queryParam: body,
          headers: headers,
          contentType: ContentType.URL_ENCODED);
      print(response.data);
    } catch (e) {
      if (e is DioError) {
      } else {
        throw e;
      }
    }
  }
}
