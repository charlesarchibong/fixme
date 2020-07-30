import 'package:quickfix/modules/artisan/model/service_request.dart';

abstract class ArtisanService {
  Future<bool> requestArtisanService(String artisanPhone);

  Future<List<ServiceRequest>> getServiceRequest();
  Future<List<ServiceRequest>> getMyServiceRequest();

  Future<bool> requestForPayment(ServiceRequest serviceRequest);

  Future<bool> acceptServiceRequest(ServiceRequest serviceRequest);
  Future<bool> rejectServiceRequest(ServiceRequest serviceRequest);
}
