import 'package:cloud_firestore/cloud_firestore.dart';

/// name : "string"
/// slug : "string"
/// active : true
/// bytes : "string"
/// is_public : true

class IndustryModel {
  String _name;
  String _slug;
  bool _active;
  String _bytes;
  bool _isPublic;
  DocumentReference reference;

  String get name => _name;

  String get slug => _slug;

  bool get active => _active;

  String get bytes => _bytes;

  bool get isPublic => _isPublic;

  IndustryModel({String name, String slug, bool active, String bytes, bool isPublic, this.reference}) {
    _name = name;
    _slug = slug;
    _active = active;
    _bytes = bytes;
    _isPublic = isPublic;
  }

  factory IndustryModel.fromJson(Map<String, dynamic> json, DocumentReference reference) {
    return IndustryModel(
        name: json["name"],
        slug: json["slug"],
        active: json["active"],
        bytes: json["bytes"],
        isPublic: json["is_public"],
        reference: reference);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["slug"] = _slug;
    map["active"] = _active;
    map["bytes"] = _bytes;
    map["is_public"] = _isPublic;
    return map;
  }
}
