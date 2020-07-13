import 'package:quickfix/modules/artisan/model/service_request.dart';

abstract class ArtisanService {
  Future<bool> requestArtisanService(
    String artisanPhone,
  );

  Future<List<ServiceRequest>> getServiceRequest();
}
