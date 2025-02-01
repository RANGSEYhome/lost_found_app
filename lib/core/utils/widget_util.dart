import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/core/constants/app_text_style.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';

Language _lang = Khmer();

Widget textNavigateTo(
  BuildContext context, {
  Widget? destination,
  Widget? child,
}) {
  return InkWell(
    onTap: () {
      if (destination != null) {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(builder: (context) => destination));
      }
    },
    child: child ?? SizedBox.shrink(),
  );
}
// textButtonNavigateTo(context, destination: DemoScreen(), child: Text("Click Me!")),

Widget textButtonNavigateTo(
  BuildContext context, {
  Widget? destination,
  Widget? child,
}) {
  return TextButton(
    onPressed: () {
      if (destination != null) {
        Navigator.of(
          context,
        ).push(CupertinoPageRoute(builder: (context) => destination));
      }
    },
    child: child ?? SizedBox.shrink(),
  );
}
// textButtonNavigateTo(context, destination: DemoScreen(), child: Text("Click Me!")),

Widget cardListNavigateTo(
  BuildContext context,
  String title,
  IconData icon,
  Widget? destination,
  {double padding = 0, double fontSize = AppTextSizes.bodyTextMedium, double iconsSize = AppTextSizes.bodyTextMedium}
) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor, size: iconsSize,),
        title: Text(title, style: TextStyle(fontSize: fontSize)),
        onTap: () {
          if (destination != null) {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => destination),
            );
          }
        },
      ),
    ),
  );
}
// cardListNavigateTo(context, "Title", Icons.privacy_tip_outlined, DemoScreen()),

Widget roundedImageNetwork(String img, {double radius = 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.network(
      img,
      fit: BoxFit.cover,
      width: double.maxFinite,
      //do not set height because it causes the layout error
      // height: double.maxFinite,
    ),
  );
}
// roundedImage('https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png', radius: 15),

Widget roundedImageAsset(String img, {double radius = 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      img,
      fit: BoxFit.cover,
      width: double.maxFinite,
      //do not set height because it causes the layout error
      // height: double.maxFinite,
    ),
  );
}
// roundedImageAsset('lib_assets/images/logo.png', radius: 15),

Widget itemCardLeadingImage(String title, String subtitle, String image) {
  return Card(
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Image.asset(image),
    ),
  );
}
// itemCard("Title", "Sub Title", "lib_assets/images/image.png"),

Widget itemCardLeadingIcon(String title, String subtitle, IconData icon) {
  return Card(
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Icon(icon),
    ),
  );
}
// itemCardLeadingIcon("Title", "Sub Title", Icons.privacy_tip_outlined),

Widget searchButton(BuildContext context, Widget page) {
  return Padding(
    padding: const EdgeInsets.only(right: 2.0),
    child: TextButton.icon(
      icon: Icon(
        Icons.search_outlined,
        color: Theme.of(context).appBarTheme.foregroundColor,
      ),
      label: Text(_lang.search),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
    ),
  );
}
// searchButton(context, DemoScreen()),

Widget HeadlineLabel(String headline, double fontSize, {TextButton? button}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(headline, style: TextStyle(fontSize: fontSize)),
        button ??
            Container(), // Use the button if provided, otherwise an empty container
      ],
    ),
  );
}
// HeadlineLabel("Headline", AppTextSizes.headline2, button: textButtonNavigateTo(context, destination: DemoScreen(), child: Text("Click Me!")) as TextButton),

Widget searchBox() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: _lang.search,
        suffixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),
  );
}
// searchBox(),