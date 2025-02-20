import 'package:flutter/material.dart';

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Terms & Privacy Policy'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Terms of Service'),
              Tab(text: 'Privacy Policy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TermsOfService(),
            PrivacyPolicy(),
          ],
        ),
      ),
    );
  }
}

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Text(
          '''Terms of Service
          
Last Updated: [Date]

1. Introduction
Welcome to Lost & Found! By using our app, you agree to these terms.

2. User Responsibilities
- You must provide accurate information.
- You must not misuse the platform.

3. Liability
Lost & Found is not responsible for any damages from using this app.

4. Changes to Terms
We may update these terms from time to time.

For full details, visit our website.''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Text(
          '''Privacy Policy
          
Last Updated: [Date]

1. Information We Collect
- Personal data such as name, email.
- Location data for lost item tracking.

2. How We Use Your Data
- To connect users and help retrieve lost items.

3. Security Measures
We take precautions to protect your data.

4. Changes to Privacy Policy
We may update this policy periodically.

For full details, visit our website.''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
