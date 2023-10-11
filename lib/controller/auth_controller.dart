import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider_app/const/firebase_const.dart';

class AuthController extends GetxController {

  var isLoading = false.obs;

  //signin method
  Future<UserCredential?> loginMethod({email, password}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16,
      );
    }
    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
    return userCredential;
  }

  //storing data method
  storeUserData({name, password, email, phoneNumber, service, price, experience}) async {
    DocumentReference store = firestore.collection(providersCollection).doc(currentUser!.uid);
    store.set({
      'providerName' : name,
      'providerPassword' : password,
      'providerEmail' : email,
      'providerImage' : '',
      'providerNumber' : phoneNumber,
      'providerPrice' : price,
      'categoryName' : service,
      'providerDes' : '',
      'providerExperience' : experience,
      'uid' : currentUser!.uid,
    });
  }

  //signout
  signoutMethod() async {
    try{
      await auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }
}