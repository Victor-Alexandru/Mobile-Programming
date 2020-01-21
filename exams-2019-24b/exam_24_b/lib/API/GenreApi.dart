import 'package:http/http.dart';
import 'dart:convert';

class GenreAPI {
  static Future getGenres(url) {
    return get(url);
  }

  static Future getSongs(url) {
    return get(url);
  }
}
