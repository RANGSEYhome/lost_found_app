import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:lost_found_app/core/constants/app_text_style.dart';
import 'package:lost_found_app/core/utils/widget_util.dart';
import 'package:lost_found_app/modules/basic_module/demo_screen.dart';
import 'package:lost_found_app/modules/home_module/book_data.dart';
import 'package:lost_found_app/modules/post_detail_module/post_create_screen.dart';
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
  Widget build(BuildContext context) {
    Language _lang = Khmer();
    _lang = context.watch<LanguageLogic>().lang;
    return Scaffold(
      //  appBar: _buildAppBar(),
      body: _buildBody(_lang),
    );
  }

  Widget _buildBody(Language _lang) {
    return ListView(
      children: [
       textButtonNavigateTo(context, destination: CreatePostScreen(), child: Text("Click Me!")),
        HeadlineLabel(
          "Recent Posts",
          AppTextSizes.headline2,
        ),
        _buildBook(bookModelList),
        HeadlineLabel(
          "All Posts",
          AppTextSizes.headline2,
          button:
              textButtonNavigateTo(
                    context,
                    destination: DemoScreen(),
                    child: Text("See all"),
                  )
                  as TextButton,
        ),
        _buildBook(bookModelList),
      ],
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

  Widget _buildNewBookItems(BookModel items) {
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
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => PostDetailScreen(items)),
            );
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
                    items.img,
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
                        "Price: USD ${items.price}",
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
                      RatingStars(
                        value: items.rate.toDouble(),
                        starColor: Colors.orange,
                        starOffColor: Colors.grey,
                        valueLabelColor: Colors.orange,
                        starSize: 15,
                        valueLabelTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildBook(List<BookModel> items) {
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
