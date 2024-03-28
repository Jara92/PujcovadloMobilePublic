import 'package:dio/dio.dart';

extension IsSuccessCode on Response {
  bool get isSuccessCode =>
      statusCode != null ? statusCode! >= 200 && statusCode! < 300 : false;
}
