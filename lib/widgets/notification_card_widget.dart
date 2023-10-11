import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool read;

  const NotificationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.read,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      elevation: 2.0,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            icon,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: TextStyle(
            color: read ? Colors.grey : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        /*onTap: () {
          // Handle notification tap
        },*/
      ),
    );
  }
}