import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider_app/const/firebase_const.dart';
import 'package:provider_app/controller/auth_controller.dart';
import 'package:provider_app/screens/dashboard_screen.dart';
import 'package:provider_app/screens/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var controller = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var yearOfExperience = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpassController = TextEditingController();
  var priceController = TextEditingController();

  /*final List<String> services = [
    'Service A',
    'Service B',
    'Service C',
    'Service D',
  ];*/
  List<String> services = [];
  String? selectedService;
  bool isTermsAccepted = false;
  bool isPasswordVisible = false;

  /*Future<void> fetchServices() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('categories').get();
      services = snapshot.docs
          .map((doc) => (doc.data() != null && (doc.data() as Map<String, dynamic>)['categoryName'] != null)
          ? (doc.data() as Map<String, dynamic>)['categoryName'] as String
          : '')
          .toList();
    } catch (e) {
      // Handle error
      print('Error fetching services: $e');
    }
  }*/

  Future<List<String>> fetchDropdownItems() async {
    final CollectionReference itemsCollection =
    firestore.collection('categories');

    final QuerySnapshot snapshot = await itemsCollection.get();

    // Extract the data from the snapshot
    final List<String> items = snapshot.docs
        .map((DocumentSnapshot doc) => (doc.data() as Map<String, dynamic>)['categoryName'] as String)
        .toList();

    return items;
  }

  /*@override
  void initState() {
    super.initState();
    fetchServices();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{3,}$');
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid name(Min. 3 Character)");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      nameController.text = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Please Enter a valid email");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      emailController.text = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^(?:[+0]9)?[0-9]{11}$');
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Please enter valid mobile number");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneController.text = value!;
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  ),
                  const SizedBox(height: 12.0),
                  FutureBuilder<List<String>>(
                    future: fetchDropdownItems(),
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return /*CircularProgressIndicator();*/Text('Loading....');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final List<String> items = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          value: selectedService,
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? selectedItem) {
                            setState(() {
                              selectedService = selectedItem;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Service',
                            prefixIcon: const Icon(Icons.category_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a service';
                            }
                            return null;
                          },
                        );
                      }
                    },
                  ),
                  /*DropdownButtonFormField(
                    value: selectedService,
                    onChanged: (value) {
                      setState(() {
                        selectedService = value!;
                      });
                    },
                    items: services.map((service) {
                      return DropdownMenuItem(
                        value: service,
                        child: Text(service),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Service',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a service';
                      }
                      return null;
                    },
                  ),*/
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: yearOfExperience,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Years of Experience',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your years of experience';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      yearOfExperience.text = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: priceController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Price of Service',
                      prefixIcon: const Icon(Icons.price_change_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your price';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      priceController.text = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password(Min. 6 Character)");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      passwordController.text = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: confirmpassController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (confirmpassController.text !=
                          passwordController.text) {
                        return "Password don't match";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      confirmpassController.text = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Checkbox(
                        value: isTermsAccepted,
                        onChanged: (value) {
                          setState(() {
                            isTermsAccepted = value!;
                          });
                        },
                      ),
                      const Row(
                        children: [
                          Text(
                            'I agree to the ',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Text(
                            'Terms of Service',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(
                            ' & ',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  controller.isLoading.value
                      ? SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                      )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (isTermsAccepted) {
                                // Handle registration logic
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                                controller.isLoading(true);
                                try {
                                  await controller
                                      .signupMethod(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) {
                                    return controller.storeUserData(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phoneNumber: phoneController.text,
                                      price: priceController.text,
                                      service: selectedService,
                                      experience: yearOfExperience.text,
                                    );
                                  }).then((value) {
                                    Fluttertoast.showToast(
                                      msg: "Account created successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 14,
                                    );
                                    Get.offAll(DashboardScreen());
                                    controller.isLoading(false);
                                  });
                                } catch (e) {
                                  auth.signOut();
                                  Fluttertoast.showToast(
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 14,
                                  );
                                  controller.isLoading(false);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Terms and Conditions'),
                                      content: const Text(
                                          'Please accept the Terms of Service & Privacy Policy.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
