import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

class MyRequestProvider extends ChangeNotifier {
  Future<Either<Failure, List<Job>>> getMyRequests() async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = Constants.getMyRequestEndpoint;
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
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
        List projects = response.data['projects'] as List;
        List<Job> jobs = List();
        if (projects.length > 0) {
          for (var i = 0; i < projects.length; i++) {
            Job job = Job.fromMap(projects[i]);
            jobs.add(job);
          }
        }
        return Right(jobs);
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
              'An error occured while trying to fetch jobs you posted, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, List>> getJobBidders(Job job) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = Constants.getJobBidders;
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'job_id': job.id,
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
      print(response.data);
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        List bidders = response.data['projectBids'] as List;
        // print('rrerh');
        if (bidders.length > 0) {
          return Right(bidders);
          //Return Right HEre
        } else {
          return Left(
            Failure(
              message: 'No Artisan has bid this job',
            ),
          );
        }
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
              'An error occured while trying to fetch bidders, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> approveBidder(
    int bidId,
    String bidderMobile,
  ) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = Constants.approveBid;
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'bidder_mobile': bidderMobile,
        'bid_id': bidId,
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
      print(response.data);
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return Right(true);
      } else {
        return Left(
          Failure(
            message: 'Unable to approve bid, please try again.',
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

  Future<Either<Failure, bool>> rejectBidder(
    int bidId,
    String bidderMobile,
  ) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = Constants.rejectBid;
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'bidder_mobile': bidderMobile,
        'bid_id': bidId,
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
      print(response.data);
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return Right(true);
      } else {
        return Left(
          Failure(
            message: 'Unable to reject bid, please try again.',
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
