import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:quickfix/models/failure.dart';
import 'package:quickfix/modules/rate_review/model/rate.dart';
import 'package:quickfix/modules/rate_review/service/rate_artisan.dart';
import 'package:quickfix/util/Utils.dart';

class RateReviewProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<Either<Failure, bool>> rateArtisan(
      int serviceId, String artisanPhone, int rating,
      [int jobId]) async {
    try {
      final user = await Utils.getUserSession();
      final rateArtisan = RateArtisan(
        artisanMobile: artisanPhone,
        jobId: jobId,
        rating: rating,
        serviceRequestId: serviceId,
        ratedBy: user.phoneNumber,
      );

      final rated = await RateArtisanApi().rateArtisan(rateArtisan);
      if (rated == true) {
        return right(rated);
      }
      return left(
        Failure(message: 'Artisan was not rated, please try again'),
      );
    } catch (e) {
      Logger().e(e.toString());
      return left(
        Failure(
            message: 'Unable to rate artisan at the moment, please try again'),
      );
    }
  }
}
