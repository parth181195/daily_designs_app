import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disposables/disposables.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService implements Disposable {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
  }

  createToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  init() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        // _navigateToItemDetail(message);
      },
    );
  }

  createTokenAndAddToUser(uid) async {
    String token = await createToken();
    try {
      DocumentReference documentReference = _firestore.doc('users/$uid');
      await documentReference.set({"fcm_token": token}, SetOptions(mergeFields: ['fcm_token']));
      return true;
    } catch (e) {
      return false;
    }
  }
}
