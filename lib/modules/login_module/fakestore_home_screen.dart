import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/modules/basic_module/main_screen.dart';
import 'package:lost_found_app/modules/login_module/edit_profile_screen.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:lost_found_app/core/constants/app_colors.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/modules/login_module/fakestore_loading_screen.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';
import 'package:lost_found_app/modules/post_detail_module/post_updatescreen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart' as postGet;

class FakestoreHomeScreen extends StatefulWidget {
   final int initialIndex;
  FakestoreHomeScreen({this.initialIndex = 2});
  @override
  _FakestoreHomeScreenState createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isDeleting = false; // Track delete operation loading state
  Language _lang = Khmer();
  int _langIndex = 0;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchUserPosts();
    _selectedIndex = 2;
  }

  // Fetch posts for the logged-in user
  void _fetchUserPosts() {
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        backgroundColor: Colors.green[50],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: _buildBody(responseModel),
    );
  }

  // Handle logout
  void _handleLogout() async {
    await context.read<FakestoreLoginLogic>().clear();
    setState(() {});
    // Navigator.of(context).pushReplacement(
    //   CupertinoPageRoute(builder: (context) => MainScreen()),
    // );
  }

  // Build the main body of the screen
  Widget _buildBody(MyResponseModel responseModel) {
    final List<postGet.Doc> posts = context.watch<PostLogic>().postGetModel;

    return Column(
      children: [
        _buildProfileCard(responseModel),
        _buildPostHeader(),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: posts.length,
                itemBuilder: (context, index) => _buildPostItem(posts[index]),
              ),
              if (_isDeleting) // Show loading indicator during delete
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ],
    );
  }

  // Build the profile card
  Widget _buildProfileCard(MyResponseModel responseModel) {
    final String profileImage = responseModel.user?.profilePic?.isNotEmpty == true
        ? responseModel.user!.profilePic!
        : 'https://cdn-icons-png.flaticon.com/512/149/149071.png'; // Default profile image

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
              backgroundImage: NetworkImage(profileImage),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
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
                  _buildProfileInfoRow(Icons.phone, responseModel.user?.phone ?? 'No Phone'),
                  SizedBox(height: 8),
                  _buildProfileInfoRow(Icons.email, responseModel.user?.email ?? 'No Email'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              icon: Icon(Icons.edit, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  // Build a row for profile information (phone, email, etc.)
  Widget _buildProfileInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 18),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16, color: Colors.green)),
      ],
    );
  }

  // Build the header for the posts section
  Widget _buildPostHeader() {
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
        title: Text('Manage your posts'),
        trailing: IconButton(
          icon: Icon(Icons.add_circle_outline, size: 20),
          onPressed: () {
            // Navigate to add post screen
          },
        ),
      ),
    );
  }

  // Build a single post item
  Widget _buildPostItem(postGet.Doc post) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(post.date));

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
              post.images,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            title: Text(
              post.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("At: ${post.location}"),
                Text(
                  "Description: ${post.description}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("Date: $formattedDate"),
              ],
            ),
            onTap: () {
              // Navigate to post detail screen
            },
          ),
          Positioned(
            right: 10,
            top: 5,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => UpdatePostScreen(post),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(context, post),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show a confirmation dialog for deleting a post
  void _showDeleteConfirmationDialog(BuildContext context, postGet.Doc post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() => _isDeleting = true); // Start loading

              final String result = await PostSeevice.delete(post.id);

              setState(() => _isDeleting = false); // Stop loading

              if (result == 'success') {
                //print("Users ID"+ context.read<FakestoreLoginLogic>().responseModel.user!.id);
                context.read<PostLogic>().readByUser(context.read<FakestoreLoginLogic>().responseModel.user!.id);
                context.read<PostLogic>().read();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Post deleted successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete post')),
                );
              }
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}