import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lost & Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Lost & Found is a community-driven platform that helps reconnect people with their lost belongings. '
              'Our goal is to make the process of reporting, tracking, and recovering lost items as easy and efficient as possible.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We aim to create a reliable and accessible space where users can help each other find lost valuables with ease and trust.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Developers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '- LONG Ratha\n'
              '- YOU Chongeang\n'
              '- HENG Rangsey',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Center(
              child: Column(
                children: [
                  Text(
                    'Find Us on Social Media',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.github),
                        onPressed: () =>
                            _launchURL('https://github.com/#'),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.linkedin),
                        onPressed: () =>
                            _launchURL('https://linkedin.com/in/#'),
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.twitter),
                        onPressed: () =>
                            _launchURL('https://twitter.com/#'),
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
