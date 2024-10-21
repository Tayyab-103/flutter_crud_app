import 'package:crud_api/providers/item_provider.dart';
import 'package:crud_api/views/persons/person_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:crud_api/models/person_model.dart';

class AddPerson extends StatefulWidget {
  const AddPerson({super.key});
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();

  DateTime? selectedDate;
  bool _isLoading = false;

  ItemProvider provider = ItemProvider();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      List<String> interests = interestsController.text
          .split(',')
          .map((interest) => interest.trim())
          .toList();

      // Create a new Record with the form data
      Record newPerson = Record(
        name: nameController.text,
        email: emailController.text,
        surname: surnameController.text,
        mobile: mobileController.text,
        idNumber: idNumberController.text,
        language: languageController.text,
        interests: interests,
        birthDate: selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : null,
      );
      try {
        // Call the provider to store the new person via the API
        print(newPerson.name);
        await Provider.of<ItemProvider>(context, listen: false)
            .addItem(newPerson);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Data Save Successfully")));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonList(),
            ));
      } catch (error) {
        print(error.toString());
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(error.toString())));
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
      appBar: AppBar(
        title: const Text('Add Person'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'NAME', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: surnameController,
                  decoration: const InputDecoration(
                      labelText: 'SURNAME', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the surname';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: idNumberController,
                  maxLength: 5,
                  decoration: const InputDecoration(
                      labelText: 'African NUMBER',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the African number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                      labelText: 'MOBILE', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'EMAIL', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: languageController,
                  decoration: const InputDecoration(
                      labelText: 'LANGUAGE', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the language';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        // labelText: 'BIRTH DATE',
                        // Safely handle null without using the null check operator (!)
                        hintText: selectedDate != null
                            ? DateFormat('MM/dd/yyyy').format(
                                selectedDate!) // When a date is selected
                            : 'mm/dd/yyyy', // Placeholder when no date is selected
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: (value) {
                        if (selectedDate == null) {
                          return 'Please select a birth date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: interestsController,
                  decoration: const InputDecoration(
                      labelText: 'Interests (comma separated)',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
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
                          'Add Person',
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
