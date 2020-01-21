import 'package:http/http.dart';
import 'dart:convert';

class SongAPI {
  static Future getSongs(url) {
    return get(url);
  }

  static Future<Response> makeDeleteRequest(_deleteUrl) async {
    return await delete(_deleteUrl);
  }
}
