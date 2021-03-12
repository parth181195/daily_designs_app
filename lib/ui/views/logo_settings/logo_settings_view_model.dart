import 'dart:io';
import 'dart:typed_data';

import 'package:daily_design/core/locator.dart';
import 'package:daily_design/models/user_data_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:path/path.dart' as path;

class LogoSettingsViewModel extends BaseViewModel {
  String focusedField = '';

  final SnackbarService _snackbarService = locator<SnackbarService>();
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  List<String> industry = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  Uint8List logoUrl;
  double uploadBytes = 0;

  User get user => _authService.fbUserStatic;

  UserDataModel userData;

  init() async {
    setBusyForObject('logo', true);
    await _authService.getUserObjectFromDbAsFuture(user.uid);
    userData = _authService.userStatic;
    industry = await _firebaseService.getIndustry();
    if (userData.logoPath != null) {
      var url = await storage.ref(userData.logoPath).getDownloadURL();
      logoUrl = await networkImageToByte(url);
      setBusyForObject('logo', false);
      notifyListeners();
      // try {
      // }
    } else {
      setBusyForObject('logo', false);
    }
  }

  uploadImage() async {
    if (logoUrl != null) {
      setBusyForObject('file_upload', true);
      String basename = DateTime.now().microsecondsSinceEpoch.toString() + '.png';
      String fileName = (await getTemporaryDirectory()).path + basename;
      var file = File(fileName);
      file.writeAsBytesSync(logoUrl);
      String imageFileName = 'logo/' + basename;
      Reference firebaseStorageRef = storage.ref().child(imageFileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        print('Task state: ${event.state}');
        print('Progress: ${(event.bytesTransferred / event.totalBytes) * 100} %');
        uploadBytes = event.bytesTransferred / event.totalBytes;

        notifyListeners();
        print(event);
      });
      uploadTask.whenComplete(() async {
        userData.logoPath = imageFileName;
        await _firebaseService.changeUserLogo(imageFileName);
        _snackbarService.showSnackbar(message: 'logo Updated');
        setBusyForObject('file_upload', false);
        notifyListeners();
      });

      uploadTask.catchError((e) async {
        setBusyForObject('file_upload', false);
      });
    }
  }

  removeImage() async {
    setBusyForObject('file_remove', true);
    try {
      Reference firebaseStorageRef = storage.ref().child(userData.logoPath);
      await firebaseStorageRef.delete();
      userData.logoPath = null;
      await _firebaseService.removeUserLogo();
      this.logoUrl = null;

      setBusyForObject('file_remove', false);
      notifyListeners();
    } catch (e) {
      print(e);
      if (e is FirebaseException && e.code == 'object-not-found') {
        await _firebaseService.removeUserLogo();
        this.logoUrl = null;
        notifyListeners();
      }
      setBusyForObject('file_remove', false);
    }
  }
}
