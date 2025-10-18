import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:profile_explorer/Data/Model/user_model.dart';

class UserService {
  final String _apiUrl = "https://randomuser.me/api/?results=20";

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'] as List;

        return results.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error or Data Decoding Failed: $e');
    }
  }
}
