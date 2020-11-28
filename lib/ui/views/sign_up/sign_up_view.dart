import 'package:daily_design/ui/views/sign_up/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/svg.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      onModelReady: (model) async => await model.init(),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            Opacity(
                opacity: 0.5,
                child: SvgPicture.asset('assets/bg.svg',
                    fit: BoxFit.cover, alignment: Alignment.center, semanticsLabel: 'Acme Logo')),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
//              height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
                        Text(
                          'Daily',
                          style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily, fontSize: 60),
                        ),
                        Text(
                          'Designs',
                          style: TextStyle(
                              fontFamily: GoogleFonts.montserrat().fontFamily, fontSize: 60, color: Color(0xfff00104)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ReactiveForm(
                          formGroup: model.formGroup,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  child: Text('Name'),
                                )),
                                ReactiveTextField(
                                  validationMessages: (control) => {'required': 'Name is required'},
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
                                  child: Text('Password'),
                                )),
                                ReactiveTextField(
                                  validationMessages: (control) => {
                                    'required': 'Password is required',
                                    'minLength': 'Password must be at least 6 characters '
                                  },
                                  onTap: () {
                                    model.setFocusText('password');
                                  },
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    filled: true,
                                    focusColor: Color(0xffe6eaed),
                                    hintText: 'Password',
                                    fillColor: model.focusedField == 'password'
                                        ? Color(0xffe6eaed).withOpacity(1)
                                        : Color(0xffe6eaed).withOpacity(0.5),
                                  ),
                                  formControlName: 'password',
                                ),
                                Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Company Name'),
                                )),
                                ReactiveTextField(
                                  validationMessages: (control) => {'required': 'Company Name is required'},
                                  onTap: () {
                                    model.setFocusText('company_name');
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    filled: true,
                                    focusColor: Color(0xffe6eaed),
                                    hintText: 'Company Name',
                                    fillColor: model.focusedField == 'company_name'
                                        ? Color(0xffe6eaed).withOpacity(1)
                                        : Color(0xffe6eaed).withOpacity(0.5),
                                  ),
                                  formControlName: 'company_name',
                                ),
                                Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Website'),
                                )),
                                ReactiveTextField(
                                  validationMessages: (control) => {'required': 'Website Name is required'},
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
                                  child: Text('Mobile'),
                                )),
                                ReactiveTextField(
                                  validationMessages: (control) => {
                                    'required': 'Mobile is required',
                                  },
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
                                    model.setFocusText('company_type');
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
                                  formControlName: 'company_type',
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                Container(
                                  width: double.maxFinite,
                                  height: 50,
                                  child: FlatButton(
                                    onPressed: () async {
                                      await model.signUp();
                                    },
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    color: Color(0xff2F4858),
                                    child: Text('Sign up'),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                GestureDetector(
                                  onTap: () {
                                    model.gotoLogin();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Already have an account? ',
                                            style: TextStyle(
                                              color: Color(0xff2F4858).withOpacity(0.6),
                                            )),
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff2F4858),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
