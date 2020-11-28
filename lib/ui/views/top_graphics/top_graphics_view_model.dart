import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TopGraphicsViewModel extends BaseViewModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<CategoryModel> categories = [];

  List<GraphicsModel> featuredPosts = [];

  init() {
    getPosts();
  }

  getPosts() {
    _firebaseService.getGraphics().listen((event) {
      featuredPosts = event;
      notifyListeners();
      print(event);
    });
  }

  goToCategories() {
    _navigationService.navigateTo(Routes.categoriesView);
  }

  getCategories() {
    _firebaseService.getCategories().listen((event) {
      categories = event;
      notifyListeners();
      print(event);
    });
  }

  goToFrameSelection(GraphicsModel data) {
    _navigationService.navigateTo(Routes.framesView, arguments: FramesViewArguments(graphicsModel: data));
  }
}
