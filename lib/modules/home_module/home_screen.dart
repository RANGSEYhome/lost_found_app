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
        _buildCategoryGrid(context)
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
              Icon(category["icon"], size: 40, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                category["title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(15),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            if (categories.length.isOdd && index == categories.length - 1) {
              return Center(
                child: SizedBox(
                  width: constraints.maxWidth * 0.45, // Center last item
                  child: _buildCategoryCard(categories[index], context),
                ),
              );
            }
            return _buildCategoryCard(categories[index], context);
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _categoryList() {
    return [
      {
        "title": "People",
        "icon": Icons.people_alt,
        "page": DemoScreen(),
      },
      {
        "title": "Pets",
        "icon": Icons.pets_outlined,
        "page": DemoScreen(),
      },
      {
        "title": "Staffs",
        "icon": Icons.style_outlined,
        "page": DemoScreen(),
      },
      {
        "title": "Others",
        "icon": Icons.all_inclusive_outlined,
        "page": DemoScreen(),
      },
    ];
  }
}
