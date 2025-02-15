import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  // Email function
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@lostandfound.com',
      queryParameters: {'subject': 'Support Request'},
    );
    await launchUrl(emailUri);
  }

  // Phone call function
  void _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+1234567890');
    await launchUrl(phoneUri);
  }

  // Website function
  void _openWebsite() async {
    final Uri websiteUri = Uri.parse('https://www.lostandfound.com');
    await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.support_agent, size: 100, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Need Help? Get in touch with us!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Email Button
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Email Support'),
              onPressed: _sendEmail,
            ),

            // Phone Button
            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text('Call Us'),
              onPressed: _makePhoneCall,
            ),

            // Website Button
            ElevatedButton.icon(
              icon: const Icon(Icons.public),
              label: const Text('Visit Our Website'),
              onPressed: _openWebsite,
            ),

            const Spacer(),

            // Social Media Links
            const Text(
              'Follow us on social media',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  onPressed: () async {
                    await launchUrl(Uri.parse('https://facebook.com/lostandfound'));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.link, color: Colors.blueAccent),
                  onPressed: _openWebsite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}