import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// core
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
// modules
import 'package:lost_found_app/modules/basic_module/main_screen.dart';
import 'package:provider/provider.dart';
import 'fakestore_login_logic.dart';

class FakestoreHomeScreen extends StatefulWidget {
  const FakestoreHomeScreen({super.key});

  @override
  State<FakestoreHomeScreen> createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Fake Store Home Scren"),
  //       actions: [
  //         IconButton(
  //           onPressed: () async{
  //             await context.read<FakestoreLoginLogic>().clear();
  //             Navigator.of(context).pushReplacement(
  //                   CupertinoPageRoute(
  //                     builder: (context) => FakeStoreLoadingScreen(),
  //                   ),
  //                 );
  //           },
  //           icon: Icon(Icons.logout),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    Language _lang = Khmer();
    _lang = context.watch<LanguageLogic>().lang;
   
    return Scaffold(
      body: ListTile(
        leading: Icon(
          Icons.logout,
        ),
        title: Text(
          _lang.logout,
        ),
        onTap: () async {
          await context.read<FakestoreLoginLogic>().clear();
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => MainScreen()),
          );
        },
      ),
    );
  }
}
