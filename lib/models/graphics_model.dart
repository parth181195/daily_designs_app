import 'package:cloud_firestore/cloud_firestore.dart';

class GraphicsModel {
  bool public;
  bool active;
  List<String> category;
  int credits;
  String name;
  String path;
  String slug;
  DocumentReference ref;

  GraphicsModel({this.public, this.active, this.category, this.credits, this.name, this.path, this.slug, this.ref});

  factory GraphicsModel.fromJson(Map<String, dynamic> json, DocumentReference reference) {
    return GraphicsModel(
      public: json['public'],
      active: json['active'],
      category: json['category'] != null ? new List<String>.from(json['category']) : null,
      credits: json['credits'],
      name: json['name'],
      path: json['path'],
      slug: json['slug'],
      ref: reference,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public'] = this.public;
    data['active'] = this.active;
    data['credits'] = this.credits;
    data['name'] = this.name;
    data['path'] = this.path;
    data['slug'] = this.slug;
    if (this.category != null) {
      data['category'] = this.category;
    }
    return data;
  }
}
