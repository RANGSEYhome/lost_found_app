import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Core
import 'package:lost_found_app/core/constants/app_text_style.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:url_launcher/url_launcher.dart';
// Modules
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';

class PostDetailScreen extends StatefulWidget {
  final Doc item;
  PostDetailScreen(this.item);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Language _lang;
  late int _langIndex;

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
 DateTime dateTime = DateTime.parse(widget.item.date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _lang.postDetail,
          style: const TextStyle(
            fontSize: AppTextSizes.headline2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.item.images,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                widget.item.title ?? "No Title",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    widget.item.location ?? "No Location",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue, size: 18),
                  const SizedBox(width: 6),
                  Text(
                     widget.item.phone ?? "No Phone number",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                "Description:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                widget.item.description ?? "No description available.",
                style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Center(
  child: ElevatedButton.icon(
    onPressed: () async {
      final Uri phoneUri = Uri(scheme: 'tel', path: widget.item.phone);
      if (await canLaunch(phoneUri.toString())) {
        await launch(phoneUri.toString());
      } else {
        // Handle the error, maybe show a dialog or a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    },
    icon: const Icon(Icons.message, color: Colors.white),
    label: const Text("Contact Owner"),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
