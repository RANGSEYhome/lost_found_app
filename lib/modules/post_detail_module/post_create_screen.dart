import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/lost_found_module/lost_found_screen.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'dart:io';

// import 'package:lost_found_app/modules/post_detail_module/post_model.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';

import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';
import 'package:lost_found_app/modules/login_module/fakestore_service.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  // final _category = ["people", "pets","stuffs", "others"];
  String _selectVal = "people";

  // final _type = ["lost", "found"];
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> sendTelegramNotification(Doc post) async {
    const String botToken =
        "7502527933:AAEsmBCy-ja8EpRr0smIQBo-rNRhuh4izrc"; // Replace with your bot token
    // const String chatId = "298697300"; // Replace with your chat ID
    List<String> chatIds = ["298697300", "351373897", "534190102", "226209214"];

    // Format the message
    String message = """
📢 *New Post Created* 📢
📝 *Title:* ${post.title}
📍 *Location:* ${post.location}
📅 *Date:* ${post.date}
📞 *Phone:* ${post.phone}
📖 *Description:* ${post.description}
🔖 *Type:* ${post.type[0].toUpperCase()}${post.type.substring(1)}
🗂 *Category:* ${post.categoryId}
""";

    String url =
        "https://api.telegram.org/bot7502527933:AAEsmBCy-ja8EpRr0smIQBo-rNRhuh4izrc/sendMessage";

    try {
      for (String chatId in chatIds) {
        try {
          await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "chat_id": chatId,
              "text": message,
              "parse_mode": "Markdown",
            }),
          );
        } catch (e) {
          print("Failed to send notification to $chatId: $e");
        }
      }
    } catch (e) {
      print("Failed to send Telegram notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Language _lang = context.watch<LanguageLogic>().lang;

    return Scaffold(
      appBar: AppBar(
        title: Text(_lang.createPost),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          //child: _buildCreatePostForm(),
          child: _isLoading
              ? CircularProgressIndicator()
              : _buildCreatePostForm(_lang),
        ),
      ),
    );
  }

  Widget _buildCreatePostForm(Language _lang) {
    final Map<String, String> _types = {
      'lost': _lang.lost,
      'found': _lang.found,
    };

    final Map<String, String> _categories = {
      'people': _lang.people,
      'pets': _lang.pets,
      'stuffs': _lang.stuffs,
      'others': _lang.others,
    };
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildDropDownFormFieldType(
              _lang.type, _lang.selectType, _lang, _types),
          _buildDropDownFormField(
              _lang.category, _lang.selectCategory, _lang, _categories),
          _buildTextField(_lang.title, _lang.title, TextInputType.text,
              _titleController, _lang),
          _buildDateTextField(_lang),
          _buildTextField(_lang.location, _lang.location, TextInputType.text,
              _locationController, _lang),
          _buildTextField(_lang.phone, _lang.phone, TextInputType.phone,
              _phoneController, _lang),
          _buildTextAreaField(_lang.description, _lang.description,
              _descriptionController, _lang),
          _buildImagePicker(_lang),
          _buildElevatedButton(_lang),
        ],
      ),
    );
  }

  Widget _buildDateTextField(Language _lang) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: _lang.selectDate,
          labelText: _lang.date,
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
            return _lang.selectDate;
          }
          return null;
        },
        onTap: () => _selectDate(context),
      ),
    );
  }

  Widget _buildImagePicker(Language _lang) {
    return Column(
      children: [
        if (_imageFile != null)
          Image.file(
            _imageFile!,
            height: 150,
          ),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text(_lang.uploadImages),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String labelText,
      String hintText,
      TextInputType inputType,
      TextEditingController controller,
      Language _lang) {
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
            return _lang.noEmpty;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextAreaField(String labelText, String hintText,
      TextEditingController controller, Language _lang) {
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
            return _lang.noEmpty;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropDownFormField(String labelText, String hintText,
      Language _lang, Map<String, String> categories) {
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
        items: categories.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectVal = value as String;
          });
        },
        validator: (value) => value == null ? _lang.selectCategory : null,
      ),
    );
  }

  Widget _buildDropDownFormFieldType(String labelText, String hintText,
      Language _lang, Map<String, String> types) {
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
        items: types.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectType = value as String;
          });
        },
        validator: (value) => value == null ? _lang.selectType : null,
      ),
    );
  }

  Widget _buildElevatedButton(Language _lang) {
    return Container(
      margin: EdgeInsets.all(10),
      width: double.maxFinite,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF45BF7A),
          foregroundColor: Colors.white,
        ),
        onPressed: _isLoading
            ? null
            : () async {
                if (!_formKey.currentState!.validate()) {
                  return; // Stop submission if the form is invalid
                }

                if (_imageFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_lang.selectPhoto)),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                try {
                  await context.read<FakestoreLoginLogic>().read();
                  FakestoreLoginLogic loginLogic =
                      Provider.of<FakestoreLoginLogic>(context, listen: false);
                  MyResponseModel responseModel = loginLogic.responseModel;

                  if (responseModel.user?.id == null ||
                      responseModel.user!.id!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('User ID is missing. Please log in again.')),
                    );
                    setState(() => _isLoading = false);
                    return;
                  }

                  String imagePath = "";
                  try {
                    imagePath =
                        (await FakestoreService.uploadImage(_imageFile!))!;
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${_lang.failUpload}: $e'),
                    ));
                    setState(() => _isLoading = false);
                    return;
                  }
// responseModel.user!.id!
                  Doc post = Doc(
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

                  String result = await PostSeevice.insert(post);
                  if (result == "success") {
                    await sendTelegramNotification(post);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_lang.postCreateSuccess)),
                    );
                    context.read<PostLogic>().read();
                    context
                        .read<PostLogic>()
                        .readByUser(responseModel.user!.id); // Refresh posts
                    Navigator.pop(context, true); // Navigate back
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_lang.failPost)),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${_lang.errorOccured}: $e'),
                  ));
                } finally {
                  setState(() => _isLoading = false);
                }
              },
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(_lang.createPost),
      ),
    );
  }
}
