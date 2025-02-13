import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lost_found_app/modules/basic_module/main_screen.dart';
import 'package:lost_found_app/modules/home_module/home_screen.dart';
import 'package:lost_found_app/modules/login_module/signup_screen.dart';
import 'package:provider/provider.dart';
import 'fakestore_home_screen.dart';
import 'fakestore_login_logic.dart';
import 'fakestore_login_models.dart';

class FakeStoreLoginScreen extends StatefulWidget {
  @override
  State<FakeStoreLoginScreen> createState() => _FakeStoreLoginScreenState();
}

class _FakeStoreLoginScreenState extends State<FakeStoreLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  bool _hidePassword = true;
  String imgLogo = "https://cdn-icons-png.flaticon.com/512/149/149071.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.green[50],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImage(imgLogo),
                  _buildUsernameTextField(),
                  SizedBox(height: 10),
                  _buildPasswordTextField(),
                  SizedBox(height: 20),
                  _buildLoginButton(),
                  SizedBox(height: 15),
                  Text("Or continue with",style: TextStyle(color: Colors.black54)),
                  SizedBox(height: 15),
                  _buildSocialLoginButtons(),
                  SizedBox(height: 20),
                  _buildSignupText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF45BF7A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text("Login", style: TextStyle(fontSize: 18)),
      ),
    );
  }

Widget _buildSocialLoginButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildSocialButton(FontAwesomeIcons.google, const Color.fromARGB(255, 184, 49, 49), () async {
       // await AuthService().signInWithGoogle();
      }),
      SizedBox(width: 10),
      _buildSocialButton(FontAwesomeIcons.facebook, const Color.fromARGB(255, 33, 50, 235), () async {
        //await AuthService().signInWithFacebook();
      }),
      SizedBox(width: 10),
      _buildSocialButton(FontAwesomeIcons.apple, const Color.fromARGB(255, 140, 140, 140), () async {
       // await AuthService().signInWithApple();
      }),
    ],
  );
}

Widget _buildSocialButton(IconData icon, Color color, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Icon(icon, color: color, size: 30),
    ),
  );
}

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        MyResponseModel response = await context.read<FakestoreLoginLogic>().login(
          _usernameCtrl.text.trim(),
          _passCtrl.text.trim(),
        );
        if (response.token != null) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          _showSnackBar("Login Failed");
        }
      } catch (e) {
        _showSnackBar("Error: ${e.toString()}");
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      _showSnackBar("Invalid username or password");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildUsernameTextField() {
    return _buildTextField(_usernameCtrl, "Username", Icons.person);
  }

  Widget _buildPasswordTextField() {
    return _buildTextField(_passCtrl, "Password", Icons.lock, isPassword: true);
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF45BF7A)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _hidePassword : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$hint is required";
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon, color: Color(0xFF45BF7A)),
          hintText: "Enter $hint",
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _hidePassword = !_hidePassword),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildImage(String img) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 5),
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildSignupText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: TextStyle(color: Colors.black54)),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupScreen()),
            );
          },
          child: Text("Sign Up", style: TextStyle(color: Color(0xFF45BF7A))),
        ),
      ],
    );
  }
}
