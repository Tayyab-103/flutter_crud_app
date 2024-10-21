import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud_api/models/person_model.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ItemProvider with ChangeNotifier {
  // PersonModel? _personModel;
  bool _isLoading = false;
  List<Record> _persons = [];

  List<Record> get persons => _persons;

//  PersonModel? get personModel => _personModel;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  // Fetch all persons and notify listeners
  Future<PersonModel> fetchPersons() async {
    _isLoading = true;
    notifyListeners();
    try {
      print('Fetching persons...');
      return await _apiService.fetchAllPersons();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addItem(Record person) async {
    await _apiService.createItem(person);
    // await fetchPersons(); // Refresh the list after adding
  }

  Future<void> updateItem(int id, Record person) async {
    await _apiService.updateItem(person);
    await fetchPersons(); // Refresh the list after updating
  }

  Future<void> deleteItem(int id) async {
    await _apiService.deleteItem(id);
    await fetchPersons(); // Refresh the list after deleting
  }

  // Future editData(BuildContext context, upDatedPerson) async {
  //   final String apiUrl = upDatedPerson['id'] != null
  //       ? 'http://10.0.2.2:8000/api/update-people-record' // Update record
  //       : 'http://10.0.2.2:8000/api/store-people'; // Create new record

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         // Add authorization if needed: 'Authorization': 'Bearer $token'
  //       },
  //       body: json.encode(upDatedPerson),
  //     );

  //     if (response.statusCode == 200) {
  //       // Assuming the response is successful, refresh the data or do other actions
  //       // fetchPeople(); // Function to fetch updated data (similar to your React example)
  //       //  resetForm(); // Function to reset form fields

  //       // Show success toast
  //     } else {
  //       // Handle non-200 response codes
  //       final responseData = json.decode(response.body);
  //     }
  //   } catch (error) {
  //     // Handle network or API errors

  //     print("Error submitting form: $error");
  //   }
  // }
}
