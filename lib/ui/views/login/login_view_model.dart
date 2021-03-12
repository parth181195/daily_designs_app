import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/login_request_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  String focusedField = '';
  final AuthService _authService = locator<AuthService>();
  final MessagingService _messagingService = locator<MessagingService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FormGroup formGroup = FormGroup({
    'mobile': FormControl(
      value: '',
      validators: [Validators.required, Validators.maxLength(10), Validators.minLength(10)],
    ),
  });

  setFocusText(fieldName) {
    focusedField = fieldName;
    notifyListeners();
  }

  loginWithPhone() async {
    if (formGroup.valid) {
      setBusyForObject('login_phone', true);
      setBusyForObject('login', true);
      User user = await _authService.loginWithOtp(formGroup.controls['mobile'].value,
          codeAutoRetrievalTimeout: () {
            setBusyForObject('login', false);
            setBusyForObject('login_phone', false);
          },
          codeSent: () {},
          verificationCompleted: () async {
            await _messagingService.createTokenAndAddToUser(_authService.fbUserStatic.uid);
            _navigationService.clearStackAndShow(Routes.homeView);
            setBusyForObject('login', false);
            setBusyForObject('login_phone', false);
          },
          verificationFailed: () {
            setBusyForObject('login', false);
            setBusyForObject('login_phone', false);
          });
    } else {
      formGroup.markAllAsTouched();
      notifyListeners();
    }
  }

  loginWithGoogle() async {
    setBusyForObject('login_google', true);
    setBusyForObject('login', true);
    User user = await _authService.loginWithGoogle();
    setBusyForObject('login', false);
    setBusyForObject('login_google', false);
    if (user != null) {
      _navigationService.replaceWith(Routes.homeView);
    }
  }

  loginWithFacebook() async {
    setBusyForObject('login_facebook', true);
    setBusyForObject('login', true);
  }

  login() async {
    notifyListeners();
    if (formGroup.valid) {
      setBusyForObject('login_email', true);
      setBusyForObject('login', true);
      LoginRequestModel loginRequestModel =
          LoginRequestModel(email: formGroup.controls['email'].value, password: formGroup.controls['password'].value);
      User user = await _authService.login(loginRequestModel);
      setBusyForObject('login_email', false);
      setBusyForObject('login', false);
      if (user != null) {
        _navigationService.replaceWith(Routes.homeView);
      }
    } else {
      formGroup.markAllAsTouched();
      notifyListeners();
    }
  }

  goToSignUp() {
    _navigationService.navigateTo(Routes.signUpView);
  }
}
