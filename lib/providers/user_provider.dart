import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_api_service.dart';

class UserProvider extends ChangeNotifier {
  final UserApiService _api = UserApiService();

  /// -------------------- STATE --------------------
  final List<UserModel> _users = [];
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  /// -------------------- GETTERS --------------------
  List<UserModel> get users => List.unmodifiable(_users);
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.id == 1;
  String? get error => _error;

  /// -------------------- PRIVATE HELPERS --------------------
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  /// =========================================================
  /// LOAD USERS
  /// =========================================================
  Future<void> loadUsers() async {
    _setLoading(true);
    _setError(null);

    try {
      final fetchedUsers = await _api.fetchUsers();
      _users
        ..clear()
        ..addAll(fetchedUsers);
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  /// =========================================================
  /// LOGIN
  /// =========================================================
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      if (_users.isEmpty) {
        await loadUsers();
      }

      final user = _users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
      );

      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError("Email หรือ Password ไม่ถูกต้อง");
      return false;
    }
  }

  /// =========================================================
  /// ADD USER
  /// =========================================================
  Future<void> addUser(UserModel user) async {
    _setLoading(true);
    _setError(null);

    try {
      final newUser = await _api.createUser(user);
      _users.add(newUser);
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  /// =========================================================
  /// EDIT USER
  /// =========================================================
  Future<void> editUser(int id, UserModel user) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedUser = await _api.updateUser(id, user);
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updatedUser;
      }
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  /// =========================================================
  /// DELETE USER
  /// =========================================================
  Future<void> removeUser(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      await _api.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
    } catch (e) {
      _setError(e.toString());
    }

    _setLoading(false);
  }

  /// =========================================================
  /// LOGOUT
  /// =========================================================
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
