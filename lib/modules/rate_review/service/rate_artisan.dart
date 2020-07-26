import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/modules/rate_review/model/rate.dart';
import 'package:quickfix/modules/rate_review/service/interface/rate_artisan.interface.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class RateArtisanApi extends RateReview {
  @override
  Future<bool> rateArtisan(RateArtisan rateArtisan) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/started-bids';
      Map<String, dynamic> body = rateArtisan.toMap();
      body['rated_by'] = currentUser.phoneNumber;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return true;
      } else {
        throw Exception('Request was not successful, please try again.');
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.response.data);
      }
      rethrow;
    }
  }

  @override
  Future<bool> reviewArtisan(RateArtisan rateArtisan, String review) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/save-review';
      Map<String, dynamic> body = rateArtisan.toMap();
      body['reviewed_by'] = currentUser.phoneNumber;
      body['review'] = review;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return true;
      } else {
        throw Exception('Request was not successful, please try again.');
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.response.data);
      }
      rethrow;
    }
  }
}
