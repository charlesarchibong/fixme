import 'package:burst/models/failture.dart';
import 'package:burst/services/network_service.dart';
import 'package:burst/util/const.dart';
import 'package:burst/util/content_type.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RequestHelper {
  final String token;
  RequestHelper({
    this.token,
  });

  Future<Either<Failure, bool>> sendDeviceToken(
      String deviceId, int userId) async {
    try {
      String url = Constants.savedDeviceIdEndpoint;
      Map<String, dynamic> body = {
        'device_id': deviceId,
        'user_id': userId,
      };
      Response response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
      );
      print(response.data);
      bool sent = response.data['success'] != null;
      if (sent) {
        return Right(true);
      } else {
        Left(Failure(message: response.data['error']));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: e.toString().split(':')[1]));
    }
  }
}
