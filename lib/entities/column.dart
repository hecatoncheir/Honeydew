library column_entity;

import 'dart:collection';

class Column extends MapBase {
  Map<String, dynamic> _entityMap = new Map<String, dynamic>();

  String get uid => this['uid'];
  set uid(String value) => this['uid'] = value;

  String get title => this['title'];
  set title(String value) => this['title'] = value;

  String get field => this['field'];
  set field(String value) => this['field'] = value;

  Column({String uid, String title, String field}) {
    this
      ..uid = uid
      ..title = title
      ..field = field;
  }

  Column.fromMap(Map map) {
    this._entityMap = map;
  }

  operator [](Object key) => _entityMap[key];

  operator []=(dynamic key, dynamic value) => _entityMap[key] = value;

  get keys => _entityMap.keys;

  remove(key) => _entityMap.remove(key);

  clear() => _entityMap.clear();
}
