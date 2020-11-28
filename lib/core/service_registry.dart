import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/messaging_service.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:daily_design/services/firebase_service.dart';

@module
abstract class ServiceRegistry {
  @lazySingleton
  NavigationService get navigationService;

  @lazySingleton
  FirebaseService get firebaseService;

  @lazySingleton
  AuthService get authService;

  @lazySingleton
  MessagingService get messagingService;

  @lazySingleton
  SnackbarService get snackBar;

  @lazySingleton
  DialogService get dialog;
}
