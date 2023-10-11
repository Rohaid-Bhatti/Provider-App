import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider_app/const/firebase_const.dart';

//get users data
class FirestoreServices {
  static getUser(uid) {
    return firestore.collection(providersCollection).where('uid', isEqualTo: uid).snapshots();
  }
}