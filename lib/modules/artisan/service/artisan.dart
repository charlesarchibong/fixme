import 'package:dio/dio.dart';
import 'package:quickfix/modules/artisan/model/service_request.dart';
import 'package:quickfix/modules/artisan/service/artisan.service..dart';
import 'package:quickfix/services/network/network_service.dart';
import 'package:quickfix/util/Utils.dart';
import 'package:quickfix/util/const.dart';
import 'package:quickfix/util/content_type.dart';

class ArtisanApi extends ArtisanService {
  @override
  Future<bool> requestArtisanService(String artisanPhone) async {
    try {
      final user = await Utils.getUserSession();
      final String apiKey = await Utils.getApiKey();
      String url = Constants.requestArtisanRequest;
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, String> body = {
        'requesting_mobile': user.phoneNumber,
        'requested_mobile': artisanPhone,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return true;
      } else {
        throw Exception(
          'Request was not successful, Please try again!',
        );
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      rethrow;
    }
  }

  @override
  Future<List<ServiceRequest>> getServiceRequest() async {
    try {
      final user = await Utils.getUserSession();
      final String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/my-service-request';
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, String> body = {
        'mobile': user.phoneNumber,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      print(response.data.toString());
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        List projects = response.data['serivceRequest'] as List;
        if (projects.length <= 0) {
          throw Exception('No approved bids at the moment');
        }
        List<ServiceRequest> bids = List();
        if (projects.length > 0) {
          for (var i = 0; i < projects.length; i++) {
            ServiceRequest bid = ServiceRequest.fromMap(projects[i]);
            bids.add(bid);
          }
        }
        return bids;
      } else {
        throw Exception(
          'Request was not successful, Please try again!',
        );
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      rethrow;
    }
  }

  @override
  Future<bool> acceptServiceRequest(ServiceRequest serviceRequest) async {
    try {
      final String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/accept-service-request';
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        'requested_mobile': serviceRequest.requestedMobile,
        'requesting_mobile': serviceRequest.requestingMobile,
        'service_request_id': serviceRequest.sn,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return true;
      } else {
        throw Exception(
          'Request was not successful, Please try again!',
        );
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      rethrow;
    }
  }

  @override
  Future<bool> rejectServiceRequest(ServiceRequest serviceRequest) async {
    try {
      final String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/reject-service-request';
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, dynamic> body = {
        'requested_mobile': serviceRequest.requestedMobile,
        'requesting_mobile': serviceRequest.requestingMobile,
        'service_request_id': serviceRequest.sn,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        return true;
      } else {
        throw Exception(
          'Request was not successful, Please try again!',
        );
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      rethrow;
    }
  }

  @override
  Future<List<ServiceRequest>> getMyServiceRequest() async {
    try {
      final user = await Utils.getUserSession();
      final String apiKey = await Utils.getApiKey();
      String url = 'https://manager.fixme.ng/my-requested-services';
      Map<String, String> headers = {'Authorization': 'Bearer $apiKey'};
      Map<String, String> body = {
        'mobile': user.phoneNumber,
      };
      final response = await NetworkService().post(
        url: url,
        body: body,
        contentType: ContentType.URL_ENCODED,
        headers: headers,
      );
      print(response.data.toString());
      if (response.statusCode == 200 && response.data['reqRes'] == 'true') {
        List projects = response.data['serivceRequest'] as List;
        if (projects.length <= 0) {
          throw Exception('No approved bids at the moment');
        }
        List<ServiceRequest> bids = List();
        if (projects.length > 0) {
          for (var i = 0; i < projects.length; i++) {
            ServiceRequest bid = ServiceRequest.fromMap(projects[i]);
            bids.add(bid);
          }
        }
        return bids;
      } else {
        throw Exception(
          'Request was not successful, Please try again!',
        );
      }
    } catch (e) {
      if (e is DioError) {
        print(e.message);
      }
      rethrow;
    }
  }
}
