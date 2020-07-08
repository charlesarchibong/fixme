import 'package:dartz/dartz.dart';
import 'package:quickfix/models/failure.dart';

abstract class ArtisanService {
  Future<Either<Failure, bool>> requestArtisanService(
    String artisanPhone,
  );
}
