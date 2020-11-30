// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/frame_model.dart';
import '../models/graphics_model.dart';
import '../ui/views/categories/categories_view.dart';
import '../ui/views/filterd_graphics/filterd_graphics_view.dart';
import '../ui/views/frame/frame_view.dart';
import '../ui/views/frame_selection_view/frame_selection_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/logo_settings/logo_settings_view.dart';
import '../ui/views/plans/plan_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/settings/settings_view.dart';
import '../ui/views/sign_up/sign_up_view.dart';
import '../ui/views/splash/splash_view.dart';
import '../ui/views/top_graphics/top_graphics_view.dart';
import 'router.dart';

class Routes {
  static const String splashView = '/';
  static const String loginView = '/login-view';
  static const String signUpView = '/sign-up-view';
  static const String categoriesView = '/categories-view';
  static const String settingsView = '/settings-view';
  static const String plansView = '/plans-view';
  static const String logoSettingsView = '/logo-settings-view';
  static const String topGraphicsView = '/top-graphics-view';
  static const String frameSelectionView = '/frame-selection-view';
  static const String framesView = '/frames-view';
  static const String profileView = '/profile-view';
  static const String filteredGraphicsView = '/filtered-graphics-view';
  static const String homeView = '/home-view';
  static const all = <String>{
    splashView,
    loginView,
    signUpView,
    categoriesView,
    settingsView,
    plansView,
    logoSettingsView,
    topGraphicsView,
    frameSelectionView,
    framesView,
    profileView,
    filteredGraphicsView,
    homeView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.signUpView, page: SignUpView),
    RouteDef(Routes.categoriesView, page: CategoriesView, guards: [AuthGuard]),
    RouteDef(Routes.settingsView, page: SettingsView, guards: [AuthGuard]),
    RouteDef(Routes.plansView, page: PlansView, guards: [AuthGuard]),
    RouteDef(Routes.logoSettingsView,
        page: LogoSettingsView, guards: [AuthGuard]),
    RouteDef(Routes.topGraphicsView,
        page: TopGraphicsView, guards: [AuthGuard]),
    RouteDef(Routes.frameSelectionView,
        page: FrameSelectionView, guards: [AuthGuard]),
    RouteDef(Routes.framesView, page: FramesView, guards: [AuthGuard]),
    RouteDef(Routes.profileView, page: ProfileView, guards: [AuthGuard]),
    RouteDef(Routes.filteredGraphicsView,
        page: FilteredGraphicsView, guards: [AuthGuard]),
    RouteDef(Routes.homeView, page: HomeView, guards: [AuthGuard]),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashView: (data) {
      final args = data.getArgs<SplashViewArguments>(
        orElse: () => SplashViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashView(key: args.key),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    SignUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignUpView(),
        settings: data,
      );
    },
    CategoriesView: (data) {
      final args = data.getArgs<CategoriesViewArguments>(
        orElse: () => CategoriesViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => CategoriesView(key: args.key),
        settings: data,
      );
    },
    SettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SettingsView(),
        settings: data,
      );
    },
    PlansView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PlansView(),
        settings: data,
      );
    },
    LogoSettingsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LogoSettingsView(),
        settings: data,
      );
    },
    TopGraphicsView: (data) {
      final args = data.getArgs<TopGraphicsViewArguments>(
        orElse: () => TopGraphicsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => TopGraphicsView(key: args.key),
        settings: data,
      );
    },
    FrameSelectionView: (data) {
      final args = data.getArgs<FrameSelectionViewArguments>(
        orElse: () => FrameSelectionViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => FrameSelectionView(
          key: args.key,
          graphicsModel: args.graphicsModel,
        ),
        settings: data,
      );
    },
    FramesView: (data) {
      final args = data.getArgs<FramesViewArguments>(
        orElse: () => FramesViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => FramesView(
          key: args.key,
          frameModel: args.frameModel,
          graphicsModel: args.graphicsModel,
        ),
        settings: data,
      );
    },
    ProfileView: (data) {
      final args = data.getArgs<ProfileViewArguments>(
        orElse: () => ProfileViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ProfileView(key: args.key),
        settings: data,
      );
    },
    FilteredGraphicsView: (data) {
      final args = data.getArgs<FilteredGraphicsViewArguments>(
        orElse: () => FilteredGraphicsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => FilteredGraphicsView(
          key: args.key,
          categoryModel: args.categoryModel,
        ),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// SplashView arguments holder class
class SplashViewArguments {
  final Key key;
  SplashViewArguments({this.key});
}

/// CategoriesView arguments holder class
class CategoriesViewArguments {
  final Key key;
  CategoriesViewArguments({this.key});
}

/// TopGraphicsView arguments holder class
class TopGraphicsViewArguments {
  final Key key;
  TopGraphicsViewArguments({this.key});
}

/// FrameSelectionView arguments holder class
class FrameSelectionViewArguments {
  final Key key;
  final GraphicsModel graphicsModel;
  FrameSelectionViewArguments({this.key, this.graphicsModel});
}

/// FramesView arguments holder class
class FramesViewArguments {
  final Key key;
  final FrameModel frameModel;
  final GraphicsModel graphicsModel;
  FramesViewArguments({this.key, this.frameModel, this.graphicsModel});
}

/// ProfileView arguments holder class
class ProfileViewArguments {
  final Key key;
  ProfileViewArguments({this.key});
}

/// FilteredGraphicsView arguments holder class
class FilteredGraphicsViewArguments {
  final Key key;
  final CategoryModel categoryModel;
  FilteredGraphicsViewArguments({this.key, this.categoryModel});
}
