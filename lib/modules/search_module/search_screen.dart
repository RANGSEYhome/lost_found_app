import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/modules/post_detail_module/post_detail_screen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:provider/provider.dart';
// core
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/themes/theme_logic.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    return Scaffold(
      appBar: AppBar(title: Text("Search Screen")),
      body: Column(
        children: [
          _buildSearchBox(context),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  /// **Search Box Widget**
  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _lang.search,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              if (_searchController.text.isNotEmpty) {
                await context
                    .read<PostLogic>()
                    .search(_searchController.text.trim());
              }
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onSubmitted: (query) async {
          if (query.isNotEmpty) {
            await context.read<PostLogic>().search(query.trim());
          }
        },
      ),
    );
  }

  /// **Display Search Results**
  Widget _buildSearchResults() {
    return Consumer<PostLogic>(
      builder: (context, postLogic, child) {
        // Check if no search has been conducted yet
        if (postLogic.postSearchModel.isEmpty &&
            _searchController.text.isEmpty) {
          return Center(child: Text("Enter a search query to see results"));
        }

        // If search is done but no results found
        if (postLogic.postModel.isEmpty) {
          return Center(child: Text("No results found"));
        }

        return ListView.builder(
          itemCount: postLogic.postSearchModel.length,
          itemBuilder: (context, index) {
            final item = postLogic.postSearchModel[index];
            DateTime dateTime = DateTime.parse(item.date);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            return Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                // side: BorderSide(color: AppColors.primaryColor, width: 1),
              ),
              child: Stack(
                children: [
                  ListTile(
                    leading: Image.network(
                      item.images,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("At: ${item.location}"),
                        Text(
                          "Description: ${item.description}",
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis, // Ensures text is truncated
                        ),
                        Text("Date: ${formattedDate}"),
                      ],
                    ),
                    onTap: () {
                      // Navigate to post detail screen
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => PostDetailScreen(item)),
                      );
                    },
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Text(
                      item.type.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: item.type == "lost" ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Text(
                        "By: ${item.userId.firstname} ${item.userId.lastname}"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
