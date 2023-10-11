import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider_app/const/firebase_const.dart';
import 'package:provider_app/widgets/order_card_widget.dart';

class HistoryOrderTab extends StatefulWidget {
  const HistoryOrderTab({Key? key}) : super(key: key);

  @override
  State<HistoryOrderTab> createState() => _HistoryOrderTabState();
}

class _HistoryOrderTabState extends State<HistoryOrderTab> {
  String? userId;
  QuerySnapshot? querySnapshot;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // for getting active booking data after matching id
  Future<void> fetchData() async {
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

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
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox(
            height: 200, child: Center(child: CircularProgressIndicator()))
        : querySnapshot!.size == 0
            ? const Center(
                child: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No booking history'),
                      ],
                    )))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: querySnapshot!.docs.length,
                  itemBuilder: (context, index) {
                    final document = querySnapshot!.docs[index];
                    return OrderCard(
                      serviceName: document['categoryName'],
                      customerName: document['userName'],
                      date: document['bookingDate'],
                      time: document['bookingTime'],
                      status: document['bookingStatus'],
                      price: document['providerPrice'],
                      description: document['providerDes'],
                      provider: document['providerName'],
                      showBottomSheet: false,
                      bookingId: document['bookingId'],
                      lat: document['latitude'],
                      lng: document['longitude'],
                      providerId: document['providerId'],
                      userId: document['userId'],
                    );
                  },
                ),
              );
  }
}
