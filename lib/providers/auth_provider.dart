import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

/// Provider Autentikasi dan State Pengguna
class AuthProvider extends ChangeNotifier {
  UserSessionData? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;

  UserSessionData? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Current active role (may be switched by Admin for preview)
  Role get activeRole => _currentUser?.role ?? Role.anggota;

  /// Original actual login role
  Role get originalRole => _currentUser?.originalRole ?? _currentUser?.role ?? Role.anggota;

  bool get isAdmin => originalRole == Role.adminKoperasi || _currentUser?.role == Role.adminKoperasi;

  AuthProvider() {
    _initSession();
  }

  Future<void> _initSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await AuthService.instance.restoreSession();
      // If no stored session, default to demo admin for seamless UX
      _currentUser ??= AuthService.demoAccounts.first;
    } catch (e) {
      debugPrint('[AUTH PROVIDER] Init error: $e');
      _currentUser = AuthService.demoAccounts.first;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await AuthService.instance.login(username, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Switch role on the fly (for Admin role switcher toolbar)
  Future<void> switchRole(Role newRole) async {
    if (_currentUser == null) return;
    final orig = _currentUser!.originalRole ?? _currentUser!.role;

    // Find demo account for the target role to populate realistic role profile
    final demoForRole = AuthService.demoAccounts.firstWhere(
      (a) => a.role == newRole,
      orElse: () => _currentUser!,
    );

    _currentUser = _currentUser!.copyWith(
      role: newRole,
      originalRole: orig,
      namaLengkap: demoForRole.namaLengkap,
      username: demoForRole.username,
      anggota: demoForRole.anggota,
    );

    await AuthService.instance.saveActiveRole(newRole, orig);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await AuthService.instance.logout();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}
