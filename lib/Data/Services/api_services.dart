import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:profile_explorer/Data/Model/user_model.dart';


class UserService {
  final String _apiUrl = "https://randomuser.me/api/?results=20";

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final data = json.decode(response.body);
        final List results = data['results'] as List;
        
        // Map the results list to a list of UserModel objects
        return results.map((json) => UserModel.fromJson(json)).toList();
      } else {
        // Handle API errors
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or decoding errors
      throw Exception('Network Error or Data Decoding Failed: $e');
    }
  }
}

