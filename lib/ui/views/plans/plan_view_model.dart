import 'dart:async';

import 'package:daily_design/core/locator.dart';
import 'package:daily_design/models/user_data_model.dart';
import 'package:daily_design/services/auth_service.dart';
import 'package:daily_design/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PlansViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  ProductDetailsResponse productDetailsResponse;
  List<ProductDetails> productDetailsSub = [];

  List<ProductDetails> productDetailsAddons = [];

  InAppPurchaseConnection inAppPurchaseInstance = InAppPurchaseConnection.instance;
  QueryPurchaseDetailsResponse purchases;
  Set<String> _kIds = {'d_d_1_y', 'd_d_1_m', 'credits_10', 'credits_30', 'credits_50'};

  StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  User get user => _authService.fbUserStatic;

  UserDataModel userData;

  init() async {
    setBusyForObject('init', true);
    productDetailsSub = [];
    productDetailsAddons = [];
    userData = await _authService.getUserObjectFromDbAsFuture(user.uid);
    final Stream purchaseUpdates = inAppPurchaseInstance.purchaseUpdatedStream;
    productDetailsResponse = await inAppPurchaseInstance.queryProductDetails(_kIds);
    productDetailsResponse.productDetails.forEach((element) {
      if (element.skuDetail.type == SkuType.subs) {
        productDetailsSub.add(element);
      } else {
        productDetailsAddons.add(element);
      }
    });
    purchases = await inAppPurchaseInstance.queryPastPurchases();
    _purchaseSubscription = purchaseUpdates.listen((purchases) {
      purchases = purchases;
    });
    setBusyForObject('init', false);
  }

  purchaseProduct(ProductDetails productDetails) async {
    if (productDetails.skuDetail.type == SkuType.subs) {
      bool success = await inAppPurchaseInstance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: productDetails, sandboxTesting: true),
      );
      if (success) {}
    } else {
      bool success = await inAppPurchaseInstance.buyConsumable(
          purchaseParam: PurchaseParam(productDetails: productDetails, sandboxTesting: true, ), autoConsume: true);
      if (success) {}
    }
  }
}
