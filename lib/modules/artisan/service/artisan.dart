import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/service/artisan.service..dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

class ArtisanApi extends ArtisanService {
  @override
  Future<Either<Failure, bool>> requestArtisanService(
      String artisanPhone) async {
    try {
      final user = await Utils.getUserSession();
      final String apiKey = await Utils.getApiKey();
      String url = Constants.requestArtisanRequest;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, String> body = {
        'requesting_mobile': user.phoneNumber,
        'requested_mobile': artisanPhone,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return Right(true);
      } else {
        throw Exception(
          'Request was not successful, Please try again!',
        );
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      return Left(
        Failure(
          message: 'Request was not successful, Please try again!',
        ),
      );
    }
  }
}
