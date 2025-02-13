import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_detail_screen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart'
    as postGet;
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:provider/provider.dart';
class PostByCategory extends StatefulWidget {
   final String category; // Declare a final variable
   const PostByCategory(this.category, {Key? key}) : super(key: key); 
  //String categori="";

  @override
  State<PostByCategory> createState() => _PostByCategoryState();
}

class _PostByCategoryState extends State<PostByCategory> {
  @override
  Widget build(BuildContext context) {
    Language _lang = Khmer();
    _lang = context.watch<LanguageLogic>().lang;
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: _buildBody(_lang),
      floatingActionButton: _showUpButton ? _buildUpButton() : null,
    );
  }

    final ScrollController _scroller = ScrollController();
  bool _showUpButton = false; // Controls visibility of the "scroll to top" button
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(_scrollListener); // Add scroll listener
     context.read<PostLogic>().searchByCategory(widget.category, widget.category);// Fetch posts on init
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


  // Build the "scroll to top" button
  Widget _buildUpButton() {
    return FloatingActionButton(
      child: Icon(Icons.arrow_upward),
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
  bool loadingMore = context.watch<PostLogic>().loadingMore; // Get loadingMore state
  List<postGet.Doc> records = context.watch<PostLogic>().postSearchCagetoryModel;

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
          itemCount: records.length + (loadingMore ? 1 : 0), // Add an extra item for the loading indicator
          itemBuilder: (context, index) {
            if (index >= records.length) {
              // Show a loading indicator at the bottom
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
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
//       side: BorderSide(color: AppColors.primaryColor, width: 1),
//     ),
//     child: Stack(
//       children: [
//         ListTile(
//           leading: Image.network(
//             item.images,
//             width: 100,
//             height: 100,
//             fit: BoxFit.cover,
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
//               CupertinoPageRoute(builder: (context) => PostDetailScreen(item)),
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

Widget _buildPostItem(postGet.Doc item) {
    DateTime dateTime = DateTime.parse(item.date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return Card(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        // Use GestureDetector to capture tap events
        onTap: () {
          // Navigate to post detail screen
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => PostDetailScreen(item)),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.images,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text("At: ${item.location}"),
                        Text(
                          "Description: ${item.description}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Date: ${formattedDate}"),
                        SizedBox(height: 8),
                        Text(
                            "By: ${item.userId.firstname} ${item.userId.lastname}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // "LOST" or "FOUND" label at the top-right
            Positioned(
              right: 12,
              top: 12,
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