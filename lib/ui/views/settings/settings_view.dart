import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:daily_design/ui/views/settings/settings_view_model.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsVIewState createState() => _SettingsVIewState();
}

class _SettingsVIewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
        onModelReady: (m) async {
          await m.init();
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 10,
                iconTheme: IconThemeData().copyWith(color: Colors.black),
                shadowColor: Color(0xff2F4858).withOpacity(0.1),
                title: Row(
                  children: [
                    Text(
                      'Daily',
                      style: TextStyle(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          color: Color(0xff2F4858),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Designs',
                      style: TextStyle(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          color: Color(0xfff00104),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Remaining Credits',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 150,
                                child: Center(
                                  child: model.busy('init')
                                      ? CircularProgressIndicator(
                                          strokeWidth: 1,
                                          valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            model.userData.remainingGraphics,
                                            style: TextStyle(fontSize: 100),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: FlatButton(
                            height: 60,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              model.goToProfile();
                            },
                            textColor: Color(0xff2F4858),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Color(0xffe6eaed),
                            child: Text('Profile'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: FlatButton(
                            height: 60,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              model.goToLogoSettings();
                            },
                            textColor: Color(0xff2F4858),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Color(0xffe6eaed),
                            child: Text('Logo settings'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: FlatButton(
                            height: 60,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              model.goToPurchases();
                            },
                            textColor: Color(0xff2F4858),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Color(0xffe6eaed),
                            child: Text('Purchases'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: FlatButton(
                            height: 60,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: !model.busy('logout')
                                ? () async {
                                    await model.logout();
                                  }
                                : null,
                            textColor: Color(0xff2F4858),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Color(0xffe6eaed),
                            child: Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => SettingsViewModel());
  }
}
