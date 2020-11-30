import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_design/core/collection_names.dart';
import 'package:daily_design/core/locator.dart';
import 'package:daily_design/models/ad_model.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/frame_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/models/user_data_model.dart';
import 'package:disposables/disposables.dart';

import 'auth_service.dart';

class FirebaseService implements Disposable {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = locator<AuthService>();

  @override
  void dispose() {
    isDisposed = true;
  }

  @override
  bool isDisposed = false;

  Stream<List<AdModel>> getAds() {
    return _firestore
        .collection(CollectionNames.ads)
        .where('active', isEqualTo: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<AdModel>>.fromHandlers(
          handleData: (QuerySnapshot data, EventSink sink) {
            var docs = data.docs.map((e) => AdModel.fromJson(e.data(), e.reference)).toList();
            sink.add(docs);
          },
          handleError: (error, stacktrace, sink) {},
          handleDone: (sink) {},
        ));
  }

  getVersion() async {
    String version = (await _firestore.collection(CollectionNames.version).get()).docs[0].data()['version'];
    return version;
  }

  Stream<List<GraphicsModel>> getGraphics() {
    return _firestore
        .collection(CollectionNames.graphics)
        .where('active', isEqualTo: true)
        .where('public', isEqualTo: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<GraphicsModel>>.fromHandlers(
          handleData: (QuerySnapshot data, EventSink sink) {
            var docs = data.docs.map((e) => GraphicsModel.fromJson(e.data(), e.reference)).toList();
            sink.add(docs);
          },
          handleError: (error, stacktrace, sink) {},
          handleDone: (sink) {},
        ));
  }

  Stream<List<GraphicsModel>> getFeaturedGraphics() {
    return _firestore
        .collection(CollectionNames.graphics)
        .where('active', isEqualTo: true)
        .where('public', isEqualTo: true)
        .where('featured', isEqualTo: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<GraphicsModel>>.fromHandlers(
          handleData: (QuerySnapshot data, EventSink sink) {
            var docs = data.docs.map((e) => GraphicsModel.fromJson(e.data(), e.reference)).toList();
            sink.add(docs);
          },
          handleError: (error, stacktrace, sink) {},
          handleDone: (sink) {},
        ));
  }

  Stream<List<GraphicsModel>> getGraphicsByCategory(CategoryModel categoryModel) {
    return _firestore
        .collection(CollectionNames.graphics)
        .where('active', isEqualTo: true)
        .where('public', isEqualTo: true)
        .where('category', arrayContains: categoryModel.ref.id)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<GraphicsModel>>.fromHandlers(
          handleData: (QuerySnapshot data, EventSink sink) {
            var docs = data.docs.map((e) => GraphicsModel.fromJson(e.data(), e.reference)).toList();
            sink.add(docs);
          },
          handleError: (error, stacktrace, sink) {},
          handleDone: (sink) {},
        ));
  }

  changeUserLogo(String path) async {
    await _firestore
        .doc('users/' + _authService.fbUserStatic.uid)
        .set({'logo_path': path}, SetOptions(mergeFields: ['logo_path']));
  }

  removeUserLogo() async {
    await _firestore
        .doc('users/' + _authService.fbUserStatic.uid)
        .set({'logo_path': null}, SetOptions(mergeFields: ['logo_path']));
  }

  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection(CollectionNames.categories)
        .where('active', isEqualTo: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<CategoryModel>>.fromHandlers(
          handleData: (QuerySnapshot data, EventSink sink) {
            var docs = data.docs.map((e) => CategoryModel.fromJson(e.data(), e.reference)).toList();
            sink.add(docs);
          },
          handleError: (error, stacktrace, sink) {},
          handleDone: (sink) {},
        ));
  }

  Stream<List<FrameModel>> getFrames() {
    return _firestore
        .collection(CollectionNames.frames)
        .where('active', isEqualTo: true)
        .where('public', isEqualTo: true)
        .snapshots()
        .transform(StreamTransformer<QuerySnapshot, List<FrameModel>>.fromHandlers(
          handleData: (QuerySnapshot data, EventSink sink) {
            var docs = data.docs.map((e) => FrameModel.fromJson(e.data(), e.reference)).toList();
            docs..sort((a, b) => a.name.compareTo(b.name));
            sink.add(docs);
          },
          handleError: (error, stacktrace, sink) {},
          handleDone: (sink) {},
        ));
  }

  Future<List<String>> getIndustry() async {
    try {
      List<String> data = [];
      (await _firestore.collection(CollectionNames.industry).get()).docs.forEach((element) {
        data.add(element.data()['name']);
      });
      data.sort((a, b) => a.compareTo(b));
      return data;
    } catch (e) {
      return [];
    }
  }

  updateUserData(UserDataModel dataModel) async {
    await _firestore.doc('users/' + _authService.fbUserStatic.uid).set(
        dataModel.toJsonData(),
        SetOptions(mergeFields: [
          'email',
          'uid',
          'mobile',
          'address',
          'logo_path',
          'name',
          'companyName',
          'companyType',
          'website',
          'facebook_url',
          'instagram_url',
        ]));
  }

  reduceCredits(int amount) async {
    await _firestore.doc('users/' + _authService.fbUserStatic.uid).set(
        {"remaining_graphics": (int.parse(_authService.userStatic.remainingGraphics) - amount).toString()},
        SetOptions(mergeFields: ['remaining_graphics']));
  }
}
