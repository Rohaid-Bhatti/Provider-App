import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final String address = '2832 Alameda St, Vernon, CA 90058, USA';
  final String phone = '+1 123-456-7890';

  Future<void> _sendEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'yasinusama414@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Contact Us',
      }),
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  Future<void> _openMaps() async {
    final Uri mapsLaunchUri = Uri(
      scheme: 'https',
      host: 'maps.google.com',
      query: 'q=$address',
    );

    if (await canLaunch(mapsLaunchUri.toString())) {
      await launch(mapsLaunchUri.toString());
    } else {
      throw 'Could not launch $mapsLaunchUri';
    }
  }

  Future<void> _callPhone() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await canLaunch(phoneLaunchUri.toString())) {
      await launch(phoneLaunchUri.toString());
    } else {
      throw 'Could not launch phone dialer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        leading: BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('123 Main Street, City'),
                subtitle: Text('Country'),
                onTap: () {
                  _openMaps();
                },
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1 123-456-7890'),
                onTap: () {
                  _callPhone();
                },
              ),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text('contact@example.com'),
                onTap: () async {
                  _sendEmail();
                },
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
