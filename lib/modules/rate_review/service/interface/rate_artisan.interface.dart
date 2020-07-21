import 'package:quickfix/modules/rate_review/model/rate.dart';

abstract class RateReview {
  Future<bool> rateArtisan(RateArtisan rateArtisan);
  Future<bool> reviewArtisan(RateArtisan rateArtisan);
}
