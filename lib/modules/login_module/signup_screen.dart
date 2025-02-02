import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  String _imageFile = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Screen'),
      ),
      body: Center(
        child: _buildSignupForm(),
      ),
    );
  }

  Widget _buildSignupForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          imageProfile(),
          _buildTextField("Firstname", "Enter your firstname"),
          _buildTextField("Lastname", "Enter your lastname"),
          _buildTextField("Username", "Enter your username"),
          _buildTextField('Email', 'Enter your email'),
          _buildTextField('Password', 'Enter your password'),
          _buildTextField('Confirm Password', 'Re enter your password'),
          _buildTextField('Phone', 'Enter your phone number'),
          _buildElevatedButton(),
         
        ],
      ),
    );
  }

  Widget _buildTextField(String labelText, String hintText) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: TextFormField(
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
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          errorStyle: TextStyle(
            fontSize: 12.0,
            height: 0.8,
          ),
          errorMaxLines: 1,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field can't be empty";
          }
          return null;
        },
      ),
    );
  }

   Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 75.0,
          backgroundImage: _imageFile == null
              ? AssetImage("lib_assets/images/logo.png")
              : AssetImage("lib_assets/images/logo.png"),
        ),
        Positioned(
          bottom: 15.0,
          right: 15.0,
          child: InkWell(
            onTap: () {
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildElevatedButton() {
    return Container(
      margin: EdgeInsets.only(top:10, left:10, right: 10),
      width: double.maxFinite,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF45BF7A),
          foregroundColor: Colors.white,
        ),
        onPressed: () {},
        child: Text('Signup'),
      ),
    );
  }

}
