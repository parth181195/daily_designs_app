import 'package:action_broadcast/action_broadcast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_design/core/locator.dart';
import 'package:daily_design/models/login_request_model.dart';
import 'package:daily_design/models/sign_up_request_model.dart';
import 'package:daily_design/models/user_data_model.dart';
import 'package:daily_design/services/messaging_service.dart';
import 'package:disposables/disposables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthService implements Disposable {
  StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final MessagingService _messagingService = locator<MessagingService>();
  final FirebaseAuth _fbAUth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(signInOption: SignInOption.standard);
  Set<String> _kIds = {'d_d_1_y', 'd_d_1_m', 't_prod'};
  ProductDetailsResponse productDetailsResponse;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserDataModel _userStatic;
  InAppPurchaseConnection inAppPurchaseInstance = InAppPurchaseConnection.instance;

  QueryPurchaseDetailsResponse purchases;

  Stream<User> get fbUser => _fbAUth.userChanges();

  User get fbUserStatic {
    return _fbAUth.currentUser;
  }

  UserDataModel get userStatic => _userStatic;

  @override
  void dispose() {
    isDisposed = true;
  }

  logout() async {
    await _fbAUth.signOut();
    return true;
  }

  loginWithOtp(
    String number, {
    Function verificationCompleted,
    Function verificationFailed,
    Function codeSent,
    Function codeAutoRetrievalTimeout,
  }) async {
    try {
      UserCredential userCredential;
      return await _fbAUth.verifyPhoneNumber(
        phoneNumber: '+91' + number,
        autoRetrievedSmsCodeForTesting: '111111',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print(credential);
          userCredential = await _fbAUth.signInWithCredential(credential);
          SignUpRequestModel dataModel = SignUpRequestModel(
              instagramUrl: null,
              facebookUrl: null,
              companyType: null,
              companyName: null,
              address: null,
              mobile: number,
              loginDetails: null);
          verificationCompleted();
          await createUserObjectInDb(userCredential.user, dataModel);
          _snackbarService.showSnackbar(message: 'Phone Number Verified');
        },
        verificationFailed: (FirebaseAuthException e) {
          _snackbarService.showSnackbar(message: 'Phone Number Verification Failed');
          verificationFailed();
        },
        codeSent: (String verificationId, int resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {
          _snackbarService.showSnackbar(message: 'Not able to verify OTP in allowed time! Please try again');
          codeAutoRetrievalTimeout();
          print(verificationId);
        },
      );
      // GoogleAuthCredential credential = GoogleAuthProvider.credential(
      //     accessToken: signInAuthentication.accessToken, idToken: signInAuthentication.idToken);
      //
      // UserCredential userCredential = await _fbAUth.signInWithCredential(credential);

    } catch (e) {
      print(e);
    }
  }

  loginWithGoogle() async {
    try {
      GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication signInAuthentication = await googleAccount.authentication;
      List<String> methods = await _fbAUth.fetchSignInMethodsForEmail(googleAccount.email);
      if (methods.indexOf('google') == -1) {
        GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: signInAuthentication.accessToken, idToken: signInAuthentication.idToken);

        UserCredential userCredential = await _fbAUth.signInWithCredential(credential);
        SignUpRequestModel dataModel = SignUpRequestModel(
            instagramUrl: null,
            facebookUrl: null,
            companyType: null,
            companyName: null,
            address: null,
            mobile: null,
            loginDetails: LoginRequestModel(email: googleAccount.email));
        await createUserObjectInDb(userCredential.user, dataModel);

        return userCredential.user;
      } else {
        GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: signInAuthentication.accessToken, idToken: signInAuthentication.idToken);
        UserCredential userCredential = await _fbAUth.signInWithCredential(credential);
        await getUserObjectFromDb(userCredential.user.uid);
        return userCredential.user;
      }
    } catch (e) {
      print(e);
    }
  }

  loginWithFacebook() async {}

  login(LoginRequestModel model) async {
    try {
      List<String> methods = await _fbAUth.fetchSignInMethodsForEmail(model.email);
      print(methods);
      if (methods.indexOf('password') != -1) {
        UserCredential userCredential =
            await _fbAUth.signInWithEmailAndPassword(email: model.email, password: model.password);
        await getUserObjectFromDb(userCredential.user.uid);
        return userCredential.user;
      }
    } catch (e) {
      print(e);

      return null;
    }
    return null;
  }

  getUserObjectFromDb(uid) async {
    if (_purchaseSubscription == null) {
      final Stream purchaseUpdates = inAppPurchaseInstance.purchaseUpdatedStream;
      productDetailsResponse = await inAppPurchaseInstance.queryProductDetails(_kIds);
      purchases = await inAppPurchaseInstance.queryPastPurchases();
      _purchaseSubscription = purchaseUpdates.listen((purchases) {
        purchases = purchases;
      });
    }
    _firestore.doc('users/$uid').snapshots().listen((event) {
      _userStatic = UserDataModel.fromJson(event.data(), fbUserStatic);
    });
  }

  getUserObjectFromDbAsFuture(uid) async {
    var data = await _firestore.doc('users/$uid').get();

    _userStatic = UserDataModel.fromJson(data.data(), fbUserStatic);
    return _userStatic;
  }

  checkUserObjectFromDb(uid) async {
    DocumentSnapshot documentSnapshot = await _firestore.doc('users/$uid').get();
    if (documentSnapshot.exists) {
      return true;
    }
    return false;
  }

  createUserObjectInDb(User user, SignUpRequestModel model) async {
    try {
      QuerySnapshot list = await _firestore.collection('users').where('email', isEqualTo: user.email).get();
      UserDataModel dataModel = UserDataModel(
          user: user,
          plan: 'trial',
          name: model.name,
          remainingGraphics: '50',
          mobile: model.mobile,
          address: model.address,
          companyName: model.companyName,
          companyType: model.companyType,
          facebookUrl: model.facebookUrl,
          instagramUrl: model.instagramUrl);
      if (list.docs.isEmpty) {
        DocumentReference documentReference = _firestore.doc('users/${user.uid}');
        await documentReference.set(dataModel.toJson());
        _userStatic = dataModel;
      } else {
        list.docs.forEach((element) async {
          element.reference.delete();
        });
        DocumentReference documentReference = _firestore.doc('users/${user.uid}');
        _userStatic = dataModel;
        await documentReference.set(dataModel.toJson());
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  signUp(SignUpRequestModel model) async {
    try {
      List<String> methods = await _fbAUth.fetchSignInMethodsForEmail(model.loginDetails.email);
      print(methods);
      if (methods.indexOf('password') == -1) {
        UserCredential userCredential = await _fbAUth.createUserWithEmailAndPassword(
            email: model.loginDetails.email, password: model.loginDetails.password);
        await createUserObjectInDb(userCredential.user, model);
        await _messagingService.createTokenAndAddToUser(userCredential.user.uid);
        return userCredential.user;
      } else if (methods.length != 0) {
        _snackbarService.showSnackbar(message: 'User already exists Please login');
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  @override
  bool isDisposed = false;
}
