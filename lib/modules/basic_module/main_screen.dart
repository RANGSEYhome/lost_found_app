import 'package:flutter/material.dart';
import 'package:lost_found_app/modules/basic_module/basic_app.dart';
import 'package:lost_found_app/modules/search_module/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
// core
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/utils/widget_util.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
// modules
import 'package:lost_found_app/modules/basic_module/setting.dart';
import 'package:lost_found_app/modules/home_module/home_screen.dart';
import 'package:lost_found_app/modules/lost_found_module/lost_found_screen.dart';
import 'package:lost_found_app/modules/login_module/fakestore_provider.dart';
import 'package:lost_found_app/modules/basic_module/demo_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;
  int _currentIndex = 0;
  // const Home_Screen({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    final List<Map<String, dynamic>> _tabs = [
      {
        'appBar': AppBar(
          title: Text(_lang.appName),
          actions: [searchButton(context, SearchScreen())],
        ),
      },
      {
        'appBar': AppBar(
          title: Text(_lang.ls),
          actions: [searchButton(context, SearchScreen())],
        ),
      },
      {
        // 'appBar': AppBar(
          // title: Image.network(
          //   'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          //   width: 60,
          // ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 2.0),
          //     child: IconButton(
          //       icon: Icon(Icons.edit_note_outlined, size: 50),
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           CupertinoPageRoute(builder: (context) => DemoScreen()),
          //         );
          //       },
          //     ),
          //   ),
          // ],
        // ),
      },
    ];
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.white,
      appBar: _tabs[_currentIndex]['appBar'],
      body: _buildBody(),
      drawer: _currentIndex == 0 ? _buildDrawer() : null,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: IndexedStack(
        index: _currentIndex,
        children: [HomeScreen(), LostFoundScreen(), fakeStoreProvider()],
      ),
    );
  }

  Widget _buildBottomNavBar() {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.black12, // Change to your preferred border color
          width: 0.5, // Adjust the width as needed
        ),
      ),
    ),
    child: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: _lang.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: _lang.ls,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: _lang.account,
        ),
      ],
    ),
  );
}

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: AssetImage('lib_assets/images/logo.png'),
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.backgroundColor,
            ),
          ),
          cardListNavigateTo(
            context,
            _lang.home,
            Icons.home_outlined,
            providerBasicApp(),
          ),
          cardListNavigateTo(
            context,
            _lang.ls,
            Icons.category_outlined,
            DemoScreen(),
          ),
          cardListNavigateTo(
            context,
            _lang.aboutUs,
            Icons.info_outline,
            DemoScreen(),
          ),
          cardListNavigateTo(
            context,
            _lang.contactUs,
            Icons.contact_support_outlined,
            DemoScreen(),
          ),
          cardListNavigateTo(
            context,
            _lang.privacyPolicy,
            Icons.privacy_tip_outlined,
            DemoScreen(),
          ),
          cardListNavigateTo(
            context,
            _lang.setting,
            Icons.settings_outlined,
            SettingScreen(),
          ),
        ],
      ),
    );
  }
}
