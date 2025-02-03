import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// core
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/themes/theme_logic.dart';
import 'package:lost_found_app/core/utils/widget_util.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;
  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    return Scaffold(
      appBar: AppBar(title: Text("Demo Screen")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    ThemeMode mode = context.watch<ThemeLogic>().mode;
    return Padding(
      padding: const EdgeInsets.all(0),
      child: searchBox(),
    );
  }
}
