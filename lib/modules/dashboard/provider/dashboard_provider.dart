import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/dashboard/model/dashboard_model.dart';
import 'package:quickfix/modules/profile/model/user.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/content_type.dart';

class DashBoardProvider extends ChangeNotifier {
  Future<Either<Failure, DashboardModel>> getDashboardData() async {
    try {
      User currentUser = await Utils.getUserSession();
      String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/mobile-dashboard';
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
        DashboardModel dashboardModel = DashboardModel.fromMap(
          response.data['dashboard_data'],
        );
        return Right(dashboardModel);
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
              'An error occured while trying to fetch dashboard data, please try again!',
        ),
      );
    }
  }
}
