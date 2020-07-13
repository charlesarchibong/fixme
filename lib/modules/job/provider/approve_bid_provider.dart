import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/project_bid.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class ApprovedBidProvider with ChangeNotifier {
  List<ProjectBid> approvedBids = List();

  Future<Either<Failure, List<ProjectBid>>> getApprovedBids() async {
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
        List projects = response.data['bids'] as List;
        if (projects.length <= 0) {
          return Left(
            Failure(
              message: 'No approved bids at the moment.',
            ),
          );
        }
        List<ProjectBid> bids = List();
        if (projects.length > 0) {
          for (var i = 0; i < projects.length; i++) {
            ProjectBid bid = ProjectBid.fromMap(projects[i]);
            bids.add(bid);
          }
        }
        return Right(bids);
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

  Future<Either<Failure, bool>> confirmAvailability(
      ProjectBid projectBid) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/started-bids';
      Map<String, dynamic> body = {
        'bidder_mobile': currentUser.phoneNumber,
        'uploader_mobile': projectBid.uploaderMobile,
        'bid_id': projectBid.sn,
        'job_id': projectBid.jobId,
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
        return Right(true);
      } else {
        return Left(
          Failure(
            message: 'Request was not successful, please try again.',
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
              'An error occured while trying to confirm availability, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> declineAvailability(
      ProjectBid projectBid) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/decline-bid';
      Map<String, dynamic> body = {
        'bidder_mobile': currentUser.phoneNumber,
        'uploader_mobile': projectBid.uploaderMobile,
        'bid_id': projectBid.sn,
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
        return Right(true);
      } else {
        return Left(
          Failure(
            message: 'Request was not successful, please try again.',
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
              'An error occured while trying to decline availability, please try again!',
        ),
      );
    }
  }
}
