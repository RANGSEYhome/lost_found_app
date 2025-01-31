import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    child: child,
  );
}

Widget cardListNavigateTo(
  BuildContext context,
  String title,
  IconData icon,
  Widget? destination,
) {
  return Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (destination != null) {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => destination),
          );
        }
      },
    ),
  );
}

Widget roundedImage(String img, {double radius = 10}) {
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

Widget itemCard(String title, String subtitle, String image) {
  return Card(
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Image.asset(image),
    ),
  );
}

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
