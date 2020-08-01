import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class SecurityPinProvider with ChangeNotifier {
  Future<Either<Failure, bool>> savedSecurityPin(String pin) async {
    try {
      String url = 'https://manager.fixme.ng/save-security-pin';
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String randomToken = Utils.generateId(10);

      String token64 = base64.encode(
        utf8.encode(
          '$randomToken:$pin',
        ),
      );
      String token = 'PIN $token64';

      print(token);

      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
        'secPin': token
      };
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.data['reqRes'] == 'true') {
        return Right(true);
      }
      return Left(
        Failure(
          message:
              'unable to save security pin at the moment, please try again.',
        ),
      );
    } catch (e) {
      // if (e is DioError) {
      //   Logger().e(e.response.data);
      // }
      Logger().e(e.toString());
      return Left(
        Failure(
          message: 'An error occurred, please try again.',
        ),
      );
    }
  }
}
