import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider_app/controller/profile_controller.dart';

class AccountUpdate extends StatefulWidget {
  final dynamic data;

  const AccountUpdate({Key? key, this.data}) : super(key: key);

  @override
  State<AccountUpdate> createState() => _AccountUpdateState();
}

class _AccountUpdateState extends State<AccountUpdate> {
  var controller1 = Get.put(ProfileController());
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.nameController.text = widget.data['providerName'];
    controller.emailController.text = widget.data['providerEmail'];
    controller.phoneController.text = widget.data['providerNumber'];
    controller.serviceController.text = widget.data['providerExperience'];
    controller.priceController.text = widget.data['providerPrice'];
    controller.descriptionController.text = widget.data['providerDes'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Information',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: BackButton(color: Colors.white),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: widget.data['providerImage'] == '' &&
                                controller.profileImgPath.isEmpty
                            ? const Image(
                                image: AssetImage('assets/images/user.png'),
                              )
                            : widget.data['providerImage'] != '' &&
                                    controller.profileImgPath.isEmpty
                                ? Image.network(widget.data['providerImage'])
                                : Image.file(
                                    File(controller.profileImgPath.value),
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Handle profile image edit
                          controller.changeImage();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    // prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    // prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    // prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.serviceController,
                  decoration: const InputDecoration(
                    labelText: 'Experience',
                    // prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    // prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    // prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                    width: 1,
                    color: Colors.black,
                  )),
                  onPressed: () async {
                    // Handle update profile
                    //if image is not selected
                    if (controller.profileImgPath.value.isNotEmpty) {
                      await controller.uploadProfileImage();
                    } else {
                      controller.profileImageLink =
                          widget.data['providerImage'];
                    }

                    await controller.updateProfile(
                      image: controller.profileImageLink,
                      name: controller.nameController.text,
                      email: controller.emailController.text,
                      phoneNumber: controller.phoneController.text,
                      description: controller.descriptionController.text,
                      experience: controller.serviceController.text,
                      price: controller.priceController.text,
                    );
                    Fluttertoast.showToast(msg: "Update successfully");
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
