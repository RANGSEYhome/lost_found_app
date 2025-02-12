import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';
import 'dart:io';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';
// import 'package:lost_found_app/modules/post_detail_module/post_service.dart';
import 'package:lost_found_app/modules/login_module/fakestore_service.dart';
import 'package:provider/provider.dart';

class UpdatePostScreen extends StatefulWidget {
  final Doc item;
  UpdatePostScreen(this.item);

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _category = ["people", "animal", "other"];
  late String _selectVal = widget.item.categoryId;
  final _type = ["lost", "found"];
  late String _selectType = widget.item.type;


  late final TextEditingController _titleController = TextEditingController(text: widget.item.title);
  late final TextEditingController _locationController = TextEditingController(text: widget.item.location);
  late final TextEditingController _phoneController = TextEditingController(text: widget.item.phone);
  late final TextEditingController _descriptionController = TextEditingController(text: widget.item.description);
  late final TextEditingController _dateController = TextEditingController(text: widget.item.date);

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
        title: Text('Update Post'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
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
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: "Select Date",
          labelText: "Date",
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
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
    String? image = widget.item.images;

    return Column(
      children: [
        if (_imageFile != null)
          Image.file(_imageFile!, height: 150),
        if (_imageFile == null && image != null && image.isNotEmpty)
          Image.network(image, height: 150, errorBuilder: (context, error, stackTrace) {
            return Text("Failed to load image");
          }),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text("Upload Photo"),
        ),
      ],
    );
  }

  Widget _buildTextField(String labelText, String hintText, TextInputType inputType, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
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
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
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
      margin: EdgeInsets.all(10),
      child: DropdownButtonFormField(
        value: _selectVal,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
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
      margin: EdgeInsets.all(10),
      child: DropdownButtonFormField(
        value: _selectType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
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
        onPressed: _isLoading ? null : () async {
          if (!_formKey.currentState!.validate()) return;

          setState(() => _isLoading = true);

          try {
            await context.read<FakestoreLoginLogic>().read();
            FakestoreLoginLogic loginLogic = Provider.of<FakestoreLoginLogic>(context, listen: false);
            MyResponseModel responseModel = loginLogic.responseModel;

            String imagePath = widget.item.images;
            if (_imageFile != null) {
              imagePath = await FakestoreService.uploadImage(_imageFile!) ?? widget.item.images;
            }

            Doc updatedPost = Doc(
              userId: responseModel.user!,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              categoryId: _selectVal,
              type: _selectType,
              location: _locationController.text.trim(),
              phone: _phoneController.text.trim(),
              date: _dateController.text.trim(),
              status: "active",
              images: imagePath,
            );

            String result = await PostSeevice.update(updatedPost, widget.item.id);
            if (result == "success") {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post updated successfully')));
              context.read<PostLogic>().read();
              context.read<PostLogic>().readByUser(responseModel.user!.id); 
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update post')));
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
          } finally {
            setState(() => _isLoading = false);
          }
        },
        child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Update Post'),
      ),
    );
  }
}
