import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:lost_found_app/core/constants/app_text_style.dart';
import 'package:lost_found_app/core/utils/widget_util.dart';
import 'package:lost_found_app/modules/basic_module/demo_screen.dart';
import 'package:lost_found_app/modules/home_module/book_data.dart';
import 'package:lost_found_app/modules/post_detail_module/post_create_screen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/modules/post_detail_module/post_detail_screen.dart';

class LostFoundScreen extends StatefulWidget {
  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> {
  // const SecondScreen({super.key});
    @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PostLogic>().read()); // Fetch posts on init
  }
  @override
  Widget build(BuildContext context) {
    Language _lang = Khmer();
    _lang = context.watch<LanguageLogic>().lang;
    return Scaffold(
      //  appBar: _buildAppBar(),
      body: _buildBody(_lang),
    );
  }
  Widget _buildBody(Language _lang) {
  Object? error = context.watch<PostLogic>().error;
  bool loading = context.watch<PostLogic>().loading;
  List<Doc> records = context.watch<PostLogic>().postModel;

  if (loading) {
    return Center(child: CircularProgressIndicator());
  }

  // if (error != null) {
  //   return _buildErrorMessage(error);
  // }

  return Row(
    children: [
            textButtonNavigateTo(context, destination: CreatePostScreen(), child: Text("Click Me!")),
     // _buildBook(records),
    ],
  );
}


  // Widget _buildBody(Language _lang) {
  //    context.read<PostLogic>().read();
  //    List<Doc> records = context.read<PostLogic>().postModel;
  //    print("Records: $records");
  //   return ListView(
  //     children: [
  //      textButtonNavigateTo(context, destination: CreatePostScreen(), child: Text("Click Me!")),
  //       HeadlineLabel(
  //         "Recent Posts",
  //         AppTextSizes.headline2,
  //       ),
  //       _buildBook(records),
  //       HeadlineLabel(
  //         "All Posts",
  //         AppTextSizes.headline2,
  //         button:
  //             textButtonNavigateTo(
  //                   context,
  //                   destination: DemoScreen(),
  //                   child: Text("See all"),
  //                 )
  //                 as TextButton,
  //       ),
  //       _buildBook(records),
  //     ],
  //   );
  // }
  
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
  Widget _buildListItem(
    String title,
    String subtitle,
    IconData icon,
    Widget screen,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        //  color: Colors.white,
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            // color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }

  Widget _buildNewBookItems(Doc items) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          side: BorderSide(
            color: AppColors.primaryColor,
            width: 1,
          ), // Border color and width
        ),
        child: InkWell(
          onTap: () {
            // Navigator.of(context).push(
            //   CupertinoPageRoute(builder: (context) => PostDetailScreen(items)),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items at the top
              children: [
                Container(
                  height: 150, // Adjust height as needed
                  width: 100, // Adjust width as needed
                  margin: EdgeInsets.all(10), // Add some spacing
                  child: Image.network(
                    items.images,
                    fit: BoxFit.cover, // Ensure the image fits properly
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      Text(
                        items.title,
                        overflow: TextOverflow.ellipsis, // Handle long text
                        maxLines: 2, // Limit text to 2 lines
                        style: TextStyle(
                          fontSize: 14, // Adjust font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ), // Add some spacing between title and date
                      Text(
                        "Price: USD ${items.description}",
                        style: TextStyle(
                          fontSize: 14, // Adjust font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ), // Add some spacing between title and date
                      Text(
                        "Date: ${items.date}",
                        style: TextStyle(
                          fontSize: 14, // Adjust font size
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 5),
                    
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBook(List<Doc> items) {
    
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children:
            items.map((item) {
              return _buildNewBookItems(item);
            }).toList(),
      ),
    );
  }
}
