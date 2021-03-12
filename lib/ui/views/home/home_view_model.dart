import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/ad_model.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/models/industry_model.dart';
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
  IndustryModel userIndustry;

  init() async {
    getPosts();
    getAds();
    getCategories();
    await getUserIndustry();
    _authService.getUserObjectFromDbAsStream(_authService.fbUserStatic.uid).listen((user) async {
      getPosts();
      getAds();
      getCategories();
      await getUserIndustry();
    });
  }

  getPosts() {
    _firebaseService.getFeaturedGraphics().listen((event) {
      featuredPosts = event.sublist(0, event.length >= 9 ? 9 : event.length);
      // featuredPosts = event.sublist(0, event.length >= 6 ? event.length : event.length);
      notifyListeners();
      print(event);
    });
  }

  getUserIndustry() async {
    if (_authService.userStatic.companyType != null) {
      userIndustry = await _firebaseService.getIndustryFromId(_authService.userStatic.companyType);
      notifyListeners();
    }
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

  getFestivalCategories() {
    return categories.where((element) => element.group == 'Festival').toList();
  }

  getGeneralCategories() {
    return categories.where((element) => element.group == 'General').toList();
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
