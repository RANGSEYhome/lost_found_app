import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// core
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/themes/theme_logic.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;
  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    return Scaffold(
      appBar: AppBar(title: Text(_lang.setting)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    ThemeMode mode = context.watch<ThemeLogic>().mode;
    return ListView(
      children: [
        ExpansionTile(
          title: Text(_lang.themeColor),
          initiallyExpanded: true,
          children: [
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text(_lang.toSystemMode),
              onTap: () {
                context.read<ThemeLogic>().changeToSystem();
              },
              trailing: mode == ThemeMode.system ? Icon(Icons.check) : null,
            ),
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text(_lang.toLightMode),
              onTap: () {
                context.read<ThemeLogic>().changeToLight();
              },
              trailing:
                  mode == ThemeMode.light ? Icon(Icons.check_circle) : null,
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text(_lang.toDarkMode),
              onTap: () {
                context.read<ThemeLogic>().changeToDark();
              },
              trailing:
                  mode == ThemeMode.dark ? Icon(Icons.check_circle) : null,
            ),
          ],
        ),
        ExpansionTile(
          title: Text(_lang.language),
          initiallyExpanded: true,
          children: [
            ListTile(
              leading: Text("ខ្មែរ"),
              title: Text(_lang.changeToKhmer),
              onTap: () {
                context.read<LanguageLogic>().changToKhmer();
              },
              trailing: _langIndex == 0 ? Icon(Icons.check_circle) : null,
            ),
            ListTile(
              leading: Text("EN"),
              title: Text(_lang.changeToEnglish),
              onTap: () {
                context.read<LanguageLogic>().changeToEnglish();
              },
              trailing: _langIndex == 1 ? Icon(Icons.check_circle) : null,
            ),
          ],
        ),
      ],
    );
  }
}
