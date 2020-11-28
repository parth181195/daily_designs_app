// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/messaging_service.dart';
import 'service_registry.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final serviceRegistry = _$ServiceRegistry();
  gh.lazySingleton<AuthService>(() => serviceRegistry.authService);
  gh.lazySingleton<DialogService>(() => serviceRegistry.dialog);
  gh.lazySingleton<FirebaseService>(() => serviceRegistry.firebaseService);
  gh.lazySingleton<MessagingService>(() => serviceRegistry.messagingService);
  gh.lazySingleton<NavigationService>(() => serviceRegistry.navigationService);
  gh.lazySingleton<SnackbarService>(() => serviceRegistry.snackBar);
  return get;
}

class _$ServiceRegistry extends ServiceRegistry {
  @override
  AuthService get authService => AuthService();
  @override
  DialogService get dialog => DialogService();
  @override
  FirebaseService get firebaseService => FirebaseService();
  @override
  MessagingService get messagingService => MessagingService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackBar => SnackbarService();
}
