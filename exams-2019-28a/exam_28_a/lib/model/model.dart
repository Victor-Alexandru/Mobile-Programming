class Model {
  int _id;
  String _name;
  String _type;
  String _size;
  String _owner;
  String _status;

  int get id => _id;

  set id(int id) {
    _id = id;
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

  String get owner => _owner;

  set owner(String owner) {
    _owner = owner;
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
        _owner = json['owner'].toString(),
        _status = json['status'].toString();

  Model(
    String name,
    String type,
    String size,
    String owner,
    String status,
  ) {
    _name = name;
    _type = type;
    _size = size;
    _owner = owner;
    _status = status;
  }
}
