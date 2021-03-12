import 'dart:typed_data';

import 'package:daily_design/core/locator.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/frame_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/models/user_data_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FrameViewModel extends BaseViewModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  AuthService authService = locator<AuthService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  List<CategoryModel> categories = [];
  int activeFrame = 0;

  User get user => authService.fbUserStatic;

  UserDataModel get userStatic => authService.userStatic;
  FirebaseStorage storage = FirebaseStorage.instance;
  String imageUrl = '';
  String frameUrl = '';
  String logoUrl = '';
  bool useName = false;
  Uint8List image = Uint8List.fromList([]);
  Uint8List frame = Uint8List.fromList([]);
  Uint8List logo = Uint8List.fromList([]);
  List<FrameModel> frames = [];

  init({FrameModel frameModel, GraphicsModel graphicsModel}) async {
    if (userStatic.logoPath == null) {
      _snackbarService.showSnackbar(message: 'Please Update Logo in Settings');
    }
    frameUrl = await storage.ref(frames[0].path).getDownloadURL();
    imageUrl = await storage.ref(graphicsModel.path).getDownloadURL();
    if (userStatic.logoPath != null) {
      logoUrl = await storage.ref(userStatic.logoPath).getDownloadURL();
      logo = await networkImageToByte(logoUrl);
    } else {
      useName = true;
    }
    frame = await networkImageToByte(frameUrl);
    image = await networkImageToByte(imageUrl);
    setBusy(false);
    notifyListeners();
  }

  getFrames({FrameModel frameModel, GraphicsModel graphicsModel}) {
    setBusy(true);
    _firebaseService.getFrames().listen((event) async {
      frames = event;
      notifyListeners();
      print(event);
      await init(frameModel: frameModel, graphicsModel: graphicsModel);
    });
  }

  reduceCredits(int amount) async {
    await _firebaseService.reduceCredits(amount);
  }

  changeSelectedFrame(FrameModel frameModel, index) async {
    setBusy(true);
    frameUrl = await storage.ref(frameModel.path).getDownloadURL();
    frame = await networkImageToByte(frameUrl);
    activeFrame = index;
    setBusy(false);
    notifyListeners();
  }

  showTrialFinishDiag() async {
    await _dialogService.showDialog(
      title: 'Credits Over',
      description: 'Thanks for using Daily Designs. For further help contact on +919409250794',
      barrierDismissible: true,
    );
  }

  showFinishDiag(int amount) async {
    return _dialogService.showDialog(
      title: 'Confirm Download',
      description: 'After Download you will have ${int.parse(userStatic.remainingGraphics) - amount} Credits',
      barrierDismissible: true,
    );
  }
}
