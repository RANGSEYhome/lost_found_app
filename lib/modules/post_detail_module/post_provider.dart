import 'package:flutter/material.dart';
import 'package:lost_found_app/modules/post_detail_module/post_create_screen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:provider/provider.dart';

Widget postProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PostLogic()),
    ],
    child: CreatePostScreen(),
  );
}
