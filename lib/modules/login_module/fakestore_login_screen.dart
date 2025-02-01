import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  // const LoginScreen({super.key}); //<--remove
   String imgLogo = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLloB5OXSTOToaT5YRDhKKp1Qtj_nQKjjNPw&s";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _buildBody() {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImage(imgLogo),
                _buildUsernameTextFieldBorder(),
                SizedBox(height: 10),
                _buildPasswordTextFieldBorder(),
                SizedBox(height: 10),
                _buidElevatedButton(),
                _singUpText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buidElevatedButton() {
    return Container(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF45BF7A),
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            MyResponseModel responseModel =
                await context.read<FakestoreLoginLogic>().login(
                      _usernameCtrl.text.trim(),
                      _passCtrl.text.trim(),
                    );

            debugPrint("ResponseModel: ${responseModel.toString()}");

            if (responseModel.token != null) {
              // success
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => FakestoreHomeScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login Failed"),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Username and Password formats are not correct"),
                action: SnackBarAction(
                    label: "DONE",
                    onPressed: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    }),
              ),
            );
          }
        },
        child: Text("Login"),
      ),
    );
  }

  final _usernameCtrl = TextEditingController();

  Widget _buildUsernameTextFieldBorder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF45BF7A)),
      ),
      child: TextFormField(
        controller: _usernameCtrl,
        validator: (String? text) {
          if (text!.isEmpty) {
            return "Username is required";
          }
          return null; //no problem
        },
        style: TextStyle(color: Color(0xFF45BF7A)),
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          iconColor: Color(0xFF45BF7A),
          hintText: "Enter Username",
          hintStyle: TextStyle(color: Color(0xFF45BF7A)),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.text,
        autocorrect: false,
      ),
    );
  }

  final _passCtrl = TextEditingController();

  bool _hidePassword = true;

  Widget _buildPasswordTextFieldBorder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF45BF7A)),
      ),
      child: TextFormField(
        controller: _passCtrl,
        validator: (String? text) {
          if (text!.isEmpty) {
            return "Password is required";
          } else if (text.length < 6) {
            return "Password needs at least 6 characters";
          }
          return null; //no problem
        },
        style: TextStyle(color: Color(0xFF45BF7A)),
        decoration: InputDecoration(
          icon: Icon(Icons.key),
          iconColor: Color(0xFF45BF7A),
          hintText: "Enter Password",
          hintStyle: TextStyle(color: Color(0xFF45BF7A)),
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
              debugPrint("_hidePassword: $_hidePassword");
            },
            icon: Icon(
              _hidePassword ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
        textInputAction: TextInputAction.send,
        autocorrect: false,
        obscureText: _hidePassword, //true => password
      ),
    );
  }


   Widget _buildImage(String img){
    return Center(
      child: Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 5),
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
          image: DecorationImage(
            image: NetworkImage(img),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  Widget _singUpText(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?"),
          TextButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            },
            child: Text("Sign Up", style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );
  }
}
