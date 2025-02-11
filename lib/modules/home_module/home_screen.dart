import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/core/constants/app_spacing.dart';
import 'package:lost_found_app/core/constants/app_text_style.dart';
import 'package:lost_found_app/core/utils/widget_util.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
// core
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
// modules
import 'package:lost_found_app/modules/basic_module/demo_screen.dart';
import 'package:lost_found_app/modules/home_module/book_data.dart';
import 'package:lost_found_app/modules/post_detail_module/post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Language _lang = Khmer();
  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        HeadlineLabel(
          "Recent Posts",
          AppTextSizes.headline2,
          button: textButtonNavigateTo(
            context,
            destination: DemoScreen(),
            child: Text("All Posts"),
          ) as TextButton,
        ),
        _buildSlideShow(bookModelList, Axis.horizontal),
        SizedBox(height: AppSpacing.lg),
        HeadlineLabel(
          "Posts by Category",
          AppTextSizes.headline2,
        ),
        _buildCategoryView(),
      ],
    );
  }

  Widget _buildSlideShow(List<BookModel> items, Axis direc) {
    if (items.isEmpty) {
      return Center(child: Text("No posts available!"));
    }
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            physics: BouncingScrollPhysics(),
            scrollDirection: direc,
            itemCount: items.length,
            pageSnapping: true,
            itemBuilder: (context, index) {
              double scale =
                  _pageController.hasClients && _pageController.page != null
                      ? (1 - (_pageController.page! - index).abs() * 0.1)
                      : 1;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildSlideItems(items[index]),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: items.length,
          effect: ExpandingDotsEffect(
            dotWidth: 12,
            dotHeight: 12,
            activeDotColor: AppColors.primaryColor,
            dotColor: AppColors.black.withOpacity(0.5),
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildSlideItems(items) {
    return Card(
      child: InkWell(
        onTap: () {
          // Navigator.of(context).push(
          //   CupertinoPageRoute(builder: (context) => PostDetailScreen(items)),
          // );
        },
        child: SizedBox(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                _buildImageWithOverlay(items.img),
                _buildOverlay(items), // Single overlay for first three items
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: _buildPostedBy("Kaka"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithOverlay(String imageUrl) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.bottomCenter,
        //       end: Alignment.topCenter,
        //       colors: [
        //         Colors.black87,
        //         Colors.black54,
        //         Colors.black26,
        //         Colors.transparent,
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildOverlay(items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoText("Lost:", "Cat"),
          _buildInfoText("Date:", "2025-01-01"),
          _buildInfoText("Location:", "Water Park"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostedBy(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "Posted by $name",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildCategoryView() {
    final categories = _categoryList();
    int crossAxisCount = 1; // Number of items per row

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: List.generate((categories.length / crossAxisCount).ceil(), (
          rowIndex,
        ) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(crossAxisCount, (colIndex) {
              int itemIndex = rowIndex * crossAxisCount + colIndex;
              return itemIndex < categories.length
                  ? Expanded(child: _buildCategoryItem(categories[itemIndex]))
                  : SizedBox(); // Empty space if no item
            }),
          );
        }),
      ),
    );
  }

  List<Map<String, dynamic>> _categoryList() {
    return [
      {
        "title": "Lost & Found of People",
        "icon": Icons.people_alt,
        "page": DemoScreen(),
      },
      {
        "title": "Lost & Found of Animal",
        "icon": Icons.pets_outlined,
        "page": DemoScreen(),
      },
      {
        "title": "Lost & Found of other Staff",
        "icon": Icons.all_inclusive_outlined,
        "page": DemoScreen(),
      },
    ];
  }

  Widget _buildCategoryItem(Map<String, dynamic> item) {
    return Column(
      children: [
        cardListNavigateTo(
          context,
          item["title"],
          item["icon"],
          item["page"],
          padding: AppSpacing.md,
          iconsSize: 45,
          borderColor: AppColors.primaryColor,
        ),
      ],
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
}
