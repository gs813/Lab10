import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// ===========================================================
/// User API Service
/// ติดต่อกับ FakeStoreAPI สำหรับ CRUD Users
/// ===========================================================
class UserApiService {
  static const String _baseUrl = 'https://fakestoreapi.com/users';

  /// Common headers สำหรับทุก request
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  /// -----------------------------------------------------------
  /// GET : Fetch All Users
  /// -----------------------------------------------------------
  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(_baseUrl));
    final data = _handleResponse(response) as List;

    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  /// -----------------------------------------------------------
  /// GET : Fetch User By ID
  /// -----------------------------------------------------------
  Future<UserModel> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    final data = _handleResponse(response);

    return UserModel.fromJson(data);
  }

  /// -----------------------------------------------------------
  /// POST : Create User
  /// -----------------------------------------------------------
  Future<UserModel> createUser(UserModel user) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    final data = _handleResponse(response);
    return UserModel.fromJson(data);
  }

  /// -----------------------------------------------------------
  /// PUT : Update User
  /// -----------------------------------------------------------
  Future<UserModel> updateUser(int id, UserModel user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: _headers,
      body: jsonEncode(user.toJson()),
    );

    final data = _handleResponse(response);
    return UserModel.fromJson(data);
  }

  /// -----------------------------------------------------------
  /// DELETE : Remove User
  /// -----------------------------------------------------------
  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    _handleResponse(response);
  }

  /// ===========================================================
  /// Common Response Handler
  /// ลดโค้ดซ้ำ + จัดการ error รวมศูนย์
  /// ===========================================================
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    throw Exception(
      'API Error: ${response.statusCode}\nResponse: ${response.body}',
    );
  }
}
