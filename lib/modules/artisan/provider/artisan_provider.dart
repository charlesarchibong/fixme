import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:quickfix/helpers/custom_lodder.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/modules/artisan/service/artisan.dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

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
      final List<ServiceRequest> requests =
          await ArtisanApi().getMyServiceRequest();
      loading = false;
      myRequestedRequest = requests;
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
