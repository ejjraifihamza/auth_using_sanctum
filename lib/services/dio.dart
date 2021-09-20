import 'package:dio/dio.dart';

Dio dio() {
  var dio = Dio();
  dio.options.baseUrl = 'http://10.0.2.2:8000/api';
  dio.options.connectTimeout = 5000; //5s
  dio.options.receiveTimeout = 3000;
  dio.options.headers['Accept'] = 'application/Json';

  return dio;
}
