import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/modules/basic_module/main_screen.dart';
import 'package:lost_found_app/modules/login_module/edit_profile_screen.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:provider/provider.dart';
import 'package:lost_found_app/modules/post_detail_module/post_create_screen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_updatescreen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart'
    as postGet;
import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';

class FakestoreHomeScreen extends StatefulWidget {
  final int initialIndex;
  FakestoreHomeScreen({this.initialIndex = 2});

  @override
  _FakestoreHomeScreenState createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false; // Track loading state for async operations

  @override
  void initState() {
    super.initState();
    _fetchUserPosts();
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
    final responseModel = context.watch<FakestoreLoginLogic>().responseModel;
    final List<postGet.Doc> posts = context.watch<PostLogic>().postGetModel;
    Language _lang = context.watch<LanguageLogic>().lang;

    return Scaffold(
      appBar: AppBar(
        title: Text(_lang.account),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProfileCard(responseModel, _lang),
          _buildPostHeader(_lang),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) =>
                      _buildPostItem(posts[index], index, _lang),
                ),
                if (_isLoading) // Show loading indicator during async operations
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Handle logout
  void _handleLogout() async {
    await context.read<FakestoreLoginLogic>().clear();
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(builder: (context) => MainScreen()),
    );
  }

  // Build the profile card
  Widget _buildProfileCard(MyResponseModel responseModel, Language _lang) {
    final user = responseModel.user;
    final String profileImage = (user?.profilePic?.isNotEmpty ?? false)
        ? user!.profilePic!
        : 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(profileImage),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user?.firstname ?? _lang.noName} ${user?.lastname ?? ''}"
                        .trim(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  _buildProfileInfoRow(Icons.phone, user?.phone ?? 'No Phone'),
                  const SizedBox(height: 8),
                  _buildProfileInfoRow(Icons.email, user?.email ?? 'No Email'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (user != null) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditProfileScreen(user),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.edit, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  // Build profile info row
  Widget _buildProfileInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.green),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  // Build the header for the posts section
  Widget _buildPostHeader(Language _lang) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          _lang.managePosts,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_circle_outline,
              size: 24, color: Colors.green.shade700),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreatePostScreen()),
            );
          },
        ),
      ),
    );
  }

  // Build a single post item
  Widget _buildPostItem(postGet.Doc post, int index, Language _lang) {
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(post.date));
    final Color statusColor =
        post.status == "Resolved" ? Colors.blue : Colors.grey[600]!;

    return Dismissible(
      key: Key(post.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.check, color: Colors.white, size: 50),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (post.status == "Resolved") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_lang.alreadyResolved)),
            );
            return false;
          } else {
            return await _showUpdateStatusConfirmationDialog(
                context, post, _lang);
          }
        }
      },
      onDismissed: (direction) {
        setState(() {
          context.read<PostLogic>().postGetModel.removeAt(index);
        });

        if (direction == DismissDirection.startToEnd) {
          _updatePostStatus(post, "Resolved");
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.images,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${_lang.location}: ${post.location}",
                      style: TextStyle(
                          // color: Colors.grey[700],
                          fontSize: 12),
                    ),
                    Text(
                      "${_lang.description}: ${post.description}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          // color: Colors.grey[700],
                          fontSize: 12),
                    ),
                    Text(
                      "${_lang.date}: $formattedDate",
                      style: TextStyle(
                          // color: Colors.grey[600],
                          fontSize: 12),
                    ),
                    Text(
                      "${"📌"} ${post.status == "active" ? "${_lang.active}" : "${_lang.resolved}"}",
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (post.status != "Resolved") // Conditionally render the buttons
                Column(
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
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, post, _lang),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a confirmation dialog for deleting a post
  void _showDeleteConfirmationDialog(
      BuildContext context, postGet.Doc post, Language _lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_lang.deletePost),
        content: Text(_lang.deletePostConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_lang.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() => _isLoading = true);

              final String result =
                  await PostSeevice.updateStatus(post.id, "deactive");

              setState(() => _isLoading = false);

              if (result == 'success') {
                context.read<PostLogic>().readByUser(
                    context.read<FakestoreLoginLogic>().responseModel.user!.id);
                context.read<PostLogic>().read();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_lang.deletePostSuccess)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(_lang.deletePostFail)),
                );
              }
            },
            child: Text(_lang.delete),
          ),
        ],
      ),
    );
  }

  Future<bool> _showUpdateStatusConfirmationDialog(
      BuildContext context, postGet.Doc post, Language _lang) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(_lang.makeResolved),
            content: Text(_lang.makeResolvedConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(_lang.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(_lang.resolve),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _updatePostStatus(postGet.Doc post, String status) async {
    setState(() => _isLoading = true);

    final String result = await PostSeevice.updateStatus(post.id, status);

    setState(() => _isLoading = false);

    if (result == 'success') {
      context.read<PostLogic>().readByUser(
          context.read<FakestoreLoginLogic>().responseModel.user!.id);
      context.read<PostLogic>().read();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post status updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post status')),
      );
    }
  }

  Future<bool> _showArchiveConfirmationDialog(
      BuildContext context, postGet.Doc post) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Post"),
        content: Text("Are you sure you want to uncomplete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Uncomplete"),
          ),
        ],
      ),
    );
  }
}
