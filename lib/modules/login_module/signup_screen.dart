import 'package:flutter/material.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/login_module/fakestore_provider.dart';
import 'package:lost_found_app/modules/login_module/fakestore_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _imageFile = "";

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            imageProfile(),
            _buildTextField("Firstname", "Enter your firstname", controller: _firstnameController),
            _buildTextField("Lastname", "Enter your lastname", controller: _lastnameController),
            // _buildTextField("Username", "Enter your username", controller: _usernameController),
            _buildTextField('Email', 'Enter your email', isEmail: true, controller: _emailController),
            _buildTextField('Password', 'Enter your password', isPassword: true, controller: _passwordController),
            _buildTextField('Confirm Password', 'Re-enter your password',isPassword: true, isConfirmPassword: true, controller: _confirmPasswordController),
            _buildTextField('Phone', 'Enter your phone number', isPhone: true, controller: _phoneController),
            _buildElevatedButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, String hintText, {bool isEmail = false, bool isPassword = false, bool isConfirmPassword = false, bool isPhone = false, required TextEditingController controller}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: TextFormField(
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
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              errorStyle: TextStyle(
                fontSize: 12.0,
                height: 0.8,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "$labelText can't be empty";
              }
             
              if (isPassword && value.length < 6) {
                return "Password must be at least 6 characters";
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
            onTap: () {},
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
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: double.maxFinite,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF45BF7A),
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final UserModel user = UserModel(
              id: "",
              firstname: _firstnameController.text,
              lastname: _lastnameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
              profilePic: "",
              role: "user",
              address: "",
            );
             FakestoreService.insert(user).then((value) {

              if (value == "success") {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => fakeStoreProvider()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(value),
                ));
              }
             }).catchError((e) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 content: Text(e.toString()),
               ));
             });
            // Navigator.pushNamed(context, '/login');
          }
        },
        child: Text('Signup'),
      ),
    );
  }
}
