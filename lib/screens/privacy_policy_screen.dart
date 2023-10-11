import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: TextStyle(color: Colors.white,),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        leading: BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrivacyPolicySection(
                  title: 'Information We Collect',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Praesent accumsan dolor et quam tincidunt, eu tristique turpis dignissim.',
                ),
                PrivacyPolicySection(
                  title: 'How We Use Information',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Praesent accumsan dolor et quam tincidunt, eu tristique turpis dignissim.',
                ),
                PrivacyPolicySection(
                  title: 'Data Security',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Praesent accumsan dolor et quam tincidunt, eu tristique turpis dignissim.',
                ),
                PrivacyPolicySection(
                  title: 'Your Choices',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Praesent accumsan dolor et quam tincidunt, eu tristique turpis dignissim.',
                ),
                PrivacyPolicySection(
                  title: 'Changes to this Privacy Policy',
                  content:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Praesent accumsan dolor et quam tincidunt, eu tristique turpis dignissim.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicySection extends StatelessWidget {
  final String title;
  final String content;

  PrivacyPolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          content,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        SizedBox(height: 24.0),
      ],
    );
  }
}
