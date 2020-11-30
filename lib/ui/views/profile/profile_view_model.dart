import 'dart:io';

import 'package:daily_design/core/locator.dart';
import 'package:daily_design/models/user_data_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:path/path.dart' as path;

class ProfileViewModel extends BaseViewModel {
  String focusedField = '';

  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  List<String> industry = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  String logoUrl = '';

  User get user => _authService.fbUserStatic;

  UserDataModel userData;

  FormGroup formGroup;

  setFocusText(fieldName) {
    focusedField = fieldName;
    notifyListeners();
  }

  init() async {
    await _authService.getUserObjectFromDbAsFuture(user.uid);
    userData = _authService.userStatic;
    industry = await _firebaseService.getIndustry();
    if (userData.logoPath != null) {
      logoUrl = await storage.ref(userData.logoPath).getDownloadURL();
    }
    industry.add('Other');
    formGroup = FormGroup({
      'email': FormControl(
        value: userData.safeEmail,
        disabled: userData.user.email != null && userData.user.email != '',
        validators: [Validators.required, Validators.email],
      ),
      // 'password': FormControl(value: '123456789', validators: [Validators.required]),
      'name':
          FormControl(value: userData.name, validators: [Validators.required,]),
      'mobile': FormControl(value: userData.mobile, validators: [Validators.required, Validators.number]),
      'address': FormControl(value: userData.address, validators: [Validators.required]),
      'companyName': FormControl(value: userData.companyName, validators: [Validators.required]),
      'companyType': FormControl(value: userData.companyType, validators: [
        Validators.required,
      ]),
      'facebook_url': FormControl(value: userData.facebookUrl, validators: [
        Validators.pattern(r'^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?'),
        ContainsValidator('facebook.com').validate
      ]),
      'website': FormControl(value: userData.website, validators: [
        Validators.pattern(r'^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?'),
      ]),
      'instagram_url': FormControl(value: userData.instagramUrl, validators: [
        Validators.pattern(r'^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?'),
        ContainsValidator('instagram.com').validate
      ]),
    });
    notifyListeners();
  }

  uploadImage(PickedFile pickedFile) async {
    String imageFileName = 'logo/' + DateTime.now().millisecondsSinceEpoch.toString() + path.basename(pickedFile.path);
    Reference firebaseStorageRef = storage.ref().child(imageFileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(File(pickedFile.path));
    uploadTask.whenComplete(() async {
      print('uploded');
      logoUrl = await firebaseStorageRef.getDownloadURL();
      userData.logoPath = imageFileName;
      await _firebaseService.changeUserLogo(imageFileName);
      notifyListeners();
    });
  }

  updateUser() async {
    if (formGroup.valid) {
      setBusy(true);
      UserDataModel payload = UserDataModel.fromJsonData(formGroup.value, _authService.fbUserStatic);
      payload.name = formGroup.value['name'];
      payload.logoPath = userData.logoPath;
      await _firebaseService.updateUserData(payload);
      notifyListeners();
      setBusy(false);
    } else {
      formGroup.markAllAsTouched();
      notifyListeners();
    }
  }
}

class ContainsValidator extends Validator<dynamic> {
  final String value;

  /// Constructs an instance of [PatternValidator].
  ///
  /// The [value] argument must not be null.
  ContainsValidator(this.value) : assert(value != null);

  @override
  Map<String, dynamic> validate(AbstractControl<dynamic> control) {
    RegExp regex = new RegExp(this.value);
    return (control.value == null || control.value.toString() == '' || control.value.contains(value))
        ? null
        : {
            ValidationMessage.contains: {
              'requiredPattern': this.value.toString(),
              'actualValue': control.value,
            }
          };
  }
}
