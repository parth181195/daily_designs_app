import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataModel {
  User user;
  String email;
  String plan;
  String remainingGraphics;
  String mobile;
  String uid;
  String name;
  String address;
  String companyName;
  String logoPath;
  String companyType;
  String facebookUrl;
  String website;
  String instagramUrl;
  String fcmToken;

  String get safeEmail {
    if (!(user.email != null && user.email != '')) {
      return this.email;
    }
    return user.email;
  }

  UserDataModel({
    @required this.user,
    this.plan,
    this.remainingGraphics,
    this.address,
    this.fcmToken,
    this.name,
    this.mobile,
    this.companyName,
    this.companyType,
    this.website,
    this.facebookUrl,
    this.instagramUrl,
  });

  UserDataModel.fromJson(Map<String, dynamic> json, User user) {
    this.user = user;

    if (!(user.email != null && user.email != '')) {
      this.email = json['email'];
    }
    // this.plan = json['plan'];
    this.remainingGraphics = json['remaining_graphics'];
    this.mobile = json['mobile'];
    this.address = json['address'];
    this.logoPath = json['logo_path'];
    this.uid = user.uid;
    this.name = user.displayName != null && user.displayName != '' ? user.displayName : json['name'];
    this.companyName = json['companyName'];
    this.companyType = json['companyType'];
    this.website = json['website'];
    this.facebookUrl = json['facebook_url'];
    this.instagramUrl = json['instagram_url'];
  }

  UserDataModel.fromJsonData(Map<String, dynamic> json, User user) {
    this.user = user;
    if (!(user.email != null && user.email != '')) {
      this.email = json['email'];
    }
    this.plan = json['plan'];
    this.remainingGraphics = json['remaining_graphics'];
    this.mobile = json['mobile'];
    this.address = json['address'];
    this.logoPath = json['logo_path'];
    this.uid = user.uid;
    this.name = json['name'];
    this.companyName = json['companyName'];
    this.companyType = json['companyType'];
    this.website = json['website'];
    this.facebookUrl = json['facebook_url'];
    this.instagramUrl = json['instagram_url'];
  }

  toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remaining_graphics'] = this.remainingGraphics;
    data['plan'] = this.plan;

    data['email'] = user.email != null && user.email != '' ? this.user.email : this.email;
    data['uid'] = this.user.uid;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['logo_path'] = this.logoPath;
    data['name'] = (this.user.displayName != null && this.user.displayName != '') ? this.user.displayName : this.name;
    data['companyName'] = this.companyName;
    data['companyType'] = this.companyType;
    data['website'] = this.website;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    return data;
  }

  toJsonData() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remaining_graphics'] = this.remainingGraphics;
    data['email'] = user.email != null && user.email != '' ? this.user.email : this.email;
    data['uid'] = this.user.uid;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['logo_path'] = this.logoPath;
    data['name'] = this.name;
    data['companyName'] = this.companyName;
    data['companyType'] = this.companyType;
    data['website'] = this.website;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    return data;
  }
}
