import 'package:crud_api/providers/item_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:provider/provider.dart';
import 'package:crud_api/models/person_model.dart';

class EditPersonScreen extends StatefulWidget {
  final Record person; // Pass the current person to edit

  EditPersonScreen({required this.person});

  @override
  _EditPersonScreenState createState() => _EditPersonScreenState();
}

class _EditPersonScreenState extends State<EditPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _idNumberController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _languageController;
  late TextEditingController _interestsController;
  DateTime? _selectedDate;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.person.name);
    _surnameController = TextEditingController(text: widget.person.surname);
    _idNumberController = TextEditingController(text: widget.person.idNumber);
    _mobileController = TextEditingController(text: widget.person.mobile);
    _emailController = TextEditingController(text: widget.person.email);
    _languageController = TextEditingController(text: widget.person.language);
    _interestsController =
        TextEditingController(text: widget.person.interests?.join(", "));
    _selectedDate = widget.person.birthDate != null
        ? DateFormat('yyyy-MM-dd').parse(widget.person.birthDate!)
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _idNumberController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _languageController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      List<String> interests = _interestsController.text
          .split(',')
          .map((interest) => interest.trim())
          .toList();

      final updatedPerson = Record(
        id: widget.person.id, // Ensure the ID is passed
        name: _nameController.text,
        surname: _surnameController.text,
        idNumber: _idNumberController.text,
        mobile: _mobileController.text,
        email: _emailController.text,
        birthDate: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
        language: _languageController.text,
        interests: interests,
      );

      try {
        await Provider.of<ItemProvider>(context, listen: false)
            .updateItem(widget.person.id!, updatedPerson);
        // await Provider.of<ItemProvider>(context, listen: false)
        //     .editData(context, updatedPerson);
        Navigator.pop(context); // Go back to the previous screen on success
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update person')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Person')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'NAME'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: 'SURNAME'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a surname' : null,
                ),
                TextFormField(
                  controller: _idNumberController,
                  decoration: InputDecoration(labelText: 'ID NUMBER'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an ID number' : null,
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(labelText: 'MOBILE'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a mobile number' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'EMAIL'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an email' : null,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        //labelText: 'BIRTH DATE',
                        hintText: _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : 'Select a birth date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value) => _selectedDate == null
                          ? 'Please select a birth date'
                          : null,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _languageController,
                  decoration: InputDecoration(labelText: 'LANGUAGE'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a language' : null,
                ),
                TextFormField(
                  controller: _interestsController,
                  decoration:
                      InputDecoration(labelText: 'INTERESTS (comma separated)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter interests' : null,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                  child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 20),
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _submitForm();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                  child: Text(
                                'Update',
                                style: TextStyle(fontSize: 20),
                              )),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
