class Song {
  int _id;
  String _title;
  String _description;
  String _album;
  String _genre;
  int _year;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get title => _title;

  set title(String title) {
    _title = title;
  }

  String get album => _album;

  set album(String album) {
    _album = album;
  }

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  String get genre => _genre;

  set genre(String genre) {
    _genre = genre;
  }

  int get year => _year;

  set year(int year) {
    _year = year;
  }

  Song.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _title = json['title'].toString(),
        _description = json['description'].toString(),
        _album = json['album'].toString(),
        _genre = json['genre'].toString(),
        _year = json['year'];

  Song(
    String title,
    String description,
    String album,
    String genre,
    int year,
  ) {
    _title = title;
    _description = description;
    _album = album;
    _genre = genre;
    _year = year;
  }
}
