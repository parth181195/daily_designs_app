import 'package:auto_route/auto_route.dart';
import 'package:daily_design/core/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:stacked_services/stacked_services.dart';
import 'core/router.dart';
import 'core/router.gr.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(AppRoot());
}

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(textTheme: GoogleFonts.montserratTextTheme()),
      onGenerateRoute: Router().onGenerateRoute,
      builder: ExtendedNavigator<Router>(
        initialRoute: Routes.splashView,
        router: Router(),
        navigatorKey: locator<NavigationService>().navigatorKey,
        guards: [AuthGuard()],
      ),
    );
  }
}
