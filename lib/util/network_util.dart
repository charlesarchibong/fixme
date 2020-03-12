import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  //The next three lines of code ensure the class is a singleton
  static final NetworkUtil _networkUtil = NetworkUtil._internal();
  factory NetworkUtil() => _networkUtil;
  NetworkUtil._internal();

  static Future<dynamic> post(
      String url, Map headers, Map body, Encoding encoding) async {
    return http
        .post(url, headers: headers, body: body, encoding: encoding)
        .then((response) {
      return response;
    });
  }

  static Future<dynamic> getRequest(String url, Map headers) async {
    return http.get(url, headers: headers).then((response) {
      return response;
    });
  }

  static Future<dynamic> delete(String url, Map headers) async {
    return http.delete(url, headers: headers).then((response) {
      return response;
    });
  }

  static Future<dynamic> put(String url, Map headers) async {
    return http.put(url, headers: headers).then((response) {
      return response;
    });
  }
}
