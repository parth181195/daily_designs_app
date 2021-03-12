import 'package:daily_design/ui/views/login/login_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/svg.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
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
                              children: [
                                // ReactiveTextField(
                                //   validationMessages: (control) => {'required': 'Email is required'},
                                //   onTap: () {
                                //     model.setFocusText('email');
                                //   },
                                //   keyboardType: TextInputType.emailAddress,
                                //   decoration: InputDecoration(
                                //     border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                //     filled: true,
                                //     focusColor: Color(0xffeeeeee),
                                //     hintText: 'Email',
                                //     fillColor: model.focusedField == 'email'
                                //         ? Color(0xffe6eaed).withOpacity(1)
                                //         : Color(0xffe6eaed).withOpacity(0.5),
                                //   ),
                                //   formControlName: 'email',
                                // ),
                                // Padding(padding: EdgeInsets.only(bottom: 10)),
                                ReactiveTextField(
                                  validationMessages: (control) => {'required': 'Mobile is required'},
                                  onTap: () {
                                    model.setFocusText('mobile');
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    filled: true,
                                    focusColor: Color(0xffe6eaed),
                                    hintText: 'Mobile number',
                                    fillColor: model.focusedField == 'mobile'
                                        ? Color(0xffe6eaed).withOpacity(1)
                                        : Color(0xffe6eaed).withOpacity(0.5),
                                  ),
                                  formControlName: 'mobile',
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                // Container(
                                //   width: double.maxFinite,
                                //   height: 50,
                                //   child: FlatButton(
                                //     onPressed: model.busy('login')
                                //         ? null
                                //         : () async {
                                //             await model.login();
                                //           },
                                //     textColor: Colors.white,
                                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                //     color: Color(0xff2F4858),
                                //     child: model.busy('login_email')
                                //         ? CircularProgressIndicator(
                                //             strokeWidth: 1,
                                //             valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)),
                                //           )
                                //         : Text('Login'),
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: FlatButton(
                                          height: 60,
                                          onPressed: !model.busy('login')
                                              ? () async {
                                                  await model.loginWithPhone();
                                                }
                                              : null,
                                          textColor: Color(0xff2F4858),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          color: Color(0xffe6eaed),
                                          child: model.busy('login_phone')
                                              ? CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)),
                                                )
                                              : Text('Login With Mobile'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 0),
                                //   child: Flex(
                                //     direction: Axis.horizontal,
                                //     children: [
                                //       Expanded(
                                //         flex: 1,
                                //         child: FlatButton(
                                //           height: 60,
                                //           onPressed: !model.busy('login')
                                //               ? () async {
                                //                   await model.loginWithGoogle();
                                //                 }
                                //               : null,
                                //           textColor: Color(0xff2F4858),
                                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                //           color: Color(0xffe6eaed),
                                //           child: model.busy('login_google')
                                //               ? CircularProgressIndicator(
                                //                   strokeWidth: 1,
                                //                   valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)),
                                //                 )
                                //               : Text('Google'),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     model.goToSignUp();
                                //   },
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(20.0),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         Text('Don\'t have an account? ',
                                //             style: TextStyle(
                                //               color: Color(0xff2F4858).withOpacity(0.6),
                                //             )),
                                //         Text(
                                //           'Register',
                                //           style: TextStyle(
                                //             fontWeight: FontWeight.w600,
                                //             color: Color(0xff2F4858),
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                Padding(padding: EdgeInsets.only(bottom: 30)),
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
