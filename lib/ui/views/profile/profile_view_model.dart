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
        value: user.email,
        disabled: true,
        validators: [Validators.required, Validators.email],
      ),
      // 'password': FormControl(value: '123456789', validators: [Validators.required]),
      'name': FormControl(value: user.displayName, validators: [Validators.required]),
      'mobile': FormControl(value: userData.mobile, validators: [Validators.required, Validators.number]),
      'address': FormControl(value: userData.address, validators: [Validators.required]),
      'companyName': FormControl(value: userData.companyName, validators: [Validators.required]),
      'companyType': FormControl(value: userData.companyType, validators: [
        Validators.required,
      ]),
      'facebook_url': FormControl(value: userData.facebookUrl, validators: []),
      'website': FormControl(value: userData.website, validators: []),
      'instagram_url': FormControl(value: userData.instagramUrl, validators: []),
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
    setBusy(true);
    UserDataModel payload = UserDataModel.fromJsonData(formGroup.value, _authService.fbUserStatic);
    payload.name = formGroup.value['name'];
    payload.logoPath = userData.logoPath;
    await _firebaseService.updateUserData(payload);
    notifyListeners();
    setBusy(false);
  }
}
