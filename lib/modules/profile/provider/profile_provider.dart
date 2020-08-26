import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/helpers/custom_lodder.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/profile/model/bank_code.dart';
import 'package:quickfix/modules/profile/model/bank_information.dart';
import 'package:quickfix/modules/profile/model/service_image.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/firebase/users.dart';
import 'package:quickfix/services/network/network_service.dart';
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
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(source: ImageSource.gallery);
    var uploaded = await uploadImageToServer(
      'profilePicture',
      File(
        image.path,
      ),
    );
    String uploadUrl = 'https://uploads.fixme.ng/thumbnails/';
    _profilePicture = uploadUrl + uploaded['imageFileName'] ?? null;
    User user = await Utils.getUserSession();
    Map userMap = user.toJson();
    userMap['profilePicture'] = _profilePicture;
    Utils.setUserSession(jsonEncode(User.fromjson(userMap)));
    Utils.setProfilePicture(_profilePicture);
    await UsersService(userPhone: user.phoneNumber).updateUserDate(
      user: User.fromjson(userMap),
      imageUrl: _profilePicture,
    );
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
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
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
    String subService = '';
    list.forEach((element) {
      String e = element['subservice'];
      subService += '$e, ';
    });
    return subService;
  }

  Future<String> myProfilePicture() async {
    String image = await Utils.getProfilePicture();
    _profilePicture = image;
    notifyListeners();
    return image;
  }

  Future<void> getServiceImage() async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(source: ImageSource.gallery);
    await uploadImageToServer(
      'servicePicture',
      File(
        image.path,
      ),
    );
    getServiceImagesFromServer();
    notifyListeners();
  }

  //Codes to get images from server and display dem on the profile screen
  Future getServiceImagesFromServer() async {
    try {
      final user = await Utils.getUserSession();
      final String apiKey = await Utils.getApiKey();
      String url = Constants.serviceImageUrl;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, String> body = {'mobile': user.phoneNumber};
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.statusCode == 200) {
        List images = response.data['servicePictures'] as List;

        List<ServiceImage> servicesImages = List();
        for (var i = 0; i < images.length; i++) {
          ServiceImage image = ServiceImage().fromMap(images[i]);

          servicesImages.add(image);
        }

        _images = servicesImages;
        notifyListeners();
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(
        e.toString(),
      );
    }
  }

  Future<void> removeImage(String imageName) async {
    try {
      final user = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();

      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      String url = 'https://manager.fixme.ng/del-svc-img';

      Map<String, String> body = {
        'mobile': user.phoneNumber,
        "imageFileName": imageName,
      };
      print(body);
      var response = await NetworkService().post(
        url: url,
        queryParam: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      print(response);
      await getServiceImagesFromServer();
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(
        e.toString(),
      );
    }
    // _images.removeAt(index);
  }

  Future<Map> uploadImageToServer(String uploadType, File file) async {
    try {
      final user = await Utils.getUserSession();
      String fileName = file.path.split('/').last;
      String apiKey = await Utils.getApiKey();
      String url = 'https://uploads.fixme.ng/uploads-processing';
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      // print(headers);
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
      print(response);
      return response.data;
    } catch (e) {
      if (e is DioError) {
        print("error here");
        // CustomLogger(className: 'ProfileProvider').errorPrint(e.response.data);
        debugPrint(e.response.data);
      }
      print(e);
      return null;
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
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      print(headers);

      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );

      print("heeeeee how many times are you running");
      if (response.statusCode == 200) {
        return Right(true);
      } else {
        return Left(
          Failure(
            message: 'Subservice was not added, please try again',
          ),
        );
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        return Left(
          Failure(
            message: e.message,
          ),
        );
      } else {
        return Left(
          Failure(
            message: e.toString(),
          ),
        );
      }
    }
  }

  //************************ */get user profile *********************************
  Future userProfile() async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      String url = 'https://manager.fixme.ng/user-info';
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      User user = User.fromjson(response.data);
      Utils.setUserSession(json.encode(user));
      notifyListeners();
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(
        e.toString(),
      );
    }
  }
  //*********************  changeeee service *****************************************

  Future changeServices({@required id}) async {
    try {
      User currentUser = await Utils.getUserSession();
      String url = 'https://manager.fixme.ng/change-service';
      String apiKey = await Utils.getApiKey();
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        'user_id': currentUser.id,
        'service_id': id,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );

      print(response);

      userProfile();
      notifyListeners();
      return response;
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      print(
        e.toString(),
      );
    }
  }

  Future<Either<Failure, bool>> updateProfile(
      String firstName, String lastName) async {
    try {
      String url = 'http://manager.fixme.ng/e-f-n';
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
        'firstName': firstName,
        'lastName': lastName
      };
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      print(response.data);

      if (response.data['reqRes'] == 'true') {
        Map userMap = currentUser.toJson();
        userMap['firstName'] = firstName;
        userMap['lastName'] = lastName;
        Utils.setUserSession(jsonEncode(User.fromjson(userMap)));
        await UsersService(userPhone: currentUser.phoneNumber).updateUserDate(
          user: User.fromjson(userMap),
          imageUrl: currentUser.profilePicture,
        );
        return Right(true);
      } else {
        return Left(Failure(message: 'Your profile was not updated'));
      }
    } catch (e) {
      return Left(
        Failure(
          message: e.toString().split(':')[1],
        ),
      );
    }
  }

  Future<List> getBankCodes() async {
    String url = 'http://manager.fixme.ng/g-b-info';
    User currentUser = await Utils.getUserSession();
    String apiKey = await Utils.getApiKey();
    Map<String, String> body = {
      'mobile': currentUser.phoneNumber,
      'email': currentUser.email,
    };
    Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
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
      String url = 'http://manager.fixme.ng/s-u-b-i';
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
        'bankCode': bankCode.code,
        'accountNumber': accountNumber,
      };
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
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
      return Left(
        Failure(
          message: e.toString().split(':')[1],
        ),
      );
    }
  }

  Future<Either<Failure, bool>> updateProfileView(String mobile) async {
    try {
      // final user = await Utils.getUserSession();
      final String apiKey = await Utils.getApiKey();
      final User user = await Utils.getUserSession();
      String url = Constants.updateProfileView;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, String> body = {
        'viewed_user_mobile': mobile,
        'mobile': user.phoneNumber,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.statusCode == 200) {
        return Right(response.data['reqRes'] == 'true');
      } else {
        return Left(Failure(message: 'Profile count was not updated'));
      }
    } catch (e) {
      CustomLogger(className: 'ProfileProvider').errorPrint(e.toString());
      return Left(
        Failure(
          message: 'Error occurred while trying to update profile count',
        ),
      );
    }
  }

  Future<List> getArtisanReview(String phone) async {
    try {
      // List<ReviewModel> reviewList;
      String apiKey = await Utils.getApiKey();
      final User user = await Utils.getUserSession();
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        "artisan_mobile": phone,
        "mobile": user.phoneNumber,
      };

      String url =
          "https://manager.fixme.ng/get-reviews?mobile=${user.phoneNumber}&artisan_mobile=$phone";

      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      List review = response.data['reviews'];
      // print(review);
      // reviewList = ReviewList.fromData(review).reviewList;
      return review;
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return e;
      // return(
      //   Failure(
      //     message: 'Unable to fetch artisan at the moment',

      // );
    }
  }

  Future<BankInformation> getAccountInfo() async {
    try {
      String url = 'https://manager.fixme.ng/get-user-bank-info';
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      Logger().i(apiKey);
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
      };
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.data['reqRes'] == 'true') {
        final bankInfo = BankInformation.fromMap(
          response.data['accountInfo'],
        );
        return bankInfo;
      }
      throw Exception(
        'Unable to retrieve account information',
      );
    } catch (e) {
      Logger().e(e.toString());
      return BankInformation(
        balance: 0,
      );
    }
  }
}
