import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/lost_found_module/lost_found_screen.dart';
import 'dart:io';

import 'package:lost_found_app/modules/post_detail_module/post_model.dart';
import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';
import 'package:lost_found_app/modules/login_module/fakestore_service.dart';

import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _category = ["people", "animal", "other"];
  String _selectVal = "people";

  final _type = ["lost", "found"];
  String _selectType = "lost";

  // Text editing controllers
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  
 File? _imageFile;
 bool _isLoading = false;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post Screen'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          //child: _buildCreatePostForm(),
          child: _isLoading ? CircularProgressIndicator() : _buildCreatePostForm(),
        ),
      ),
    );
  }

  Widget _buildCreatePostForm() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildDropDownFormFieldType("Type", "Select your type"),
          _buildDropDownFormField("Category", "Select your category"),
          _buildTextField("Title", "Enter your title", TextInputType.text, _titleController),
          _buildDateTextField(),
          _buildTextField('Location', 'Enter your location', TextInputType.text, _locationController),
          _buildTextField('Phone', 'Enter your phone number', TextInputType.phone, _phoneController),
          _buildTextAreaField('Description', 'Enter your Description', _descriptionController),
          _buildImagePicker(),
          _buildElevatedButton(),
        ],
      ),
    );
  }

  Widget _buildDateTextField() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: "Select Date",
          labelText: "Date",
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select a date";
          }
          return null;
        },
        onTap: () => _selectDate(context),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_imageFile != null)
          Image.file(
            _imageFile!,
            height: 150,
          ),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text("Upload Photo"),
        ),
      ],
    );
  }

  Widget _buildTextField(String labelText, String hintText, TextInputType inputType, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
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

  Widget _buildTextAreaField(String labelText, String hintText, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
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

  Widget _buildDropDownFormField(String labelText, String hintText) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: double.maxFinite,
      height: 60,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
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
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildDropDownFormFieldType(String labelText, String hintText) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      width: double.maxFinite,
      height: 60,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
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
        },
        validator: (value) => value == null ? 'Please select a type' : null,
      ),
    );
  }

  Widget _buildElevatedButton() {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.maxFinite,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF45BF7A),
          foregroundColor: Colors.white,
        ),
        onPressed: () async{
          setState(() => _isLoading = true);
          await context.read<FakestoreLoginLogic>().read();
          // Using `Provider.of` with `listen: false` to get data once
          FakestoreLoginLogic loginLogic = Provider.of<FakestoreLoginLogic>(context, listen: false);
          MyResponseModel responseModel = loginLogic.responseModel;
          // MyResponseModel responseModel =
          //     context.watch<FakestoreLoginLogic>().responseModel;

          if (_formKey.currentState!.validate()) {
             String p = "";
            print("User ID: ${responseModel.user?.id}");
            if (_imageFile != null) {
              await FakestoreService.uploadImage(_imageFile!).then((path)  {
                p =  path.toString();
                // Navigator.pushNamed(context, '/login');
              }).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(e.toString()),
                ));
                 setState(() => _isLoading = false);
                return;
              });
            }
            Doc post = Doc(
              userId: "${responseModel.user?.id ?? ''}",
              title: _titleController.text,
              description: _descriptionController.text,
              categoryId: _selectVal,
              type: _selectType,
              location: _locationController.text,
              phone: _phoneController.text,
              date: _dateController.text,
              status: "active",
              images: p,
            );

            PostSeevice.insert(post).then((value) {
              if (value == "success") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Form submitted successfully')),
                );
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LostFoundScreen()),
            );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Form submission failed')),
                );
              }
            }).catchError((e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            });
             setState(() => _isLoading = false);
          }
        },
        child: Text('Create Post'),
      ),
    );
  }
}
