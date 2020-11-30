import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/user_data_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  User get user => _authService.fbUserStatic;

  UserDataModel userData;

  init() async {
    setBusyForObject('init', true);
    userData = await _authService.getUserObjectFromDbAsFuture(user.uid);
    setBusyForObject('init', false);
  }

  goToLogoSettings() {
    _navigationService.navigateTo(Routes.logoSettingsView);
  }

  goToProfile() {
    _navigationService.navigateTo(Routes.profileView);
  }

  logout() async {
    setBusyForObject('logout', true);
    await _authService.logout();
    _navigationService.navigateTo(Routes.splashView);
  }

  goToPurchases() {
    _navigationService.navigateTo(Routes.plansView);
  }

}
