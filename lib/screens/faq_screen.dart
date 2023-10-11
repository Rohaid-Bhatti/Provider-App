import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        leading: BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        children: [
          FAQCard(
            question: 'How do I create an account?',
            answer:
            'To create an account, click on the "Sign Up" button and follow the instructions.',
          ),
          FAQCard(
            question: 'How do I book a service?',
            answer:
            'To book a service, navigate to the services page, select the desired service, select your location, and click on the "Book Now" button.',
          ),
          FAQCard(
            question: 'How can I edit my profile information?',
            answer:
            'To edit your profile information, go to the profile page and click on the "Account Information" button.',
          ),
          FAQCard(
            question: 'How do I view my booking history?',
            answer:
            'To view your booking history, go to the history page and all your previous bookings will be displayed.',
          ),
          FAQCard(
            question: 'What should I do if I need to cancel a booking?',
            answer:
            'If you need to cancel a booking, go to the booking details page and click on the "Cancel Booking" button.',
          ),
        ],
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final String question;
  final String answer;

  FAQCard({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}