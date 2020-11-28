import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/login_request_model.dart';
import 'package:daily_design/models/sign_up_request_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  String focusedField = '';

  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  List<String> industry = [];
  final FormGroup formGroup = FormGroup({
    'email': FormControl(
      value: '',
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl(value: '', validators: [Validators.required, Validators.minLength(6)],),
    'name': FormControl(value: '', validators: [Validators.required]),
    'mobile': FormControl(value: '', validators: [Validators.required, Validators.number]),
    'address': FormControl(value: '', validators: [Validators.required]),
    'website': FormControl(value: '', validators: []),
    'company_name': FormControl(value: '', validators: [Validators.required]),
    'company_type': FormControl(value: '', validators: [
      Validators.required,
    ]),
    'facebook_url': FormControl(value: 'test.com', validators: []),
    'instagram_url': FormControl(value: 'test.com', validators: []),
  });

  setFocusText(fieldName) {
    focusedField = fieldName;
    notifyListeners();
  }

  init() async {
    industry = await _firebaseService.getIndustry();
    industry.add('Other');
    notifyListeners();
  }

  gotoLogin() {
    _navigationService.replaceWith(Routes.loginView);
  }

  signUp() async {
    notifyListeners();
    if (formGroup.valid) {
      setBusyForObject('sign_up_email', true);
      setBusyForObject('sign_up', true);
      SignUpRequestModel model = SignUpRequestModel.fromJson(formGroup.value);
      User user = await _authService.signUp(model);
      setBusyForObject('sign_up_email', false);
      setBusyForObject('sign_up', false);
      if (user != null) {
        _navigationService.clearStackAndShow(Routes.homeView);
      }
    } else {
      formGroup.markAllAsTouched();
      notifyListeners();
    }
  }
}
