import 'package:daily_design/ui/views/splash/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/svg.dart';

class SplashView extends StatefulWidget {
  SplashView({Key key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    print('in splash');
    return ViewModelBuilder<SplashViewModel>.reactive(
      onModelReady: (model) async {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          print('in splash');
          await model.init();
        });
      },
      viewModelBuilder: () => SplashViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Opacity(
                  opacity: 1,
                  child: Image.asset(
                    'assets/logo_splash.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0), Color(0xff032cfc).withOpacity(0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.6, 1.0])),
            ),
          ],
        ),
      ),
    );
  }
}
