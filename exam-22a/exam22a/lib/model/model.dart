class Model {
  int _id;
  String _name;
  String _details;
  String _type;
  int _time;
  int _rating;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  int get time => _time;

  set time(int time) {
    _time = time;
  }

  int get rating => _rating;

  set rating(int rating) {
    _rating = rating;
  }

  String get name => _name;

  set name(String name) {
    _name = name;
  }

  String get details => _details;

  set details(String details) {
    _details = details;
  }

  String get type => _type;

  set type(String type) {
    _type = type;
  }

  Model.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'].toString(),
        _type = json['type'].toString(),
        _details = json['details'].toString(),
        _time = json['time'],
        _rating = json['rating'];

  Model(
    String _name,
    String _details,
    String _type,
    int _time,
    int _rating,
  ) {
    _name = name;
    _type = type;
    _details = details;
    _time = time;
    _rating = rating;
  }
}
