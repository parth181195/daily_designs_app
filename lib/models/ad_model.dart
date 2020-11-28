import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel {
  bool active;
  String category;
  String path;
  DocumentReference ref;

  AdModel({this.active, this.category, this.path, this.ref});

  factory AdModel.fromJson(Map<String, dynamic> json, DocumentReference reference) {
    return AdModel(active: json['active'], category: json['category'], path: json['path'], ref: reference);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['category'] = this.category;
    data['path'] = this.path;
    return data;
  }
}
