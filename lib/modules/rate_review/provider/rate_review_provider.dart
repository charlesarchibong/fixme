import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickfix/models/failure.dart';

class RateReviewProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<Either<Failure, bool>> rateArtisan(
      String serviceId, String artisanPhone, int rating,
      [int jobId]) {}
}
