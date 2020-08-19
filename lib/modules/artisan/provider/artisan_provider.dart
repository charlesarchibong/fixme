import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

import '../../../helpers/custom_lodder.dart';
import '../../../models/failure.dart';
import '../../../services/network/network_service.dart';
import '../../../util/Utils.dart';
import '../../../util/const.dart';
import '../../../util/content_type.dart';
import '../model/service_request.dart';
import '../service/artisan.dart';

class ArtisanProvider with ChangeNotifier {
  bool loading = false;
  List<ServiceRequest> serviceRequests = List();
  List<ServiceRequest> myRequestedRequest = List();

  Future<Either<Failure, bool>> request(String artisanPhone) async {
    try {
      loading = true;
      notifyListeners();
      final bool requested = await ArtisanApi().requestArtisanService(
        artisanPhone,
      );
      loading = false;
      notifyListeners();
      return Right(
        requested,
      );
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Request was not successful, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, List<ServiceRequest>>> getRequests() async {
    try {
      loading = true;
      // notifyListeners();
      print('Requesting');
      final List<ServiceRequest> requests =
          await ArtisanApi().getServiceRequest();
      loading = false;
      serviceRequests = requests;

      notifyListeners();
      return Right(
        requests,
      );
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Request was not successful, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, List<ServiceRequest>>> getMyRequestedService() async {
    try {
      loading = true;
      var requests = await ArtisanApi().getMyServiceRequest();

      serviceRequests = requests;

      loading = false;

      notifyListeners();
      return Right(
        requests,
      );
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Request was not successful, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> acceptRequest(
      ServiceRequest serviceRequest) async {
    try {
      loading = true;
      notifyListeners();
      final bool requested = await ArtisanApi().acceptServiceRequest(
        serviceRequest,
      );
      loading = false;
      notifyListeners();
      return Right(
        requested,
      );
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Request was not successful, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, List>> getArtisanByLocation(
      LocationData locationData) async {
    try {
      final user = await Utils.getUserSession();

      String apiKey = await Utils.getApiKey();
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        'mobile': user.phoneNumber,
        'latitude': locationData.latitude,
        'longitude': locationData.longitude
      };
      String url = Constants.getArtisanByLocationUrl;
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      var artisans = response.data['sortedUsers'] as List;
      print(artisans.toString());
      return right(artisans);
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Unable to fetch artisan at the moment',
        ),
      );
    }
  }

  Future<Either<Failure, List>> getMoreArtisanByLocation(
      {LocationData locationData, String highestId}) async {
    try {
      final user = await Utils.getUserSession();

      String apiKey = await Utils.getApiKey();
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        'mobile': user.phoneNumber,
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
        'highestId': highestId
      };
      String url = Constants.getMoreArtisan;
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );

      var artisans = [];

      artisans = response.data['sortedUsers'] as List;

      return right(artisans);
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Unable to fetch artisan at the moment',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> rejectRequest(
      ServiceRequest serviceRequest) async {
    try {
      loading = true;
      notifyListeners();
      final bool requested = await ArtisanApi().rejectServiceRequest(
        serviceRequest,
      );
      loading = false;
      notifyListeners();
      return Right(
        requested,
      );
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Request was not successful, please try again!',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> requestForPayment(
      ServiceRequest serviceRequest) async {
    try {
      loading = true;
      notifyListeners();
      final bool requested = await ArtisanApi().rejectServiceRequest(
        serviceRequest,
      );
      loading = false;
      notifyListeners();
      return Right(
        requested,
      );
    } catch (e) {
      CustomLogger().errorPrint(
        e.toString(),
      );
      loading = false;
      notifyListeners();
      return Left(
        Failure(
          message: 'Request was not successful, please try again!',
        ),
      );
    }
  }
}
