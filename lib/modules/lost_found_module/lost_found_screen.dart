import 'package:flutter/material.dart';
// import 'package:flutter_rating_stars/flutter_rating_stars.dart';
// import 'package:lost_found_app/core/constants/app_text_style.dart';
// import 'package:lost_found_app/core/utils/widget_util.dart';
// import 'package:lost_found_app/modules/basic_module/demo_screen.dart';
// import 'package:lost_found_app/modules/home_module/book_data.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_create_screen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart'
    as postGet;
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/modules/post_detail_module/post_detail_screen.dart';
import 'package:intl/intl.dart';

class LostFoundScreen extends StatefulWidget {
  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  final ScrollController _scroller = ScrollController();
  bool _showUpButton =
      false; // Controls visibility of the "scroll to top" button
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(_scrollListener); // Add scroll listener
    context.read<PostLogic>().read(); // Fetch posts on init
  }

  @override
  void dispose() {
    _scroller.removeListener(_scrollListener); // Remove scroll listener
    super.dispose();
  }

  // Scroll listener to detect scroll position
  void _scrollListener() {
    setState(() {
      // Show the "scroll to top" button if the user has scrolled past 100 pixels
      if (_scroller.hasClients && _scroller.position.pixels > 100) {
        _showUpButton = true;
      } else {
        _showUpButton = false;
      }

      // Load more posts if the user reaches the bottom of the list
      if (_scroller.hasClients &&
          _scroller.position.pixels == _scroller.position.maxScrollExtent) {
        page++;
        context.read<PostLogic>().readAppend(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Language _lang = Khmer();
    _lang = context.watch<LanguageLogic>().lang;

    return Scaffold(
      body: _buildBody(_lang),
      floatingActionButton:
          _showUpButton ? _buildUpButton() : null, // Show button conditionally
    );
  }

  // Build the "scroll to top" button
  Widget _buildUpButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryColor,
      child: Icon(Icons.arrow_upward, color: Colors.white),
      onPressed: () {
        _scroller.animateTo(
          0.0, // Scroll to the top
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  // Build the main body of the screen
  Widget _buildBody(Language _lang) {
    Object? error = context.watch<PostLogic>().error;
    bool loading = context.watch<PostLogic>().loading;
    List<postGet.Doc> records = context.watch<PostLogic>().postModel;

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _buildErrorMessage(error);
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scroller, // Attach the ScrollController
            itemCount: records.length,
            itemBuilder: (context, index) {
              return _buildPostItem(records[index]);
            },
          ),
        ),
      ],
    );
  }

  // Build an error message widget
  Widget _buildErrorMessage(Object error) {
    debugPrint(error.toString());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 50),
          Text('${error.toString()}'),
          ElevatedButton(
            onPressed: () {
              context.read<PostLogic>().setLoading();
              context.read<PostLogic>().read();
            },
            child: Text("RETRY"),
          ),
        ],
      ),
    );
  }

  // Build a single post item
  // Widget _buildPostItem(postGet.Doc item) {
  //   DateTime dateTime = DateTime.parse(item.date);
  //   String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  //   return Card(
  //     margin: EdgeInsets.all(10),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8),
  //       // side: BorderSide(color: AppColors.primaryColor, width: 1),
  //     ),
  //     child: Stack(
  //       children: [
  //         ListTile(
  //           leading: ClipRRect(
  //             borderRadius:
  //                 BorderRadius.circular(8), // Adjust the radius as needed
  //             child: Image.network(
  //               item.images,
  //               width: 100,
  //               height: 300,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           title: Text(
  //             item.title,
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 2,
  //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //           ),
  //           subtitle: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text("At: ${item.location}"),
  //               Text(
  //                 "Description: ${item.description}",
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis, // Ensures text is truncated
  //               ),
  //               Text("Date: ${formattedDate}"),
  //             ],
  //           ),
  //           onTap: () {
  //             // Navigate to post detail screen
  //             Navigator.of(context).push(
  //               CupertinoPageRoute(
  //                   builder: (context) => PostDetailScreen(item)),
  //             );
  //           },
  //         ),
  //         Positioned(
  //           right: 10,
  //           top: 10,
  //           child: Text(
  //             "${item.type.toUpperCase()}",
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //               color: item.type == "lost" ? Colors.red : Colors.green,
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           right: 10,
  //           bottom: 10,
  //           child: Text("By: ${item.userId.firstname} ${item.userId.lastname}"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildPostItem(postGet.Doc item) {
  //   DateTime dateTime = DateTime.parse(item.date);
  //   String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  //   return Card(
  //     margin: EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 4),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: GestureDetector(
  //       // Use GestureDetector to capture tap events
  //       onTap: () {
  //         // Navigate to post detail screen
  //         Navigator.of(context).push(
  //           CupertinoPageRoute(builder: (context) => PostDetailScreen(item)),
  //         );
  //       },
  //       child: Stack(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.all(12),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(12),
  //                   child: Image.network(
  //                     item.images,
  //                     width: 160,
  //                     height: 160,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 SizedBox(width: 12),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         item.title,
  //                         overflow: TextOverflow.ellipsis,
  //                         maxLines: 2,
  //                         style: TextStyle(
  //                             fontSize: 16, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(height: 6),
  //                       Text("At: ${item.location}"),
  //                       Text(
  //                         "Description: ${item.description}",
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       Text("Date: ${formattedDate}"),
  //                       SizedBox(height: 8),
  //                       Text(
  //                           "By: ${item.userId.firstname} ${item.userId.lastname}"),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // "LOST" or "FOUND" label at the top-right
  //           Positioned(
  //             right: 12,
  //             top: 12,
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: item.type == "lost" ? Colors.red : Colors.green,
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Text(
  //                 item.type == "lost" ? "LOST" : "FOUND",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPostItem(postGet.Doc item) {
  //   DateTime dateTime = DateTime.parse(item.date);
  //   String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  //   return Card(
  //     margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     elevation: 2, // Subtle shadow for depth
  //     child: GestureDetector(
  //       onTap: () {
  //         // Navigate to post detail screen
  //         Navigator.of(context).push(
  //           CupertinoPageRoute(builder: (context) => PostDetailScreen(item)),
  //         );
  //       },
  //       child: Stack(
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Header with user info
  //               Padding(
  //                 padding: EdgeInsets.all(12),
  //                 child: Row(
  //                   children: [
  //                     // User's name without profile image
  //                     Expanded(
  //                       child: Text(
  //                         "${item.userId.firstname} ${item.userId.lastname}",
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ),
  //                     Text(
  //                       formattedDate,
  //                       style: TextStyle(color: Colors.grey[600]),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               // Post image
  //               ClipRRect(
  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  //                 child: Image.network(
  //                   item.images,
  //                   width: double.infinity, // Full width
  //                   height: 220, // Height for the image
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               // Post content
  //               Padding(
  //                 padding: EdgeInsets.all(12), // Padding for content
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Title
  //                     Text(
  //                       item.title,
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 2,
  //                       style: TextStyle(
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                     SizedBox(height: 6), // Spacing
  //                     // Description
  //                     Text(
  //                       item.description,
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
  //                     ),
  //                     SizedBox(height: 6),
  //                     // Location
  //                     if (item.location.isNotEmpty)
  //                       Text(
  //                         "📍 ${item.location}",
  //                         style:
  //                             TextStyle(fontSize: 14, color: Colors.grey[600]),
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           // "LOST" or "FOUND" label at the bottom-right of the card
  //           Positioned(
  //             right: 16,
  //             bottom: 16,
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //               decoration: BoxDecoration(
  //                 color: item.type == "lost" ? Colors.red : Colors.green,
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Text(
  //                 item.type == "lost" ? "LOST" : "FOUND",
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildPostItem(postGet.Doc item) {
    DateTime dateTime = DateTime.parse(item.date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    final String profileImage = item.userId.profilePic.isNotEmpty
        ? item.userId.profilePic
        : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'; // Default profile image

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2, // Subtle shadow for depth
      child: GestureDetector(
        onTap: () {
          // Navigate to post detail screen
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => PostDetailScreen(item)),
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with user info
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // User's profile image
                      CircleAvatar(
                        backgroundImage: NetworkImage(profileImage),
                        radius: 20, // Radius for the profile image
                      ),
                      SizedBox(width: 8), // Spacing between image and name
                      Expanded(
                        child: Text(
                          "${item.userId.firstname} ${item.userId.lastname}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Post image
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    item.images,
                    width: double.infinity, // Full width
                    height: 220, // Height for the image
                    fit: BoxFit.cover,
                  ),
                ),
                // Post content
                Padding(
                  padding: EdgeInsets.all(12), // Padding for content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6), // Spacing
                      // Description
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 6),
                      // Location
                      if (item.location.isNotEmpty)
                        Text(
                          "📍 ${item.location}",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // "LOST" or "FOUND" label at the bottom-right of the card
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.type == "lost" ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.type == "lost" ? "LOST" : "FOUND",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
