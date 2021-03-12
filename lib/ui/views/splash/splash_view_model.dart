import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:daily_design/services/messaging_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  DialogService _dialogService = locator<DialogService>();
  FirebaseService _firebaseService = locator<FirebaseService>();
  MessagingService _messagingService = locator<MessagingService>();
  final AuthService _authService = locator<AuthService>();
  final version = '1.0.1';

  init() async {
    String ver = await _firebaseService.getVersion();
    if (_authService.fbUserStatic != null) {
      await _authService.getUserObjectFromDb(_authService.fbUserStatic.uid);
      await _messagingService.createTokenAndAddToUser(_authService.fbUserStatic.uid);
      if (ver == version) {
        _navigationService.replaceWith(Routes.homeView);
      } else {
        await showTrialFinishDiag();
      }
    } else {
      if (ver == version) {
        _navigationService.replaceWith(Routes.loginView);
      } else {
        await showTrialFinishDiag();
      }
    }
  }

  showTrialFinishDiag() async {
    await _dialogService.showDialog(
      title: 'Update required',
      description: 'Please update the app to continue',
      barrierDismissible: true,
    );
  }
}
