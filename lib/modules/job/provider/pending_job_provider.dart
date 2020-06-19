import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class PendingJobProvider extends ChangeNotifier {
  Future<Either<Failure, List<Job>>> getPendingRequest() async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.quickfixnaija.com.ng/projects-by-service';
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'service_id': currentUser.serviceId,
      };
      Map<String, String> headers = {'Bearer': '$apiKey'};
      Response response = await NetworkService().post(
        url: url,
        body: {},
        queryParam: body,
        headers: headers,
        contentType: ContentType.JSON,
      );
      debugPrint(response.data.toString());
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        List<Job> jobs = List();
        return Right(jobs);
      } else {
        return Left(
          Failure(
            message: 'No job available around you at the moment',
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
          message: 'An error occured while trying to fetch jobs around you',
        ),
      );
    }
  }
}
