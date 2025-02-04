import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreen();
}

class _CreatePostScreen extends State<CreatePostScreen> {
  
 final _category = ["people", "animal", "other"];
 String _selectVal = "people";

 final _type = ["lost", "found"];
 String _selectType = "lost";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post Screen'),
      ),
      body: Center(
        child: _buildCreatePostForm(),
      ),
    );
  }
  Widget _buildCreatePostForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildTextField("title", "Enter your title"),
          // _buildTextField("type", "Enter your type"),
          _buildDropDowFormFild("category", "Enter your category"),
          _buildTextField("date", "Enter your date"),
          _buildTextField('Location', 'Enter your location'),
          _buildTextField('Description', 'Enter your description'),
          _buildTextField('Photo', 'Re enter your photo'),
          _buildTextField('Phone', 'Enter your phone number'),
          _buildDropDowFormFildType("type", "Enter your type"),
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

  Widget _buildElevatedButton() {
    return Container(
      margin: EdgeInsets.only(top:10, left:10, right: 10, bottom:10),
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

  Widget _buildDropDown() {
    return DropdownButton(
        items: _category
            .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectVal = value as String;
          });
        });
  }
  Widget _buildDropDowFormFild(String labelText, String hintText) {
    return Container(
      margin: EdgeInsets.only(top:10, left:10, right: 10),
      width: double.maxFinite,
      height: 60,
      child: DropdownButtonFormField(
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
        ),
          items: _category
              .map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectVal = value as String;
            });
          }),
    );
  }

  Widget _buildDropDowFormFildType(String labelText, String hintText) {
    return Container(
      margin: EdgeInsets.only(top:10, left:10, right: 10),
      width: double.maxFinite,
      height: 60,
      child: DropdownButtonFormField(
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
        ),
          items: _type
              .map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectType = value as String;
            });
          }),
    );
  }
}