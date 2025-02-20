import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    _launchURL(params.toString());
  }

  void _launchPhone(String phoneNumber) async {
    _launchURL('tel:$phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Us Section
            Text(
              'You can contact us through',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Email Us'),
              subtitle: Text('support@lostfound.com'),
              onTap: () => _launchEmail('support@lostfound.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text('Call Us'),
              subtitle: Text('+1 234 567 890'),
              onTap: () => _launchPhone('+1234567890'),
            ),

            SizedBox(height: 24),

            // Support Us Section
            Text(
              'Support us through',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1280px-QR_code_for_mobile_English_Wikipedia.svg.png', // Replace with your QR code image
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bank Account: 123-456-789',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Footer Section
            Center(
              child: Column(
                children: [
                  Text(
                    'Follow Us',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook,
                            color: Colors.blue),
                        onPressed: () =>
                            _launchURL('https://facebook.com/lostfoundapp'),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.instagram,
                            color: Colors.purple),
                        onPressed: () =>
                            _launchURL('https://instagram.com/lostfoundapp'),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.twitter,
                            color: Colors.blue),
                        onPressed: () =>
                            _launchURL('https://twitter.com/lostfoundapp'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '© 2025 Lost & Found. All rights reserved.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
