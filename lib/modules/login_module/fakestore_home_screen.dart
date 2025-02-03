import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// core
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/modules/basic_module/demo_screen.dart';
// modules
import 'package:lost_found_app/modules/basic_module/main_screen.dart';
import 'package:lost_found_app/modules/home_module/home_screen.dart';
import 'package:lost_found_app/modules/login_module/fakestore_loading_screen.dart';
import 'package:provider/provider.dart';
import 'fakestore_login_logic.dart';

class FakestoreHomeScreen extends StatefulWidget {
  const FakestoreHomeScreen({super.key});

  @override
  State<FakestoreHomeScreen> createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;
  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: [
        ListTile(
        leading: Icon(
          Icons.logout,
        ),
        title: Text(
          _lang.logout,
        ),
        onTap: () async {
          await context.read<FakestoreLoginLogic>().clear();
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => FakeStoreLoadingScreen()),
          );
        },
      ),
      ],
    );
  }
}
