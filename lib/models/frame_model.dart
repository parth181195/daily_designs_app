import 'package:cloud_firestore/cloud_firestore.dart';

class FrameModel {
  bool public;
  bool active;
  String name;
  String path;
  String slug;
  bool isDark;

  DocumentReference ref;

  FrameModel({this.isDark, this.public, this.active, this.name, this.path, this.slug, this.ref});

  factory FrameModel.fromJson(Map<String, dynamic> json, DocumentReference reference) {
    return FrameModel(
        public: json['public'],
        isDark: json['is_dark'] == null ? false : json['is_dark'],
        active: json['active'],
        name: json['name'],
        path: json['path'],
        slug: json['slug'],
        ref: reference);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public'] = this.public;
    data['active'] = this.active;
    data['name'] = this.name;
    data['path'] = this.path;
    data['slug'] = this.slug;
    data['is_dark'] = this.isDark;
    return data;
  }
}
