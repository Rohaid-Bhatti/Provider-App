import 'package:flutter/material.dart';
import 'package:provider_app/screens/order_detail_screen.dart';

class OrderCard extends StatelessWidget {
  final String serviceName;
  final String customerName;
  final String date;
  final String time;
  final String status;
  final String price;
  final String description;
  final String provider;
  final String bookingId;
  final bool showBottomSheet;
  final String lat;
  final String lng;
  final String providerId;
  final String userId;

  const OrderCard({
    super.key,
    required this.serviceName,
    required this.customerName,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
    required this.description,
    required this.provider,
    required this.showBottomSheet,
    required this.bookingId,
    required this.lat,
    required this.lng,
    required this.providerId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: const Text(
          'Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: $serviceName'),
            Text('Customer: $customerName'),
            Text('Date & Time: $date, $time'),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: getStatusColor(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // Handle order tap
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(
                        serviceName: serviceName,
                        customerName: customerName,
                        date: date,
                        time: time,
                        status: status,
                        provider: provider,
                        description: description,
                        price: price,
                        showBottomSheet: showBottomSheet,
                        bookingId: bookingId,
                        lat: lat,
                        lng: lng,
                        providerId: providerId,
                        userId: userId,
                      )));
        },
      ),
    );
  }

  Color getStatusColor() {
    if (status == 'In Progress') {
      return Colors.orange;
    } else if (status == 'Pending') {
      return Colors.blue;
    } else if (status == 'Completed') {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
