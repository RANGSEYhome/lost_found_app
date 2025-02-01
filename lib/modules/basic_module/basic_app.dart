import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// core
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/themes/theme_logic.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/core/constants/app_text_style.dart';
// modules
import 'package:lost_found_app/modules/basic_module/main_screen.dart';

Widget providerBasicApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LanguageLogic()),
      ChangeNotifierProvider(create: (context) => ThemeLogic()),
    ],
    child: BasicSplashScreen(),
  );
}

class BasicSplashScreen extends StatefulWidget {
  const BasicSplashScreen({super.key});

  @override
  State<BasicSplashScreen> createState() => _BasicSplashScreenState();
}

class _BasicSplashScreenState extends State<BasicSplashScreen> {
  Future _readLocalData() async {
    await Future.delayed(Duration(seconds: 2), () {});
    await context.read<ThemeLogic>().read();
    await context.read<LanguageLogic>().read();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readLocalData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Center(child: Text("Something went wrong with local device"));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return BasicApp();
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child:
                // CircularProgressIndicator()
                // will change to our own logo
                Image.asset(
                  'lib_assets/images/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class BasicApp extends StatelessWidget {
  const BasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode mode = context.watch<ThemeLogic>().mode;

    return MaterialApp(
      home: MainScreen(),

      themeMode: mode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: AppColors.primarySwatch,
        fontFamily: AppTextFonts.primaryFont,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.originalLightThemeBg,
          foregroundColor: AppColors.black,
          titleTextStyle: AppTextStylesLight.headline2,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.originalLightThemeBg,
        ),
        cardTheme: const CardTheme(color: AppColors.originalLightThemeBg),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: AppColors.primarySwatch,
        fontFamily: AppTextFonts.primaryFont,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.originalDarkThemeBg,
          foregroundColor: AppColors.white,
          titleTextStyle: AppTextStylesDark.headline2,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: AppColors.originalDarkThemeBg,
        ),
        cardTheme: CardTheme(color: AppColors.darkColorBg),
      ),
    );
  }
}
