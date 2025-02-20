import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_found_app/core/localization/lang_data.dart';
import 'package:lost_found_app/core/localization/lang_logic.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_logic.dart';
import 'package:lost_found_app/modules/login_module/fakestore_login_models.dart';
import 'package:lost_found_app/modules/post_detail_module/post_get_model.dart';
import 'package:lost_found_app/modules/post_detail_module/post_logic.dart';
import 'package:lost_found_app/modules/post_detail_module/post_seevice.dart';
import 'package:lost_found_app/modules/login_module/fakestore_service.dart';

class UpdatePostScreen extends StatefulWidget {
  final Doc item;
  const UpdatePostScreen(this.item, {Key? key}) : super(key: key);

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final _formKey = GlobalKey<FormState>();

  final _categories = ["people", "pets", "stuffs", "others"];
  final _types = ["lost", "found"];

  late String _selectedCategory;
  late String _selectedType;

  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;

  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _selectedCategory = _categories.contains(widget.item.categoryId)
        ? widget.item.categoryId
        : _categories.first;
    _selectedType =
        _types.contains(widget.item.type) ? widget.item.type : _types.first;

    _titleController = TextEditingController(text: widget.item.title);
    _locationController = TextEditingController(text: widget.item.location);
    _phoneController = TextEditingController(text: widget.item.phone);
    _descriptionController =
        TextEditingController(text: widget.item.description);
    _dateController = TextEditingController(text: widget.item.date);
  }

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

  Future<void> _updatePost(Language _lang) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<FakestoreLoginLogic>().read();
      FakestoreLoginLogic loginLogic =
          Provider.of<FakestoreLoginLogic>(context, listen: false);
      MyResponseModel responseModel = loginLogic.responseModel;

      String imagePath = widget.item.images;
      if (_imageFile != null) {
        imagePath = await FakestoreService.uploadImage(_imageFile!) ??
            widget.item.images;
      }

      Doc updatedPost = Doc(
        userId: responseModel.user!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategory,
        type: _selectedType,
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        date: _dateController.text.trim(),
        status: "active",
        images: imagePath,
      );

      String result = await PostSeevice.update(updatedPost, widget.item.id);
      if (result == "success") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_lang.postUpdateSuccess)));
        context.read<PostLogic>().read();
        context.read<PostLogic>().readByUser(responseModel.user!.id);
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_lang.failUpdate)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${_lang.errorOccured}: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Language _lang = context.watch<LanguageLogic>().lang;
    return Scaffold(
      appBar: AppBar(title: Text(_lang.updatePost)),
      body: Center(
        child: Form(
          key: _formKey,
          child: _isLoading ? CircularProgressIndicator() : _buildForm(_lang),
        ),
      ),
    );
  }

  Widget _buildForm(Language _lang) {
    // final Map<String, String> _typeOption = {
    //   'lost': _lang.lost,
    //   'found': _lang.found,
    // };

    // final Map<String, String> _categoryOption = {
    //   'people': _lang.people,
    //   'pets': _lang.pets,
    //   'stuffs': _lang.stuffs,
    //   'others': _lang.others,
    // };
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _buildDropdown(_lang.type, _selectedType, _types,
              (value) => setState(() => _selectedType = value)),
          _buildDropdown(_lang.category, _selectedCategory, _categories,
              (value) => setState(() => _selectedCategory = value)),
          _buildTextField(_lang, _lang.title, _titleController),
          _buildDateField(_lang),
          _buildTextField(_lang, _lang.location, _locationController),
          _buildTextField(_lang, _lang.phone, _phoneController,
              inputType: TextInputType.phone),
          _buildTextArea(_lang, _lang.description, _descriptionController),
          _buildImagePicker(_lang),
          _buildSubmitButton(_lang),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String> onChanged) {
    return Container(
      margin: EdgeInsets.all(10),
      child: DropdownButtonFormField(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (newValue) => onChanged(newValue as String),
        validator: (value) => value == null ? 'Please select a $label' : null,
      ),
    );
  }

  Widget _buildTextField(
      Language _lang, String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? _lang.noEmpty : null,
      ),
    );
  }

  Widget _buildTextArea(
      Language _lang, String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? _lang.noEmpty : null,
      ),
    );
  }

  Widget _buildDateField(Language _lang) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: _lang.date,
          suffixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? _lang.selectDate : null,
        onTap: () => _selectDate(context),
      ),
    );
  }

  Widget _buildImagePicker(Language _lang) {
    return Column(
      children: [
        if (_imageFile != null) Image.file(_imageFile!, height: 150),
        if (_imageFile == null && widget.item.images.isNotEmpty)
          Image.network(widget.item.images,
              height: 150,
              errorBuilder: (_, __, ___) => Text(_lang.failUpload)),
        ElevatedButton(onPressed: _pickImage, child: Text(_lang.changePhoto)),
      ],
    );
  }

  Widget _buildSubmitButton(Language _lang) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF45BF7A), foregroundColor: Colors.white),
        onPressed: _isLoading ? null : () => _updatePost(_lang),
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(_lang.updatePost),
      ),
    );
  }
}
