import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/job/model/job.dart';
import 'package:quickfix/modules/job/model/job_category.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class PostJobProvider extends ChangeNotifier {
  PostJobProvider();

  bool title = false;
  bool description = false;
  bool price = false;
  bool address = false;
  bool loading = false;

  Future<Either<Failure, List<JobCategory>>> getJobCategories() async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/service-list';
      Map<String, String> body = {
        'mobile': currentUser.phoneNumber,
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
      List<JobCategory> categories = List();
      if (response.statusCode == 200) {
        List list = response.data['services'] as List;
        for (var i = 0; i < list.length; i++) {
          JobCategory jobCategory = JobCategory.fromMap(list[i]);
          categories.add(jobCategory);
        }

        return Right(categories);
      } else {
        return Left(Failure(message: 'No service list fetched'));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(message: 'No service list fetched'));
    }
  }

  Future<Either<Failure, bool>> uploadJob(Job job) async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/new-project';
      Map<String, dynamic> body = {
        'mobile': currentUser.phoneNumber,
        'job_title': job.jobTitle,
        'job_description': job.description,
        'service_id': job.serviceCategory,
        'budget': job.price,
        // 'latitude': job.latitude.toString(),
        // 'longitude': job.longitude.toString(),
        'job_address': job.address,
      };
      print(body);
      Map<String, String> headers = {'Bearer': '$apiKey'};
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
            Failure(message: 'Job was not uploaded, please try again!'));
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.response.data);
      }
      print(e.toString());
      return Left(Failure(message: 'Job was not uploaded, please try again!'));
    }
  }
}
