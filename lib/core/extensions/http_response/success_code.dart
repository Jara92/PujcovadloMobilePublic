import 'package:http/http.dart';

extension IsSuccessCode on Response {
  bool get isSuccessCode => statusCode >= 200 && statusCode < 300;
}
