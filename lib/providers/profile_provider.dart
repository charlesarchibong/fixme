import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickfix/models/service_image.dart';
import 'package:quickfix/models/user.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

class ProfileProvider extends ChangeNotifier {
  String _profilePicture;
  List<String> _images = List();
  List<String> get images => _images;
  String get profilePicture => _profilePicture;
  bool loading = false;
  String _subService;
  String get subService => _subService;

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
    var uploaded = await uploadImageToServer('profilePicture', image);
    String uploadUrl = 'https://uploads.quickfixnaija.com/thumbnails/';
    _profilePicture = uploadUrl + uploaded['imageFileName'] ?? null;
    Utils.setProfilePicture(_profilePicture);
    notifyListeners();
  }

  Future<String> getSubService() async {
    String subService = await Utils.getSubService();
    _subService = subService;
    notifyListeners();
    return subService;
  }

  Future<String> getSubServiceFromServer() async {
    try {
      final user = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Map<String, String> headers = {'Bearer': '$apiKey'};
      Map<String, String> body = {'mobile': user.phoneNumber};
      String url = Constants.baseUrl + Constants.userInfo;
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.FORM_DATA,
      );
      List list = response.data['subServices'] as List;
      String subServices = arrayToString(list);
      Utils.setSubService(subServices);
    } catch (e) {
      print(e);
    }
  }

  String arrayToString(List list) {
    String string = '';
    List<String> stringList = List();
    list.forEach((element) {
      String e = element['subservice'];
      stringList.add(e);
    });
    return stringList.toString();
  }

  Future<String> myProfilePicture() async {
    String image = await Utils.getProfilePicture();
    _profilePicture = image;
    notifyListeners();
    return image;
  }

  Future<void> getServiceImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var uploaded = await uploadImageToServer('servicePicture', image);
    String uploadUrl = 'https://uploads.quickfixnaija.com/thumbnails/';
    String imageUrl = uploadUrl + uploaded['imageFileName'] ?? null;
    image != null ? _images.add(imageUrl) : print('no file seleected');
    notifyListeners();
  }

  //Codes to get images from server and display dem on the profile screen
  Future<List<String>> getServiceImagesFromServer() async {
    try {
      final user = await Utils.getUserSession();
      final String apiKey = await Utils.getApiKey();
      String url = Constants.serviceImageUrl;
      Map<String, String> headers = {'Bearer': '$apiKey'};
      Map<String, String> body = {'mobile': user.phoneNumber};
      final response = await NetworkService().post(
          url: url,
          body: body,
          contentType: ContentType.URL_ENCODED,
          headers: headers);
      if (response.statusCode == 200) {
        List images = response.data['servicesPictures'] as List;
        List<ServiceImage> servicesImages =
            images.map((map) => ServiceImage().fromMap(map));
      } else {
        print('No response');
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(e.toString());
    }
  }

  Future<void> removeImage(int index) async {
    _images.removeAt(index);
    notifyListeners();
  }

  Future<Map> uploadImageToServer(String uploadType, File file) async {
    try {
      final user = await Utils.getUserSession();
      String fileName = file.path.split('/').last;
      String apiKey = await Utils.getApiKey();
      String url = 'https://uploads.quickfixnaija.com/uploads-processing';
      Map<String, String> headers = {'Bearer': '$apiKey'};
      FormData formData = FormData.fromMap({
        "mobile": user.phoneNumber,
        "uploadType": uploadType,
        "firstName": user.firstName,
        "file": await MultipartFile.fromFile(file.path, filename: fileName)
      });
      final response = await NetworkService().post(
        url: url,
        body: formData,
        contentType: ContentType.FORM_DATA,
        headers: headers,
      );
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<void> addSubCategory(String subCategory) async {
    print(subCategory);
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = Constants.baseUrl + Constants.addSubService;
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
        'email': currentUser.email,
        'subservice': subCategory
      };
      Map<String, String> headers = {'Bearer': '$apiKey'};
      print(headers);

      Response response = await NetworkService().post(
          url: url,
          body: {},
          queryParam: body,
          headers: headers,
          contentType: ContentType.JSON);
      getSubServiceFromServer();
    } catch (e) {
      print(e);
      if (e is DioError) {
        throw new Exception(e.message);
      } else {
        throw e;
      }
    }
  }
}
