import 'package:daily_design/models/login_request_model.dart';

class SignUpRequestModel {
  LoginRequestModel loginDetails;
  String mobile;
  String address;
  String companyName;
  String name;
  String companyType;
  String facebookUrl;
  String instagramUrl;

  SignUpRequestModel(
      {this.loginDetails,
      this.mobile,
      this.address,
      this.name,
      this.companyName,
      this.companyType,
      this.facebookUrl,
      this.instagramUrl}) {}

  SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    this.loginDetails =
        LoginRequestModel(email: json['email'], password: json['password']);
    this.mobile = json['mobile'];
    this.address = json['address'];
    this.companyName = json['company_name'];
    this.companyType = json['company_type'];
    this.name = json['name'];
    this.facebookUrl = json['facebook_url'];
    this.instagramUrl = json['instagram_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.loginDetails.email;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['companyName'] = this.companyName;
    data['company_type'] = this.companyType;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    return data;
  }
}
