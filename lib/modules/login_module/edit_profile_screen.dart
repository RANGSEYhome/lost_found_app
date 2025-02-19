import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_app.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/login_module/fakestore_provider.dart';
import 'package:lost_found_app/modules/login_module/fakestore_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen(this.user, {Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker();
  String p = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
  bool _isLoading = false;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    _firstnameController.text = widget.user.firstname;
    _lastnameController.text = widget.user.lastname;
    _emailController.text = widget.user.email;
    _phoneController.text = widget.user.phone;
     p = widget.user.profilePic?.isEmpty ?? true
      ? "https://cdn-icons-png.flaticon.com/512/149/149071.png" // Default image URL
      : widget.user.profilePic!;
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for camera
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Language _lang = context.watch<LanguageLogic>().lang;
    return Scaffold(
      appBar: AppBar(
        title: Text(_lang.editProfile),
      ),
      body: Center(
        child: _buildSignupForm(_lang),
      ),
    );
  }

  Widget _buildSignupForm(Language _lang) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            imageProfile(),
            _buildTextField(_lang.firstName, _lang.enterFirstName, TextInputType.text,
                controller: _firstnameController),
            _buildTextField(_lang.lastName, _lang.enterLastName, TextInputType.text,
                controller: _lastnameController),
            _buildTextField(_lang.email, _lang.enterEmail, TextInputType.emailAddress,
                isEmail: true, controller: _emailController),
            _buildTextField(_lang.phone, _lang.enterPhone, TextInputType.phone,
                isPhone: true, controller: _phoneController),
            _buildElevatedButton(_lang),
          ],
        ),
      ),
    );
  }
Widget _buildTextField(
  String labelText,
  String hintText,
  TextInputType inputType, {
  bool isEmail = false,
  bool isPhone = false,
  required TextEditingController controller,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: TextFormField(
          keyboardType: inputType,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
            errorStyle: TextStyle(fontSize: 12.0, height: 0.8),
          ),
          validator: (value) {
            return null;
          },
          onChanged: (value) {
            setState(() {});
            _formKey.currentState!.validate();
          },
        ),
      );
    },
  );
}

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 75.0,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!) // Use FileImage if the user selects an image
                : NetworkImage(widget.user.profilePic), // Default image
            backgroundColor: Colors.grey[200], // Optional: Set a background color
          ),
          Positioned(
            bottom: 15.0,
            right: 15.0,
            child: InkWell(
              onTap: _pickImage, // Open the image picker
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildElevatedButton(Language _lang) {
  return Container(
    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
    width: double.maxFinite,
    height: 60,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF45BF7A),
        foregroundColor: Colors.white,
      ),
      onPressed: _isLoading
          ? null // Disable the button when loading
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true; // Start loading
                });

                try {
                  if (_imageFile != null) {
                    await FakestoreService.uploadImage(_imageFile!).then((path) {
                      p = path.toString();
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.toString()),
                      ));
                    });
                  }
                  print("Image p: $p");
                  UserModel user = UserModel(
                    id: widget.user.id,
                    firstname: _firstnameController.text,
                    lastname: _lastnameController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    password: widget.user.password,
                    confirmPassword: widget.user.password,
                    profilePic: p,
                    role: widget.user.role,
                    address: widget.user.address,
                  );

                  String result = await FakestoreService.updateUser(user, widget.user.id);
                  final loginLogic = Provider.of<FakestoreLoginLogic>(context, listen: false);
                  await loginLogic.updateUser(user);
                  loginLogic.read();
                  context.read<PostLogic>().read();


                  if (result == "success") {
                    Navigator.pop(context);
                    // setState(() {});
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => FakeStoreApp()),
                    // );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                    ));
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                } finally {
                  setState(() {
                    _isLoading = false; // Stop loading
                  });
                }
              }
            },
      child: _isLoading
          ? CircularProgressIndicator(
              color: Colors.white, // Show loading indicator
            )
          : Text(_lang.updateProfile),
    ),
  );
}
}
