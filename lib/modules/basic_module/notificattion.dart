import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lost_found_app/modules/login_module/NotificationModel.dart';
import 'dart:convert';

import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // Access the user ID from the provider
      final responseModel = context.read<FakestoreLoginLogic>().responseModel;
      final userId = responseModel.user!.id;
      final url = 'https://d-api.devkrc.com/v1/block/getnotification?userId=$userId';

      final response = await http.get(Uri.parse(url));

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data is List) {
          // Convert JSON data to NotificationModel objects
          final List<NotificationModel> fetchedNotifications = data
              .map((json) => NotificationModel.fromJson(json))
              .toList();

          setState(() {
            notifications = fetchedNotifications;
            isLoading = false;
          });
        } else {
          throw Exception('Invalid data format: Expected a list');
        }
      } else {
        throw Exception('Failed to load notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMessage')),
      );
    }
  }

  void _showNotificationDetails(NotificationModel notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the bottom sheet to take up more space
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notification.postTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Reason: ${notification.reason}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Description: ${notification.postDescription}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Category: ${notification.postCategory}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Location: ${notification.postLocation}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Date: ${notification.createdDate}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (notification.postImages != null)
                  Image.network(
                    notification.postImages,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : notifications.isEmpty
                  ? const Center(child: Text('No notifications available'))
                  : ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: notification.postImages != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(notification.postImages),
                                  )
                                : const CircleAvatar(
                                    child: Icon(Icons.image_not_supported),
                                  ),
                            title: Text(notification.postTitle),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(notification.reason),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${notification.createdDate}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () {
                              _showNotificationDetails(notification);
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}