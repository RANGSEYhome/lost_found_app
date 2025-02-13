import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/core/constants/app_spacing.dart';
import 'package:lost_found_app/core/constants/app_text_style.dart';
import 'package:lost_found_app/core/utils/widget_util.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
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
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart'
    as postGet;
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
    List<postGet.Doc> records = context.watch<PostLogic>().postModel;
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
        _buildSlideShow(records, Axis.horizontal),
        SizedBox(height: AppSpacing.lg),
        HeadlineLabel(
          "Posts by Category",
          AppTextSizes.headline2,
        ),
        _buildCategoryGrid(context)
      ],
    );
  }

  Widget _buildSlideShow(List<postGet.Doc> items, Axis direc) {
    // if (items) {
    //   return Center(child: Text("No posts available!"));
    // }
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
                  borderRadius: BorderRadius.circular(15),
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

  Widget _buildSlideItems(postGet.Doc item) {
    return Card(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigator.of(context).push(
          //   CupertinoPageRoute(builder: (context) => PostDetailScreen(items)),
          // );
        },
        child: SizedBox(
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                _buildImageWithOverlay(item.images),
                _buildOverlay(item), // Single overlay for first three items
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: _buildPostedBy(item.userId.firstname + " " + item.userId.lastname),
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
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black87, // Strong dark color at the bottom
                Colors.black54, // Medium transparency
                Colors.black38, // Light overlay
                Colors.transparent, // Fully transparent at the top
              ],
              stops: [0.0, 0.3, 0.6, 1.0], // Adjusts the fade transition
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay(items) {
     DateTime dateTime = DateTime.parse(items.date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoText("Lost:", items.title),
          _buildInfoText("Date:", formattedDate),
          _buildInfoText("Location:", items.location),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Text.rich(
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
    );
  }

  Widget _buildPostedBy(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      // decoration: BoxDecoration(
      //   color: Colors.black87,
      //   borderRadius: BorderRadius.circular(6),
      // ),
      child: Text(
        "Posted by $name",
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildCategoryCard(
      Map<String, dynamic> category, BuildContext context) {
    return Card(
      color: category["cardColor"],
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => category["page"]),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category["icon"], size: 40, color: category["iconColor"]),
              const SizedBox(height: 10),
              Text(
                category["title"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: category["textColor"],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    List<Map<String, dynamic>> categories = _categoryList();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(8), // Outer padding
            decoration: BoxDecoration(
              color: Colors.white70, // Smoke background color
              borderRadius:
                  BorderRadius.circular(10), // Optional: rounded corners
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets
                  .zero, // Remove inner padding since it's handled by Container
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return _buildCategoryCard(categories[index], context);
              },
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _categoryList() {
    return [
      {
        "title": "People",
        "icon": Icons.people_alt,
        "page": DemoScreen(),
        "textColor": Color(0xFF4C585B),
        "iconColor": Color(0xFF4C585B),
        "cardColor": Colors.yellow[300],
      },
      {
        "title": "Pets",
        "icon": Icons.pets_outlined,
        "page": DemoScreen(),
        "textColor": Colors.white,
        "iconColor": Colors.white,
        "cardColor": Colors.red[300],
      },
      {
        "title": "Staffs",
        "icon": Icons.style_outlined,
        "page": DemoScreen(),
        "textColor": Colors.white,
        "iconColor": Colors.white,
        "cardColor": Colors.blue[300],
      },
      {
        "title": "Others",
        "icon": Icons.all_inclusive_outlined,
        "page": DemoScreen(),
        "textColor": Color(0xFF4C585B),
        "iconColor": Color(0xFF4C585B),
        "cardColor": Colors.green[300],
      },
    ];
  }
}
