import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// core
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/modules/login_module/edit_profile_screen.dart';
// modules
import 'package:lost_found_app/modules/login_module/fakestore_loading_screen.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:provider/provider.dart';
import 'fakestore_login_logic.dart';

class FakestoreHomeScreen extends StatefulWidget {
 // const FakestoreHomeScreen({super.key});
  
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
      appBar: AppBar(title: Text("Account"),
      actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Show Snackbar',
            onPressed: () async {
              await context.read<FakestoreLoginLogic>().clear();
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                    builder: (context) => FakeStoreLoadingScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildProfile(),
        _builCardHeader(),
        Expanded(child: _builCardPost()),
       // Text('Hello'),

      //   ListTile(
      //   leading: Icon(
      //     Icons.logout,
      //   ),
      //   title: Text(
      //     _lang.logout,
      //   ),
      //   onTap: () async {
      //     await context.read<FakestoreLoginLogic>().clear();
      //     Navigator.of(context).pushReplacement(
      //       CupertinoPageRoute(builder: (context) => FakeStoreLoadingScreen()),
      //     );
      //   },
      // ),
      ],
    );
  }

  Widget _builCardHeader() {
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, top: 5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        
      ),
      //margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text('Manage your post'),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
             InkWell(
              onTap: () {},
              child: Icon(Icons.add_circle_outline, size: 20), // Small icon size
            ),
          ],
        ),
      ),
    );
  }

  Widget _builCardPost() {
    final List<String> posts = [
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
      "Lost White Cat",
    ];

    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: ListTile(
                  title: Text(posts[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Prevents extra spacing
                    children: [
                      InkWell(
                        onTap: () {},
                        child:
                            Icon(Icons.settings, size: 18), // Small icon size
                      ),
                      SizedBox(width: 4), // Smallest possible space
                      InkWell(
                        onTap: () {},
                        child: Icon(Icons.edit, size: 18),
                      ),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () {},
                        child: Icon(Icons.remove_red_eye, size: 18),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  Widget _buildProfile(){
    MyResponseModel responseModel =
              context.watch<FakestoreLoginLogic>().responseModel;
  // String imgProfile = '${responseModel.user?.profilePic ?? 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}';
  // print("ste" + imgProfile);
    String imgProfile = '${responseModel.user?.profilePic}';
      if (imgProfile == null || imgProfile.isEmpty) {
        imgProfile = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
      }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green),
      ),
      color: Colors.grey[300],
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                imgProfile
                //"https://cdn-icons-png.flaticon.com/512/149/149071.png"
              ),
            ),
            SizedBox(width: 16),

            // User Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${responseModel.user?.firstname ?? 'No Name'}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text('male', style: TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text('0000000000001', style: TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text('example@gmail.com', style: TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
              ],
            ),

            Spacer(),

            // Edit Icon
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              icon: Icon(Icons.edit, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
