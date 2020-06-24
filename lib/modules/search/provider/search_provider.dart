import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

class SearchProvider extends ChangeNotifier {
  Future<Either<Failure, List>> searchArtisan(
    String keyword,
  ) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = Constants.searchArtisans;
      Location location = new Location();
      LocationData locationData = await location.getLocation();
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'search-query': keyword,
        'longitude': locationData.longitude,
        'latitude': locationData.latitude,
      };
      Map<String, String> headers = {'Bearer': '$apiKey'};
      print(body);
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );
      print(response.data);
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        // return Right(true);
      } else {
        return Left(
          Failure(
            message: 'No Artisan was found',
          ),
        );
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.response.data);
      }
      print(e.toString());
      return Left(
        Failure(
          message: 'An error occured, please try again!',
        ),
      );
    }
  }
}
