import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class ApprovedBidProvider with ChangeNotifier {
  List<Map> approvedBids = List();

  Future<Either<Failure, Map>> getApprovedBids() async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/get-my-bids';
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
      };
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
        List projects = response.data['projects'] as List;
        if (projects.length <= 0) {
          return Left(
            Failure(
              message: 'No approved bids at the moment.',
            ),
          );
        }
        // List<Job> jobs = List();
        if (projects.length > 0) {
          for (var i = 0; i < projects.length; i++) {
            Job job = Job.fromMap(projects[i]);
            // jobs.add(job);
          }
        }
        // return Right(jobs);
      } else {
        return Left(
          Failure(
            message: 'No data fetched at the moment.',
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
          message:
              'An error occured while trying to fetch approved bids, please try again!',
        ),
      );
    }
  }
}
