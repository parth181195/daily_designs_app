import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CategoriesViewModel extends BaseViewModel {
  FirebaseService _firebaseService = locator<FirebaseService>();

  NavigationService _navigationService = locator<NavigationService>();
  List<CategoryModel> _categories = [];
  String searchString = '';

  List<CategoryModel> get categories {
    List<CategoryModel> toReturn =
    _categories.where((element) => element.name.toLowerCase().contains(searchString.toLowerCase())).toList();
    toReturn.sort((a, b) => a.name.compareTo(b.name));
    return toReturn;
  }

  init() {
    getCategories();
  }

  filter(CategoryModel categoryModel) {
    _navigationService.navigateTo(
        Routes.filteredGraphicsView, arguments: FilteredGraphicsViewArguments(categoryModel: categoryModel));
  }

  getCategories() {
    _firebaseService.getCategories().listen((event) {
      _categories = event;
      notifyListeners();
      print(event);
    });
  }

  search(q) {
    searchString = q;
    notifyListeners();
  }
}
