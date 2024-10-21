import 'dart:convert';
import 'package:crud_api/models/person_model.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      'http://192.168.1.100:8000/api'; // Replace with your local IP

  // Register a new user
  Future<http.Response> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/register'),
      body: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  // Login user and return token
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  // Store token in shared preferences
  Future<void> storeToken(String token) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('token', token);
  }

  // Retrieve token from shared preferences
  Future<String?> getToken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString('token');
  }

  // Logout user by clearing token
  Future<void> logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('token');
  }

  // Fetch items (protected by token)
  Future<PersonModel> fetchAllPersons() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/get-people-records')); // Update endpoint if needed

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return PersonModel.fromJson(jsonData);
    } else {
      print('Failed to load persons. Status code: ${response.statusCode}');
      throw Exception('Failed to load persons');
    }
  }

  // CRUD Operations (same as before, with token in headers)
  Future<void> createItem(Record person) async {
    // String? token = await getToken();
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/store-people'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(person.toJson()),
    );
    if (response.statusCode == 201) {
      print('Person created successfully!');
      return null;
    } else {
      // Log the response for debugging
      // throw Exception('Failed to create person');
    }
  }

  Future<void> updateItem(Record person) async {
    // String? token = await getToken();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/update-people-record'),
      headers: {
        // 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(person.toJson()),
    );
    if (response.statusCode == 200) {
      print('Person updated successfully!');
    } else {
      print('Failed to update person. Status code: ${response.statusCode}');
      print(
          'Response body: ${response.body}'); // Log the response body for debugging
      //  throw Exception('Failed to update person');
    }
  }

  Future<void> deleteItem(int id) async {
    //  String? token = await getToken();
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/delete-people-record/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }
}
