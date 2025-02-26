import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_app.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/login_module/fakestore_provider.dart';
import 'package:lost_found_app/modules/login_module/fakestore_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
   FirebaseMessaging messaging = FirebaseMessaging.instance;
   
  //String _imageFile = "";
  File? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for camera
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Call uploadImage function
      //uploadImage(_imageFile!);
    }
  }

  String p = "";
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    // _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Language _lang = context.watch<LanguageLogic>().lang;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(_lang.signUp),
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
            _buildTextField(_lang, _lang.firstName, _lang.enterFirstName,
                TextInputType.text,
                controller: _firstnameController),
            _buildTextField(
                _lang, _lang.lastName, _lang.enterLastName, TextInputType.text,
                controller: _lastnameController),
            // _buildTextField("Username", "Enter your username", controller: _usernameController),
            _buildTextField(_lang, _lang.email, _lang.enterEmail,
                TextInputType.emailAddress,
                isEmail: true, controller: _emailController),
            _buildTextField(
                _lang, _lang.password, _lang.enterPassword, TextInputType.text,
                isPassword: true, controller: _passwordController),
            _buildTextField(_lang, _lang.confirmPassword, _lang.reEnterPassword,
                TextInputType.text,
                isPassword: true,
                isConfirmPassword: true,
                controller: _confirmPasswordController),
            _buildTextField(
                _lang, _lang.phone, _lang.enterPhone, TextInputType.phone,
                isPhone: true, controller: _phoneController),
            _buildElevatedButton(_lang),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(Language _lang, String labelText, String hintText,
      TextInputType inputType,
      {bool isEmail = false,
      bool isPassword = false,
      bool isConfirmPassword = false,
      bool isPhone = false,
      required TextEditingController controller}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: TextFormField(
            keyboardType: inputType,
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Color(0xFF45BF7A),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.green,
                  width: 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.green,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              errorStyle: TextStyle(
                fontSize: 12.0,
                height: 0.8,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return _lang.noEmpty;
              }

              if (isPassword && value.length < 6) {
                return _lang.passwordChar;
              }
              if (isConfirmPassword) {
                if (value != _passwordController.text) {
                  return _lang.passwordMatch;
                }
              }
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
                ? FileImage(
                    _imageFile!) // Use FileImage if the user selects an image
                : AssetImage("lib_assets/images/logo.png")
                    as ImageProvider, // Default image
            backgroundColor:
                Colors.grey[200], // Optional: Set a background color
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
                      await FakestoreService.uploadImage(_imageFile!)
                          .then((path) {
                        p = path.toString();
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      });
                    } else {
                      p = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
                    }
                    String? token = await messaging.getToken();
                    UserModel user = UserModel(
                      id: "",
                      firstname: _firstnameController.text,
                      lastname: _lastnameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                      profilePic: p,
                      role: "user",
                      address: "",
                      smToken: token.toString(),
                    );

                    String result = await FakestoreService.insert(user);
                    if (result == "success") {
                      Navigator.pop(context);
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
            : Text(_lang.signUp),
      ),
    );
  }
}
