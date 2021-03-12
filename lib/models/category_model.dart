import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String group;
  bool showOnHome;
  bool isPublic;
  String bytes;

  bool active;
  String image;
  String name;
  String slug;
  DocumentReference ref;

  CategoryModel(
      {this.active,
      this.image,
      this.name,
      this.slug,
      this.ref,
      this.bytes,
      this.group,
      this.isPublic,
      this.showOnHome});

  factory CategoryModel.fromJson(Map<String, dynamic> json, DocumentReference reference) {
    return CategoryModel(
      active: json['active'],
      image: json['image'],
      name: json['name'],
      slug: json['slug'],
      bytes: json['bytes'],
      group: json['group'],
      isPublic: json['is_public'],
      showOnHome: json['showOnHome'],
      ref: reference,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['image'] = this.image;
    data['name'] = this.name;

    data['slug'] = this.slug;
    data['bytes'] = this.bytes;
    data['group'] = this.group;
    data['is_public'] = this.isPublic;
    data['showOnHome'] = this.showOnHome;
    return data;
  }
}
