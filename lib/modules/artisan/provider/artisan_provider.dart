import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickfix/helpers/custom_lodder.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/modules/artisan/service/artisan.dart';

class RequestArtisanService with ChangeNotifier {
  bool loading = false;
  List<ServiceRequest> serviceRequests;

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

  Future<Either<Failure, List<ServiceRequest>>> getRequest() async {
    try {
      loading = true;
      notifyListeners();
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
}
