import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  UserEntity? _user;
  bool _isLoading = false;
  AuthProvider({required this.loginUser});
  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await loginUser(email, password);
    } catch (e) {}
    _isLoading = false;
    notifyListeners();
  }
  void logout() { _user = null; notifyListeners(); }
}