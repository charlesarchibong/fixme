import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/profile/model/bank_code.dart';
import 'package:quickfix/modules/profile/model/service_image.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

class ProfileProvider extends ChangeNotifier {
  String _profilePicture;
  List<ServiceImage> _images = List();
  List<ServiceImage> get images => _images;
  String get profilePicture => _profilePicture;
  bool loading = false;
  String _subService;
  String get subService => _subService;
  List<Map> bankCodes = List();

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
    String subService = await getSubServiceFromServer();
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
      return subServices;
    } catch (e) {
      print(e);
      return '';
    }
  }

  String arrayToString(List list) {
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
    // getServiceImagesFromServer();
    notifyListeners();
  }

  //Codes to get images from server and display dem on the profile screen
  Future<Either<Failure, List<ServiceImage>>>
      getServiceImagesFromServer() async {
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
        headers: headers,
      );
      print(response.data);
      if (response.statusCode == 200) {
        List images = response.data['servicesPictures'] as List;
        List<ServiceImage> servicesImages =
            images.map((map) => ServiceImage().fromMap(map));
        if (servicesImages.length <= 0) {
          return Left(Failure(message: 'No images found'));
        } else {
          return Right(servicesImages);
        }
      } else {
        return Left(Failure(message: 'No images found'));
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
        return Left(Failure(message: 'No images found'));
      }
      print(e.toString());
      return Left(Failure(message: 'No images found'));
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

  Future<Either<Failure, bool>> addSubCategory(String subCategory) async {
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
        contentType: ContentType.JSON,
      );
      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(
            Failure(message: 'Subservice was not added, please try again'));
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return Left(Failure(message: e.message));
      } else {
        return Left(Failure(message: e.toString()));
      }
    }
  }

  Future<Either<Failure, bool>> updateProfile(
      String firstName, String lastName) async {
    try {
      String url = 'http://manager.quickfixnaija.com.ng/e-f-n';
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
        'firstName': firstName,
        'lastName': lastName
      };
      Map<String, String> headers = {'Bearer': '$apiKey'};
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      print(response.data);

      if (response.data['reqRes'] == 'true') {
        return Right(true);
      } else {
        return Left(Failure(message: 'Your profile was not updated'));
      }
    } catch (e) {
      return Left(Failure(message: e.toString().split(':')[1]));
    }
  }

  Future<List> getBankCodes() async {
    String url = 'http://manager.quickfixnaija.com.ng/g-b-info';
    User currentUser = await Utils.getUserSession();
    String apiKey = await Utils.getApiKey();
    Map<String, String> body = {
      'mobile': currentUser.phoneNumber,
      'email': currentUser.email,
    };
    Map<String, String> headers = {'Bearer': '$apiKey'};
    final response = await NetworkService().post(
      url: url,
      body: body,
      contentType: ContentType.URL_ENCODED,
      headers: headers,
    );
    // print(response.data);
    List bankInfo = response.data['bankInfo'] as List;
    // print(bankInfo);
    return bankInfo;
  }

  Future<Either<Failure, bool>> updateBankDetails(
      BankCode bankCode, String accountNumber) async {
    try {
      String url = 'http://manager.quickfixnaija.com.ng/s-u-b-i';
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
        'bankCode': bankCode.code,
        'accountNumber': accountNumber,
      };
      Map<String, String> headers = {'Bearer': '$apiKey'};
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      print(response.data);
      if (response.data['reqRes'] == 'true') {
        return Right(true);
      } else {
        String message = response.data['message'] != null
            ? response.data['message']
            : 'Bank details was not updated, please try again';
        return Left(Failure(message: message));
      }
    } catch (e) {
      return Left(Failure(message: e.toString().split(':')[1]));
    }
  }
}
