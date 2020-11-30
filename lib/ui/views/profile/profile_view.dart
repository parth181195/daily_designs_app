import 'dart:io';
import 'package:daily_design/ui/views/profile/profile_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:path/path.dart' as path;

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        onModelReady: (m) => m.init(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                actions: [],
                backgroundColor: Colors.white,
                elevation: 10,
                iconTheme: IconThemeData().copyWith(color: Colors.black),
                shadowColor: Color(0xff2F4858).withOpacity(0.1),
                title: Row(
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily, color: Color(0xff2F4858)),
                    ),
                  ],
                ),
              ),
              body: model.formGroup != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReactiveForm(
                        formGroup: model.formGroup,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Center(
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Email'),
                              )),
                              ReactiveTextField(
                                validationMessages: (control) => {'required': 'Email is required'},
                                onTap: () {
                                  model.setFocusText('email');
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffeeeeee),
                                  hintText: 'Email',
                                  fillColor: model.focusedField == 'email'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'email',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Mobile'),
                              )),
                              ReactiveTextField(
                                validationMessages: (control) => {'required': 'Mobile is required'},
                                onTap: () {
                                  model.setFocusText('mobile');
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffe6eaed),
                                  hintText: 'Mobile',
                                  fillColor: model.focusedField == 'mobile'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'mobile',
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Name'),
                              )),
                              ReactiveTextField(
                                validationMessages: (control) =>
                                    {'required': 'Name is required', 'pattern': 'Enter a valid name'},
                                onTap: () {
                                  model.setFocusText('name');
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffeeeeee),
                                  hintText: 'Name',
                                  fillColor: model.focusedField == 'name'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'name',
                                keyboardType: TextInputType.name,
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Company Name'),
                              )),
                              ReactiveTextField(
                                validationMessages: (control) => {'required': 'Company Name is required'},
                                onTap: () {
                                  model.setFocusText('companyName');
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffe6eaed),
                                  hintText: 'Company Name',
                                  fillColor: model.focusedField == 'companyName'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'companyName',
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Website'),
                              )),
                              ReactiveTextField(
                                validationMessages: (control) =>
                                    {'required': 'Website  is required', 'pattern': 'Enter a valid website url'},
                                onTap: () {
                                  model.setFocusText('website');
                                },
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffe6eaed),
                                  hintText: 'Website',
                                  fillColor: model.focusedField == 'website'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'website',
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Address'),
                              )),
                              ReactiveTextField(
                                maxLines: 3,
                                validationMessages: (control) => {'required': 'Address is required'},
                                onTap: () {
                                  model.setFocusText('address');
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffe6eaed),
                                  hintText: 'Address',
                                  fillColor: model.focusedField == 'address'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'address',
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Industry Type'),
                              )),
                              ReactiveDropdownField(
                                items: model.industry
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                validationMessages: (control) => {'required': 'Industry is required'},
                                onTap: () {
                                  model.setFocusText('companyType');
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffe6eaed),
                                  hintText: 'Industry Type',
                                  fillColor: model.focusedField == 'password'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'companyType',
                              ),
//
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('FaceBook URL'),
                              )),
                              ReactiveTextField(
                                validationMessages: (control) => {
                                  'required': 'Facebook url is required',
                                  'pattern': 'Enter a valid facebook url',
                                  'contains': 'Enter a valid facebook url'
                                },
                                onTap: () {
                                  model.setFocusText('facebook_url');
                                },
                                keyboardType: TextInputType.url,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffe6eaed),
                                  hintText: 'Facebook url',
                                  fillColor: model.focusedField == 'facebook_url'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'facebook_url',
                              ),
                              Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Instagram url'),
                              )),
                              ReactiveTextField(
                                keyboardType: TextInputType.url,
                                validationMessages: (control) => {
                                  'required': 'Instagram url is required',
                                  'contains': 'Enter a valid instagram url',
                                  'pattern': 'Enter a valid instagram url'
                                },
                                onTap: () {
                                  model.setFocusText('instagram_url');
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  filled: true,
                                  focusColor: Color(0xffe6eaed),
                                  hintText: 'Instagram url',
                                  fillColor: model.focusedField == 'instagram_url'
                                      ? Color(0xffe6eaed).withOpacity(1)
                                      : Color(0xffe6eaed).withOpacity(0.5),
                                ),
                                formControlName: 'instagram_url',
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                              Container(
                                width: double.maxFinite,
                                height: 50,
                                child: FlatButton(
                                  onPressed: () async {
                                    await model.updateUser();
                                  },
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  color: Color(0xff2F4858),
                                  child: model.isBusy
                                      ? CircularProgressIndicator(
                                          strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Colors.white))
                                      : Text('Update Profile'),
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(bottom: 10)),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)))),
            ),
        viewModelBuilder: () => ProfileViewModel());
  }
}
