class Model {
  int _id;
  String _name;
  String _type;
  String _size;
  int _power;
  String _status;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  int get power => _power;

  set power(int power) {
    _power = power;
  }

  String get name => _name;

  set name(String name) {
    _name = name;
  }

  String get type => _type;

  set type(String type) {
    _type = type;
  }

  String get size => _size;

  set size(String size) {
    _size = size;
  }

  String get status => _status;

  set status(String status) {
    _status = status;
  }

  Model.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'].toString(),
        _type = json['type'].toString(),
        _size = json['size'].toString(),
        _power = json['power'],
        _status = json['status'].toString();

  Model(
    String name,
    String type,
    String size,
    String status,
    int power,
  ) {
    _name = name;
    _type = type;
    _size = size;
    _power = power;
    _status = status;
  }
}
