import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/ad_model.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  FirebaseService _firebaseService = locator<FirebaseService>();
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<CategoryModel> categories = [];

  List<GraphicsModel> featuredPosts = [];
  List<AdModel> featuredAds = [];

  init() {
    getPosts();
    getAds();
    getCategories();
  }

  getPosts() {
    _firebaseService.getFeaturedGraphics().listen((event) {
      featuredPosts = event.sublist(0, event.length >= 6 ? 6 : event.length);
      notifyListeners();
      print(event);
    });
  }

  logout() async {
    await _authService.logout();
    _navigationService.navigateTo(Routes.splashView);
  }

  getAds() {
    _firebaseService.getAds().listen((event) {
      featuredAds = event;
      notifyListeners();
      print(event);
    });
  }

  goToCategories() {
    _navigationService.navigateTo(Routes.categoriesView);
  }

  goToGraphics() {
    _navigationService.navigateTo(Routes.topGraphicsView);
  }

  goToFrameSelection(GraphicsModel data) {
    _navigationService.navigateTo(Routes.framesView, arguments: FramesViewArguments(graphicsModel: data));
  }

  filter(CategoryModel categoryModel) {
    _navigationService.navigateTo(Routes.filteredGraphicsView,
        arguments: FilteredGraphicsViewArguments(categoryModel: categoryModel));
  }

  filterWithCatId(String id) {
    CategoryModel categoryModel = categories.where((element) => element.ref.id == id).first;
    _navigationService.navigateTo(Routes.filteredGraphicsView,
        arguments: FilteredGraphicsViewArguments(categoryModel: categoryModel));
  }

  getCategories() {
    _firebaseService.getCategories().listen((event) {
      categories = event;
      notifyListeners();
      print(event);
    });
  }
}
