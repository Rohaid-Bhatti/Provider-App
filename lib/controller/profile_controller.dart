import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider_app/const/firebase_const.dart';

class ProfileController extends GetxController {
  var profileImgPath = ''.obs;
  var profileImageLink = '';
  var isLoading = false.obs;

  //textField
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var serviceController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();

  changeImage() async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14,
      );
    }
  }

  uploadProfileImage() async {
    var fileName = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$fileName';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, email, phoneNumber, description, experience, price, image}) async {
    var store = firestore.collection(providersCollection).doc(currentUser!.uid);
    await store.set({
      'providerName' : name,
      'providerEmail' : email,
      'providerNumber' : phoneNumber,
      'providerDes' : description,
      'providerExperience' : experience,
      'providerPrice' : price,
      'providerImage' : image,
    }, SetOptions(merge: true));
    isLoading(false);
  }
}
