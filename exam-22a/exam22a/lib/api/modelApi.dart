import 'package:http/http.dart';

class ModelAPI {
  static Future getModels(url) {
    return get(url);
  }

  static Future<Response> makeDeleteRequest(_deleteUrl) async {
    return await delete(_deleteUrl);
  }
}