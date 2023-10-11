import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider_app/const/firebase_const.dart';
import 'package:provider_app/screens/active_order_tab.dart';
import 'package:provider_app/services/notification_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class OrderDetailScreen extends StatefulWidget {
  final String serviceName;
  final String customerName;
  final String date;
  final String time;
  final String status;
  final String description;
  final String provider;
  final String price;
  final String bookingId;
  final bool showBottomSheet;
  final String lat;
  final String lng;
  final String providerId;
  final String userId;

  const OrderDetailScreen({
    Key? key,
    required this.serviceName,
    required this.customerName,
    required this.date,
    required this.time,
    required this.status,
    required this.description,
    required this.provider,
    required this.price,
    required this.showBottomSheet,
    required this.bookingId,
    required this.lat,
    required this.lng,
    required this.providerId,
    required this.userId,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  NotificationServices notificationServices = NotificationServices();

  String? bottomSheetButton1Text;
  String? bottomSheetButton2Text;

  @override
  void initState() {
    super.initState();
    setBottomSheetButtons();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.forgroundMessage();
  }

  // for changing the text of the button in bottom Sheet
  void setBottomSheetButtons() {
    if (widget.status == 'Pending') {
      bottomSheetButton1Text = 'Accept';
      bottomSheetButton2Text = 'Reject';
    } else if (widget.status == 'In Progress') {
      bottomSheetButton1Text = 'Completed';
      bottomSheetButton2Text = 'Cancel';
    } else {
      // You can define default behavior for other cases if needed.
      bottomSheetButton1Text = 'Loading...';
      bottomSheetButton2Text = 'Loading...';
    }
  }

  // for showing accept booking dialog
  void showAcceptDialog(String bookingId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Accept Booking'),
        content: const Text('Are you sure you want to accept this booking?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              _acceptOrder(bookingId);
              Navigator.pop(context);
              /*Navigator.popAndPushNamed(
                  context,
                  MaterialPageRoute(builder: (context) => ActiveOrderTab())
                      as String);*/

              // testing code for the notifications
              notificationServices
                  .getDeviceTokenFromFirestore(userId)
                  .then((value) async {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {
                    'title': 'Booking Accepted',
                    'body':
                    'Your booking has been accepted.',
                    "sound":
                    "jetsons_doorbell.mp3"
                  },
                  'android': {
                    'notification': {
                      'notification_count': 23,
                    },
                  },
                  'data' : {
                    'type' : 'msj' ,
                    'id' : '123456'
                  }
                };
                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization' : 'key=AAAA-cJPiX4:APA91bHNB-AV_UHvuiraRHkDfxMNPVcO9khkuOFUTFOqQ75cjY2MS7-z3EOxuh52Z3-4sH9Y4FY5kufrFEieV-4OIRgsW6DSO-FHwu89ZPfBPDzZA9T8dQIL_0i4MLkUUT3DilIFCpb8'
                    }
                ).then((value){
                  if (kDebugMode) {
                    print(value.body.toString());
                  }
                }).onError((error, stackTrace){
                  if (kDebugMode) {
                    print(error);
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }

  // for showing alert box for rejection
  void showRejectDialog(String bookingId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              _rejectOrder(bookingId);
              Navigator.pop(context);

              // testing code for the notifications
              notificationServices
                  .getDeviceTokenFromFirestore(userId)
                  .then((value) async {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {
                    'title': 'Booking Cancelled',
                    'body':
                    'Your booking has been cancelled.',
                    "sound":
                    "jetsons_doorbell.mp3"
                  },
                  'android': {
                    'notification': {
                      'notification_count': 23,
                    },
                  },
                  'data' : {
                    'type' : 'msj' ,
                    'id' : '123456'
                  }
                };
                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization' : 'key=AAAA-cJPiX4:APA91bHNB-AV_UHvuiraRHkDfxMNPVcO9khkuOFUTFOqQ75cjY2MS7-z3EOxuh52Z3-4sH9Y4FY5kufrFEieV-4OIRgsW6DSO-FHwu89ZPfBPDzZA9T8dQIL_0i4MLkUUT3DilIFCpb8'
                    }
                ).then((value){
                  if (kDebugMode) {
                    print(value.body.toString());
                  }
                }).onError((error, stackTrace){
                  if (kDebugMode) {
                    print(error);
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }

  // for showing alert box for completion
  void showCompletionDialog(String bookingId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Complete Booking'),
        content: const Text('Sure you want to mark this booking complete?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
              _markAsCompleted(bookingId);
              Navigator.pop(context);

              // testing code for the notifications
              notificationServices
                  .getDeviceTokenFromFirestore(userId)
                  .then((value) async {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {
                    'title': 'Booking Completed',
                    'body':
                    'Your booking has been marked as complete.',
                    "sound":
                    "jetsons_doorbell.mp3"
                  },
                  'android': {
                    'notification': {
                      'notification_count': 23,
                    },
                  },
                  'data' : {
                    'type' : 'msj' ,
                    'id' : '123456'
                  }
                };
                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization' : 'key=AAAA-cJPiX4:APA91bHNB-AV_UHvuiraRHkDfxMNPVcO9khkuOFUTFOqQ75cjY2MS7-z3EOxuh52Z3-4sH9Y4FY5kufrFEieV-4OIRgsW6DSO-FHwu89ZPfBPDzZA9T8dQIL_0i4MLkUUT3DilIFCpb8'
                    }
                ).then((value){
                  if (kDebugMode) {
                    print(value.body.toString());
                  }
                }).onError((error, stackTrace){
                  if (kDebugMode) {
                    print(error);
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }

  // functions for different status

  // Function to handle "Accept" button press for pending orders
  Future<void> _acceptOrder(String bookingId) async {
    // Implement the logic to handle "Accept" button press for pending orders.
    // For example, you might want to update the order status in the database.
    try {
      await firestore
          .collection('activeBooking')
          .doc(bookingId)
          .update({'bookingStatus': 'In Progress'});
    } catch (error) {
      print('Error updating booking status: $error');
    }
  }

  // Function to handle "Reject" button press for pending orders
  Future<void> _rejectOrder(String bookingId) async {
    // Implement the logic to handle "Reject" button press for pending orders.
    // For example, you might want to update the order status in the database.
    try {
      final DocumentSnapshot snapshot =
          await firestore.collection('activeBooking').doc(bookingId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        // Update the 'bookingStatus' field to 'Cancelled'
        data['bookingStatus'] = 'Cancelled';

        // Move the document to the 'lastBooking' collection
        final CollectionReference lastBookingCollection =
            firestore.collection('lastBooking');
        await lastBookingCollection.doc(bookingId).set(data);

        // Delete the document from the 'activeBooking' collection
        await firestore.collection('activeBooking').doc(bookingId).delete();
      }
    } catch (error) {
      print('Error moving data to last booking: $error');
    }
  }

  // Function to handle "Completed" button press for orders in progress
  Future<void> _markAsCompleted(String bookingId) async {
    // Implement the logic to handle "Completed" button press for orders in progress.
    // For example, you might want to mark the order as completed in the database.
    try {
      final DocumentSnapshot snapshot =
          await firestore.collection('activeBooking').doc(bookingId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        // Update the 'bookingStatus' field to 'Cancelled'
        data['bookingStatus'] = 'Completed';

        // Move the document to the 'lastBooking' collection
        final CollectionReference lastBookingCollection =
            firestore.collection('lastBooking');
        await lastBookingCollection.doc(bookingId).set(data);

        // Delete the document from the 'activeBooking' collection
        await firestore.collection('activeBooking').doc(bookingId).delete();
      }
    } catch (error) {
      print('Error moving data to last booking: $error');
    }
  }

  // Function to handle "Cancel" button press for orders in progress
  /*void _cancelOrder() {
    // Implement the logic to handle "Cancel" button press for orders in progress.
    // For example, you might want to cancel the order and update the status in the database.
  }*/

  // function for opening google maps
  Future<void> openGoogleMaps(double destLatitude, double destLongitude) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destLatitude,$destLongitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    var latitude = double.parse(widget.lat);
    var longitude = double.parse(widget.lng);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Detail',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: BackButton(color: Colors.white),
      ),
      bottomSheet: widget.showBottomSheet
          ? BottomSheet(
              elevation: 10,
              enableDrag: false,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple.shade200,
                            fixedSize: Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height * 0.06),
                          ),
                          child: Text(bottomSheetButton1Text!),
                          onPressed: () {
                            if (widget.status == 'Pending') {
                              showAcceptDialog(widget.bookingId, widget.userId);
                            } else if (widget.status == 'In Progress') {
                              showCompletionDialog(widget.bookingId, widget.userId);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.grey.shade400,
                            fixedSize: Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height * 0.06),
                          ),
                          child: Text(bottomSheetButton2Text!),
                          onPressed: () {
                            if (widget.status == 'Pending') {
                              showRejectDialog(widget.bookingId, widget.userId);
                            } else if (widget.status == 'In Progress') {
                              showRejectDialog(widget.bookingId, widget.userId);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              onClosing: () {},
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Detail',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  /*Text(
                    '#${widget.orderNumber}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),*/
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Service',
                            style: TextStyle(
                              fontSize: 16.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.serviceName,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Customer',
                            style: TextStyle(
                              fontSize: 16.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.customerName,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Date & Time',
                            style: TextStyle(
                              fontSize: 16.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.date}, ${widget.time}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Provider',
                            style: TextStyle(
                              fontSize: 16.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.provider,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Type',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Cash on Delivery',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            '\$${widget.price}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  FloatingActionButton.extended(
                    label: const Text(
                      'Get Location',
                      style: TextStyle(color: Colors.white),
                    ),
                    // <-- Text
                    backgroundColor: Colors.black,
                    icon: const Icon(
                      // <-- Icon
                      Icons.location_searching,
                      size: 24.0,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      openGoogleMaps(latitude, longitude);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getStatusColor() {
    if (widget.status == 'In Progress') {
      return Colors.orange;
    } else if (widget.status == 'Pending') {
      return Colors.blue;
    } else if (widget.status == 'Completed') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
