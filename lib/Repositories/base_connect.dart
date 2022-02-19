import 'package:get/get_connect.dart';

class BaseConnect extends GetConnect {
  final String apiKey = "e690d887481e742ce596392a9af53b85";

  Map<String, dynamic> addAuthorizationParams(Map<String, dynamic>? params) {
    params ??= {};
    params["api_key"] = apiKey;
    return params;
  }
}
