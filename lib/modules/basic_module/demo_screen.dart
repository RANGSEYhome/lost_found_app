import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// core
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/themes/theme_logic.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;
  @override
 Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
     _langIndex = context.watch<LanguageLogic>().langIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo Screen"),
      ),
      body: _buildBody()
    );
  }
  Widget _buildBody(){
     ThemeMode mode = context.watch<ThemeLogic>().mode;
    return Center(
      child: Text("This is just a demo screen"),
    );
  }
}