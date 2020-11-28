import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:daily_design/core/locator.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/ui/views/categories/categories_view.dart';
import 'package:daily_design/ui/views/filterd_graphics/filterd_graphics_view.dart';
import 'package:daily_design/ui/views/frame/frame_view.dart';
import 'package:daily_design/ui/views/frame_selection_view/frame_selection_view.dart';
import 'package:daily_design/ui/views/home/home_view.dart';
import 'package:daily_design/ui/views/login/login_view.dart';
import 'package:daily_design/ui/views/profile/profile_view.dart';
import 'package:daily_design/ui/views/sign_up/sign_up_view.dart';
import 'package:daily_design/ui/views/splash/splash_view.dart';
import 'package:daily_design/ui/views/top_graphics/top_graphics_view.dart';

@MaterialAutoRouter(routes: [
  MaterialRoute(page: SplashView, initial: true),
  MaterialRoute(page: LoginView),
  MaterialRoute(page: SignUpView),
  MaterialRoute(page: CategoriesView, guards: [AuthGuard]),
  MaterialRoute(page: TopGraphicsView, guards: [AuthGuard]),
  MaterialRoute(page: FrameSelectionView, guards: [AuthGuard]),
  MaterialRoute(page: FramesView, guards: [AuthGuard]),
  MaterialRoute(page: ProfileView, guards: [AuthGuard]),
  MaterialRoute(page: FilteredGraphicsView, guards: [AuthGuard]),
  MaterialRoute(page: HomeView, guards: [AuthGuard]),
])
class $Router {}

class AuthGuard extends RouteGuard {
  final AuthService _authService = locator<AuthService>();

  @override
  Future<bool> canNavigate(ExtendedNavigatorState navigator, String routeName, Object arguments) async {
    return _authService.fbUserStatic != null;
  }
}
