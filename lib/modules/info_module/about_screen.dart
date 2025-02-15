// import 'package:flutter/material.dart';

// class AboutScreen extends StatelessWidget {
//   const AboutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('About Lost & Found')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // App Logo
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Image.asset(
//                 'lib_assets/images/logo.png', // Replace with your logo path
//                 height: 100,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // App Name
//             const Text(
//               'Lost & Found',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),

//             // App Description
//             const Text(
//               'Lost & Found is a community-driven app that helps users reunite lost items with their rightful owners in real-time.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 16),

//             // Version Info
//             const Text(
//               'Version 1.0.0', // Update as needed
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),

//             // Contact Information
//             ListTile(
//               leading: const Icon(Icons.email),
//               title: const Text('Contact Us'),
//               subtitle: const Text('support@lostandfound.com'),
//               onTap: () {
//                 // Implement email functionality
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.public),
//               title: const Text('Visit Our Website'),
//               subtitle: const Text('www.lostandfound.com'),
//               onTap: () {
//                 // Open website link
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.privacy_tip),
//               title: const Text('Privacy Policy'),
//               onTap: () {
//                 // Navigate to Privacy Policy Page
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.description),
//               title: const Text('Terms of Service'),
//               onTap: () {
//                 // Navigate to Terms Page
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Lost & Found App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text(
              'Lost & Found helps users track and recover lost items effortlessly. '
              'Our mission is to connect people and reunite them with their belongings.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Text(
              'Developed by Rangsey P. Heng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}