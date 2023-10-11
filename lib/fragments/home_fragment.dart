import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider_app/const/firebase_const.dart';
import 'package:provider_app/screens/order_detail_screen.dart';
import 'package:provider_app/services/notification_services.dart';
import 'package:http/http.dart' as http;

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  NotificationServices notificationServices = NotificationServices();

  String? userId;
  String? category;
  String? experience;
  String? userName;
  QuerySnapshot? querySnapshot;
  QuerySnapshot? querySnapshot1;
  bool isLoading = true;
  bool isLoading1 = true;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchData();
    fetchPendingData();
    notificationServices.requestNotificationPermission();
    notificationServices.isTokenRefresh();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.forgroundMessage();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  // for getting current logged in service provider data
  void getUserData() async {
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

      DocumentSnapshot snapshot =
          await firestore.collection('serviceProvider').doc(userId).get();

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          experience = userData['providerExperience'];
          category = userData['categoryName'];
          userName = userData['providerName'];
        });
      } else {
        print('User data does not exist');
      }
    }
  }

  // for getting history booking data after matching id
  Future<void> fetchData() async {
    // Query the collection based on the field match
    final QuerySnapshot snapshot = await firestore
        .collection('lastBooking')
        .where('providerId', isEqualTo: userId)
        .get();

    setState(() {
      querySnapshot = snapshot;
      isLoading = false;
    });
  }

  //for updating the booking status
  void updateBookingStatus(String documentId) async {
    try {
      await firestore
          .collection('activeBooking')
          .doc(documentId)
          .update({'bookingStatus': 'In Progress'});

      // Refresh the pending data after the update
      fetchPendingData();
    } catch (error) {
      print('Error updating booking status: $error');
    }
  }

  // for showing the dialog box for updating
  void showUpdateConfirmationDialog(String documentId, String userId) {
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
              updateBookingStatus(documentId);

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

  // for cancelling the booking
  void moveDataToLastBooking(String documentId) async {
    try {
      final DocumentSnapshot snapshot =
          await firestore.collection('activeBooking').doc(documentId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        // Update the 'bookingStatus' field to 'Cancelled'
        data['bookingStatus'] = 'Cancelled';

        // Move the document to the 'lastBooking' collection
        final CollectionReference lastBookingCollection =
            firestore.collection('lastBooking');
        await lastBookingCollection.doc(documentId).set(data);

        // Delete the document from the 'activeBooking' collection
        await firestore.collection('activeBooking').doc(documentId).delete();

        // Refresh the pending data after the move
        fetchPendingData();
      }
    } catch (error) {
      print('Error moving data to last booking: $error');
    }
  }

  // for showing alert box for cancellation
  void showCancelConfirmationDialog(String documentId, String userId) {
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
              moveDataToLastBooking(documentId);

              // testing code for the notifications
              notificationServices
                  .getDeviceTokenFromFirestore(userId)
                  .then((value) async {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'notification': {
                    'title': 'Booking Rejected',
                    'body':
                    'Your booking has been rejected.',
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

  // for get active pending data after matching both
  Future<void> fetchPendingData() async {
    // Query the collection based on the two field matches
    final QuerySnapshot snapshot = await firestore
        .collection('activeBooking')
        .where('providerId', isEqualTo: userId)
        .where('bookingStatus', isEqualTo: 'Pending')
        .get();

    setState(() {
      querySnapshot1 = snapshot;
      isLoading1 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white),),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${userName ?? 'Loading...'}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: _buildServiceItem(
                      'Service',
                      category ?? 'Loading....',
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: _buildServiceItem(
                      'Years of Experience',
                      experience ?? 'Loading....',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'History Bookings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 12,
              ),
              isLoading
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()))
                  : querySnapshot!.size == 0
                      ? const Center(
                          child: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No previous booking'),
                                ],
                              )))
                      : SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: querySnapshot!.docs.length > 3
                                ? 3
                                : querySnapshot!.docs.length,
                            itemBuilder: (context, index) {
                              final document = querySnapshot!.docs[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4.0,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          document['categoryName'],
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          document['userName'],
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Icon(Icons.payment,
                                                color: Colors.grey[700]),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              'Payment: \$${document['providerPrice']}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Icon(Icons.query_stats,
                                                color: Colors.grey[700]),
                                            const SizedBox(width: 8.0),
                                            Text(
                                              'Status: ${document['bookingStatus']}',
                                              style: const TextStyle(
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle button press
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailScreen(
                                                          serviceName: document[
                                                              'categoryName'],
                                                          customerName:
                                                              document[
                                                                  'userName'],
                                                          date: document[
                                                              'bookingDate'],
                                                          time: document[
                                                              'bookingTime'],
                                                          status: document[
                                                              'bookingStatus'],
                                                          description: document[
                                                              'providerDes'],
                                                          provider: document[
                                                              'providerName'],
                                                          price: document[
                                                              'providerPrice'],
                                                          showBottomSheet:
                                                              false,
                                                          bookingId: document[
                                                              'bookingId'],
                                                          lat: document[
                                                              'latitude'],
                                                          lng: document[
                                                              'longitude'],
                                                          providerId: document[
                                                              'providerId'],
                                                          userId: document[
                                                              'userId'],
                                                        )));
                                          },
                                          child: const Text('View Details'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Pendings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                height: 12,
              ),
              isLoading1
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()))
                  : querySnapshot1!.size == 0
                      ? const Center(
                          child: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('No pending requests'),
                                ],
                              )))
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: querySnapshot1!.docs.length > 5
                              ? 5
                              : querySnapshot1!.docs.length,
                          itemBuilder: (context, index) {
                            final document1 = querySnapshot1!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document1['categoryName'],
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        document1['providerName'],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Icon(
                                              Icons
                                                  .supervised_user_circle_outlined,
                                              color: Colors.grey[700]),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'User: ${document1['userName']}',
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Handle button press
                                              showUpdateConfirmationDialog(
                                                  document1['bookingId'], document1['userId']);

                                              // testing code for the notifications
                                              /*notificationServices
                                                  .getDeviceToken()
                                                  .then((value) async {
                                                var data = {
                                                  'to': value.toString(),
                                                  'priority': 'high',
                                                  'notification': {
                                                    'title': 'New Booking',
                                                    'body':
                                                        'Someone booked your service.',
                                                    "sound":
                                                        "jetsons_doorbell.mp3"
                                                  },
                                                  'android': {
                                                    'notification': {
                                                      'notification_count': 23,
                                                    },
                                                  },
                                                  'data': {
                                                    'type': 'msj',
                                                    'id': '123456'
                                                  }
                                                };
                                                await http.post(
                                                    Uri.parse(
                                                        'https://fcm.googleapis.com/fcm/send'),
                                                    body: jsonEncode(data),
                                                    headers: {
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                      'Authorization':
                                                          'key=AAAA-cJPiX4:APA91bHNB-AV_UHvuiraRHkDfxMNPVcO9khkuOFUTFOqQ75cjY2MS7-z3EOxuh52Z3-4sH9Y4FY5kufrFEieV-4OIRgsW6DSO-FHwu89ZPfBPDzZA9T8dQIL_0i4MLkUUT3DilIFCpb8'
                                                    }).then((value) {
                                                  if (kDebugMode) {
                                                    print(
                                                        value.body.toString());
                                                  }
                                                }).onError((error, stackTrace) {
                                                  if (kDebugMode) {
                                                    print(error);
                                                  }
                                                });
                                              });*/
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                            ),
                                            child: const Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Handle button press
                                              showCancelConfirmationDialog(
                                                  document1['bookingId'], document1['userId']);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text(
                                              'Reject',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(String text, String title) {
    return GestureDetector(
      onTap: () {
        // Handle service item tap
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
