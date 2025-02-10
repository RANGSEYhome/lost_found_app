import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

// Core
import 'package:lost_found_app/core/constants/app_text_style.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';

// Modules
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';

class PostDetailScreen extends StatefulWidget {
  // final PostGetDataModel item;
  // const PostDetailScreen(this.item, {super.key});

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
      body: Text("Text")
      
      // SingleChildScrollView(
      //   physics: const BouncingScrollPhysics(),
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         // Book Image
      //         Center(
      //           child: ClipRRect(
      //             borderRadius: BorderRadius.circular(8),
      //             child: Image.network(
      //               widget.item. ?? '', // Ensure no null errors
      //               height: 300,
      //               fit: BoxFit.cover,
      //               errorBuilder: (context, error, stackTrace) =>
      //                   const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      //             ),
      //           ),
      //         ),
      //         const SizedBox(height: 16),

      //         // Title
      //         Text(
      //           widget.item.title ?? "No Title",
      //           style: const TextStyle(
      //             fontSize: 24,
      //             fontWeight: FontWeight.bold,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //         const SizedBox(height: 8),

      //         // Price (or Description as placeholder)
      //         Text(
      //           "USD ${widget.item.description ?? 'N/A'}",
      //           style: const TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.w600,
      //             color: Colors.teal,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //         const SizedBox(height: 16),

      //         // Rating
      //         const SizedBox(height: 16),

      //         // Description
      //         const Text(
      //           "Description:",
      //           style: TextStyle(
      //             fontSize: 18,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         const SizedBox(height: 8),

      //         Text(
      //           widget.item.description ?? "No description available.",
      //           style: const TextStyle(fontSize: 16, height: 1.5),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
