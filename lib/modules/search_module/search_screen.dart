// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lost_found_app/core/constants/app_colors.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_detail_screen.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
// import 'package:provider/provider.dart';
// // core
// import 'package:lost_found_app/core/localization/lang_data.dart';
// import 'package:lost_found_app/core/localization/lang_logic.dart';
// import 'package:lost_found_app/core/themes/theme_logic.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   Language _lang = Khmer();
//   int _langIndex = 0;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     _lang = context.watch<LanguageLogic>().lang;
//     _langIndex = context.watch<LanguageLogic>().langIndex;
//     return Scaffold(
//       appBar: AppBar(title: Text("Search Screen")),
//       body: Column(
//         children: [
//           _buildSearchBox(context),
//           Expanded(child: _buildSearchResults()),
//         ],
//       ),
//     );
//   }

//   /// **Search Box Widget**
//   Widget _buildSearchBox(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: _lang.search,
//           suffixIcon: IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () async {
//               if (_searchController.text.isNotEmpty) {
//                 await context
//                     .read<PostLogic>()
//                     .search(_searchController.text.trim());
//               }
//             },
//           ),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
//         ),
//         onSubmitted: (query) async {
//           if (query.isNotEmpty) {
//             await context.read<PostLogic>().search(query.trim());
//           }
//         },
//       ),
//     );
//   }

//   // Display Search Results
//   // Widget _buildSearchResults() {
//   //   return Consumer<PostLogic>(
//   //     builder: (context, postLogic, child) {
//   //       // Check if no search has been conducted yet
//   //       if (postLogic.postSearchModel.isEmpty &&
//   //           _searchController.text.isEmpty) {
//   //         return Center(child: Text("Enter a search query to see results"));
//   //       }

//   //       // If search is done but no results found
//   //       if (postLogic.postModel.isEmpty) {
//   //         return Center(child: Text("No results found"));
//   //       }

//   //       return ListView.builder(
//   //         itemCount: postLogic.postSearchModel.length,
//   //         itemBuilder: (context, index) {
//   //           final item = postLogic.postSearchModel[index];
//   //           DateTime dateTime = DateTime.parse(item.date);
//   //           String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
//   //           return Card(
//   //             margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//   //             shape: RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.circular(8),
//   //               // side: BorderSide(color: AppColors.primaryColor, width: 1),
//   //             ),
//   //             child: Stack(
//   //               children: [
//   //                 ListTile(
//   //                   leading: Image.network(
//   //                     item.images,
//   //                     width: 100,
//   //                     height: 100,
//   //                     fit: BoxFit.cover,
//   //                   ),
//   //                   title: Text(
//   //                     item.title,
//   //                     overflow: TextOverflow.ellipsis,
//   //                     maxLines: 2,
//   //                     style:
//   //                         TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//   //                   ),
//   //                   subtitle: Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       Text("At: ${item.location}"),
//   //                       Text(
//   //                         "Description: ${item.description}",
//   //                         maxLines: 1,
//   //                         overflow: TextOverflow
//   //                             .ellipsis, // Ensures text is truncated
//   //                       ),
//   //                       Text("Date: ${formattedDate}"),
//   //                     ],
//   //                   ),
//   //                   onTap: () {
//   //                     // Navigate to post detail screen
//   //                     Navigator.of(context).push(
//   //                       CupertinoPageRoute(
//   //                           builder: (context) => PostDetailScreen(item)),
//   //                     );
//   //                   },
//   //                 ),
//   //                 Positioned(
//   //                   right: 10,
//   //                   top: 10,
//   //                   child: Text(
//   //                     item.type.toUpperCase(),
//   //                     style: TextStyle(
//   //                       fontWeight: FontWeight.bold,
//   //                       fontSize: 12,
//   //                       color: item.type == "lost" ? Colors.red : Colors.green,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 Positioned(
//   //                   right: 10,
//   //                   bottom: 10,
//   //                   child: Text(
//   //                       "By: ${item.userId.firstname} ${item.userId.lastname}"),
//   //                 ),
//   //               ],
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }

//   // Widget _buildSearchResults() {
//   //   return Consumer<PostLogic>(
//   //     builder: (context, postLogic, child) {
//   //       // Check if no search has been conducted yet
//   //       if (postLogic.postSearchModel.isEmpty &&
//   //           _searchController.text.isEmpty) {
//   //         return Center(child: Text("Enter a search query to see results"));
//   //       }

//   //       // If search is done but no results found
//   //       if (postLogic.postModel.isEmpty) {
//   //         return Center(child: Text("No results found"));
//   //       }

//   //       return ListView.builder(
//   //         itemCount: postLogic.postSearchModel.length,
//   //         itemBuilder: (context, index) {
//   //           final item = postLogic.postSearchModel[index];
//   //           DateTime dateTime = DateTime.parse(item.date);
//   //           String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
//   //           return Card(
//   //             margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//   //             shape: RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.circular(
//   //                   12), // Increased radius for a smoother look
//   //               // side: BorderSide(color: AppColors.primaryColor, width: 1),
//   //             ),
//   //             elevation: 4, // Added elevation for a shadow effect
//   //             child: Stack(
//   //               children: [
//   //                 ListTile(
//   //                   leading: ClipRRect(
//   //                     borderRadius: BorderRadius.circular(
//   //                         8), // Rounded corners for the image
//   //                     child: Image.network(
//   //                       item.images,
//   //                       width: 80, // Adjust width for a better fit
//   //                       height: 80, // Adjust height for a better fit
//   //                       fit: BoxFit.cover,
//   //                     ),
//   //                   ),
//   //                   title: Text(
//   //                     item.title,
//   //                     overflow: TextOverflow.ellipsis,
//   //                     maxLines: 2,
//   //                     style:
//   //                         TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//   //                   ),
//   //                   subtitle: Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       Text("At: ${item.location}"),
//   //                       Text(
//   //                         "Description: ${item.description}",
//   //                         maxLines: 1,
//   //                         overflow: TextOverflow
//   //                             .ellipsis, // Ensures text is truncated
//   //                       ),
//   //                       Text("Date: ${formattedDate}"),
//   //                     ],
//   //                   ),
//   //                   onTap: () {
//   //                     // Navigate to post detail screen
//   //                     Navigator.of(context).push(
//   //                       CupertinoPageRoute(
//   //                           builder: (context) => PostDetailScreen(item)),
//   //                     );
//   //                   },
//   //                 ),
//   //                 Positioned(
//   //                   right: 10,
//   //                   top: 10,
//   //                   child: Text(
//   //                     item.type.toUpperCase(),
//   //                     style: TextStyle(
//   //                       fontWeight: FontWeight.bold,
//   //                       fontSize: 12,
//   //                       color: item.type == "lost" ? Colors.red : Colors.green,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 Positioned(
//   //                   right: 10,
//   //                   bottom: 10,
//   //                   child: Text(
//   //                     "By: ${item.userId.firstname} ${item.userId.lastname}",
//   //                     style: TextStyle(
//   //                         fontSize: 12,
//   //                         color: Colors.grey[
//   //                             600]), // Optional: Different color for author
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }

//   Widget _buildSearchResults() {
//     return Consumer<PostLogic>(
//       builder: (context, postLogic, child) {
//         // Check if no search has been conducted yet
//         if (postLogic.postSearchModel.isEmpty &&
//             _searchController.text.isEmpty) {
//           return Center(child: Text("Enter a search query to see results"));
//         }

//         // If search is done but no results found
//         if (postLogic.postSearchModel.isEmpty) {
//           return Center(child: Text("No results found"));
//         }

//         return ListView.builder(
//           itemCount: postLogic.postSearchModel.length,
//           itemBuilder: (context, index) {
//             final item = postLogic.postSearchModel[index];
//             DateTime dateTime = DateTime.parse(item.date);
//             String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

//             return Card(
//               margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               child: Stack(
//                 children: [
//                   ListTile(
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         item.images,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             item.title,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                             style: TextStyle(
//                                 fontSize: 14, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(
//                               left: 8), // Add some space between title and type
//                           child: Text(
//                             item.type.toUpperCase(),
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: item.type == "lost"
//                                   ? Colors.red
//                                   : Colors.green,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("At: ${item.location}"),
//                         Text(
//                           "Description: ${item.description}",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Text("Date: $formattedDate"),
//                       ],
//                     ),
//                     onTap: () {
//                       // Navigate to post detail screen
//                       Navigator.of(context).push(
//                         CupertinoPageRoute(
//                             builder: (context) => PostDetailScreen(item)),
//                       );
//                     },
//                   ),
//                   Positioned(
//                     right: 10,
//                     bottom: 10,
//                     child: Text(
//                       "By: ${item.userId.firstname} ${item.userId.lastname}",
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

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
  String _selectedType = 'All Types';
  String _selectedCategory = 'All Categories';

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    // Using a map for types and categories for better flexibility
    final Map<String, String> _types = {
      'All Types': _lang.allTypes,
      'lost': _lang.lost,
      'found': _lang.found,
    };

    final Map<String, String> _categories = {
      'All Categories': _lang.allCategories,
      'people': _lang.people,
      'pets': _lang.pets,
      'stuffs': _lang.stuffs,
      'others': _lang.others,
    };

    return Scaffold(
      appBar: AppBar(title: Text(_lang.search)),
      body: Column(
        children: [
          _buildSearchBox(context),
          _buildFilterOptions(_types, _categories),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

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

  Widget _buildFilterOptions(
      Map<String, String> types, Map<String, String> categories) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: _selectedType,
            items: types.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue!;
              });
            },
          ),
          DropdownButton<String>(
            value: _selectedCategory,
            items: categories.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<PostLogic>(
      builder: (context, postLogic, child) {
        // Filter results based on search query, type, and category
        var filteredResults = postLogic.postSearchModel.where((item) {
          final matchesType =
              _selectedType == 'All Types' || item.type == _selectedType;
          final matchesCategory = _selectedCategory == 'All Categories' ||
              item.categoryId == _selectedCategory;
          final matchesSearch = item.title
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              item.description
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
          return matchesType && matchesCategory && matchesSearch;
        }).toList();

        if (filteredResults.isEmpty && _searchController.text.isEmpty) {
          return Center(child: Text("Enter a search query to see results"));
        }

        if (filteredResults.isEmpty) {
          return Center(child: Text("No results found"));
        }

        return ListView.builder(
          itemCount: filteredResults.length,
          itemBuilder: (context, index) {
            final item = filteredResults[index];
            DateTime dateTime = DateTime.parse(item.date);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Stack(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.images,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          child: Text(
                            item.type.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: item.type == "lost"
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("At: ${item.location}"),
                        Text(
                          "Description: ${item.description}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Date: $formattedDate"),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => PostDetailScreen(item)),
                      );
                    },
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Text(
                      "By: ${item.userId.firstname} ${item.userId.lastname}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
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
