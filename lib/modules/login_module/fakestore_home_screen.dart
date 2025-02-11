import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
// Core
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
// Modules
import 'package:lost_found_app/modules/login_module/fakestore_loading_screen.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_updatescreen.dart';
import 'package:provider/provider.dart';
import 'fakestore_login_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart'
    as postGet;
// import 'package:lost_found_app/modules/post_detail_module/post_model.dart'
//     as postGet;
// import 'package:lost_found_app/modules/post_detail_module/post_model.dart'
//     as post;

class FakestoreHomeScreen extends StatefulWidget {
  @override
  State<FakestoreHomeScreen> createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  Language _lang = Khmer();
  int _langIndex = 0;
final ScrollController _scroller = ScrollController();
  @override
  @override
void initState() {
  super.initState();
  Future.microtask(() {
    final responseModel = context.read<FakestoreLoginLogic>().responseModel;
    context.read<PostLogic>().readByUser(responseModel.user!.id);
  });
}

  @override
  Widget build(BuildContext context) {
    _lang = context.watch<LanguageLogic>().lang;
    _langIndex = context.watch<LanguageLogic>().langIndex;
    
    final responseModel = context.watch<FakestoreLoginLogic>().responseModel;
   // context.watch<PostLogic>().readByUser(responseModel.user!.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await context.read<FakestoreLoginLogic>().clear();
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => FakeStoreLoadingScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(responseModel),
    );
  }

  Widget _buildBody(MyResponseModel responseModel) {
    // context.read<PostLogic>().readByUser(userId);
    List<postGet.Doc> records = context.watch<PostLogic>().postGetModel;

      return Column(
      children: [
        _buildProfile(responseModel),
        _buildCardHeader(),
        Expanded(
          child: ListView.builder(
            controller: _scroller, // Attach the ScrollController
            itemCount: records.length,
            itemBuilder: (context, index) {
              return _buildPostItem(records[index]);
            },
          ),
        ),
      ],
    );

    // return Column(
    //   children: [
    //     _buildProfile(responseModel),
    //     _buildCardHeader(),
    //     Expanded(child: _buildPostItem(records[index])),
    //   ],
    // );
  }

  Widget _buildCardHeader() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: ListTile(
        title: Text('Manage your post'),
        trailing: InkWell(
          onTap: () {},
          child: Icon(Icons.add_circle_outline, size: 20),
        ),
      ),
    );
  }

Widget _buildPostItem(postGet.Doc item) {
  DateTime dateTime = DateTime.parse(item.date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

  return Card(
    margin: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppColors.primaryColor, width: 1),
    ),
    child: Stack(
      children: [
        ListTile(
          leading: Image.network(
            item.images,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          title: Text(
            item.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("At: ${item.location}"),
                Text(
                "Description: ${item.description}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Ensures text is truncated
              ),
              Text("Date: ${formattedDate}"),
            ],
          ),
          onTap: () {
            // Navigate to post detail screen or trigger actions
            // Navigator.of(context).push(
            //   CupertinoPageRoute(builder: (context) => PostDetailScreen(item.userId)),
            // );
          },
        ),
        // Positioned Column for Edit and Delete Icons
        Positioned(
          right: 10,
          top: 5,
    
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Edit Icon (Positioned at the top right)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                  // Trigger edit action
                  print("Edit post with ID: ${item.id}");
                  // Navigator.of(context).push(
                  //   CupertinoPageRoute(
                  //     builder: (context) => UpdatePostScreen(item),
                  //   ),
                  // );
                },
              ),
              // Delete Icon (Positioned at the bottom right)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Trigger delete action
                  print("Delete post with ID: ${item.id}");
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}




  Widget _buildProfile(MyResponseModel responseModel) {
    String imgProfile = responseModel.user?.profilePic ??
        'https://cdn-icons-png.flaticon.com/512/149/149071.png';

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
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imgProfile),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  responseModel.user?.firstname ?? 'No Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text(responseModel.user?.phone ?? 'No Phone',
                        style: TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                    Text(responseModel.user?.email ?? 'No Email',
                        style: TextStyle(fontSize: 16, color: Colors.green)),
                  ],
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.edit, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}