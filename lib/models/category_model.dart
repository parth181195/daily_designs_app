import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  bool active;
  String image;
  String name;
  String slug;
  DocumentReference ref;

  CategoryModel({this.active, this.image, this.name, this.slug, this.ref});

  factory CategoryModel.fromJson(Map<String, dynamic> json, DocumentReference reference) {
    return CategoryModel(
      active: json['active'],
      image: json['image'],
      name: json['name'],
      slug: json['slug'],
      ref: reference,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['image'] = this.image;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}
