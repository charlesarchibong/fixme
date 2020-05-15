import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quickfix/interceptors/dio_connectivity_request_retrier.dart';
import 'package:quickfix/interceptors/retry_request_interceptor.dart';

class NetworkService {
  static Dio dio;

  Future<Response> post({
    @required String url,
    Map headers,
    @required Map body,
    @required contentType,
    Map queryParam,
  }) async {
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );

    Response response = await dio.post(
      url,
      data: body,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
    return response;
  }

  Future<Response> upload({
    @required String url,
    Map headers,
    @required dynamic body,
    @required contentType,
    Map queryParam,
  }) async {
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );

    Response response = await dio.post(
      url,
      data: body,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
    return response;
  }

  Future<dynamic> getRequest({
    @required String url,
    Map headers,
    Map queryParam,
    @required contentType,
  }) async {
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    dio.options.headers = headers;
    Response response = await dio.get(
      url,
      queryParameters: queryParam,
      options: Options(
        contentType: contentType,
        headers: headers,
      ),
    );
    return response;
  }

  Future<dynamic> delete({
    @required String url,
    Map headers,
    Map queryParam,
    @required contentType,
  }) async {
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    dio.options.headers = headers;
    Response response = await dio.delete(url,
        queryParameters: queryParam,
        options: Options(
          contentType: contentType,
          headers: headers,
        ));
    return response;
  }

  Future<dynamic> put({
    @required String url,
    Map headers,
    @required Map data,
    @required contentType,
  }) async {
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),
    );
    dio.options.headers = headers;
    Response response = await dio.put(url,
        data: data,
        options: Options(
          contentType: contentType,
          headers: headers,
        ));
    return response;
  }
}
