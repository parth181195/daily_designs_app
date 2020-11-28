import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/frame_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FrameSelectionViewModel extends BaseViewModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<CategoryModel> categories = [];

  List<FrameModel> frames = [];

  init() {
    getFrames();
  }

  goToFrame(GraphicsModel graphicsModel, FrameModel frameModel) {
    _navigationService.navigateTo(Routes.framesView,
        arguments: FramesViewArguments(graphicsModel: graphicsModel, frameModel: frameModel));
  }

  getFrames() {
    _firebaseService.getFrames().listen((event) {
      frames = event;
      notifyListeners();
      print(event);
    });
  }
}
