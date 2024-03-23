import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  String get apiEndpoint => dotenv.env['API_ENDPOINT']!;
}
