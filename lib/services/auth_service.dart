import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/anggota.dart';
import 'api_service.dart';

/// Service autentikasi dan manajemen sesi
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _kTokenKey = 'casheva_auth_token';
  static const _kUserKey = 'casheva_user_data';
  static const _kOriginalRoleKey = 'casheva_orig_role';
  static const _kActiveRoleKey = 'casheva_active_role';

  /// Daftar Akun Demo Resmi untuk semua 8 Role Casheva
  static final List<UserSessionData> demoAccounts = [
    UserSessionData(
      id: 'USR-001',
      username: 'admin',
      namaLengkap: 'Mayor Cba Arif Setiawan',
      role: Role.adminKoperasi,
      backendRole: BackendRole.adminKoperasi,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-001',
        nrp: '11110234',
        nama: 'Arif Setiawan',
        pangkat: 'Mayor Cba',
        golongan: 'Pamen',
        korps: 'Cba',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 4200000,
        simpananSukarela: 9800000,
        creditLimit: 15000000,
        status: 'Aktif',
      ),
    ),
    UserSessionData(
      id: 'USR-002',
      username: 'pimpinan',
      namaLengkap: 'Kolonel Inf Bagus Prayitno',
      role: Role.pimpinan,
      backendRole: BackendRole.pimpinan,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-002',
        nrp: '10980017',
        nama: 'Bagus Prayitno',
        pangkat: 'Kolonel Inf',
        golongan: 'Pamen',
        korps: 'Inf',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 6000000,
        simpananSukarela: 25000000,
        creditLimit: 30000000,
        status: 'Aktif',
      ),
    ),
    UserSessionData(
      id: 'USR-003',
      username: 'keprim',
      namaLengkap: 'Letkol Cba Dedi Kurnia',
      role: Role.keprim,
      backendRole: BackendRole.keprim,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-003',
        nrp: '11020033',
        nama: 'Dedi Kurnia',
        pangkat: 'Letkol Cba',
        golongan: 'Pamen',
        korps: 'Cba',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 4800000,
        simpananSukarela: 12500000,
        creditLimit: 20000000,
        status: 'Aktif',
      ),
    ),
    UserSessionData(
      id: 'USR-004',
      username: 'bendahara',
      namaLengkap: 'Serma Budi Santoso',
      role: Role.bendahara,
      backendRole: BackendRole.bendahara,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-004',
        nrp: '21980045',
        nama: 'Budi Santoso',
        pangkat: 'Serma',
        golongan: 'Bintara',
        korps: 'Chb',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 2400000,
        simpananSukarela: 4100000,
        creditLimit: 10000000,
        status: 'Aktif',
      ),
    ),
    UserSessionData(
      id: 'USR-007',
      username: 'jurbay',
      namaLengkap: 'Pelda Agus Wibowo',
      role: Role.juruBayar,
      backendRole: BackendRole.juruBayar,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-007',
        nrp: '21930112',
        nama: 'Agus Wibowo',
        pangkat: 'Pelda',
        golongan: 'Bintara',
        korps: 'Czi',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 2700000,
        simpananSukarela: 5300000,
        creditLimit: 10000000,
        status: 'Aktif',
      ),
    ),
    UserSessionData(
      id: 'USR-009',
      username: 'kasir',
      namaLengkap: 'Serda Yoga Pratama',
      role: Role.kasirToko,
      backendRole: BackendRole.kasirToko,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-009',
        nrp: '31800142',
        nama: 'Yoga Pratama',
        pangkat: 'Serda',
        golongan: 'Bintara',
        korps: 'Inf',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 1200000,
        simpananSukarela: 2000000,
        creditLimit: 5000000,
        status: 'Aktif',
      ),
    ),
    UserSessionData(
      id: 'USR-008',
      username: 'anggota',
      namaLengkap: 'Sertu Hendra Gunawan',
      role: Role.anggota,
      backendRole: BackendRole.anggota,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-008',
        nrp: '31770091',
        nama: 'Hendra Gunawan',
        pangkat: 'Sertu',
        golongan: 'Bintara',
        korps: 'Inf',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 1500000,
        simpananSukarela: 1750000,
        creditLimit: 5000000,
        status: 'Aktif',
      ),
    ),
    UserSessionData(
      id: 'USR-005',
      username: 'pengawas',
      namaLengkap: 'Kapten Inf Rahmat Hidayat',
      role: Role.pengawas,
      backendRole: BackendRole.pengawas,
      satminkal: const Satminkal(id: 'SAT-01', nama: 'INFOLAHTADAM IV/DIPONEGORO', kode: 'INFOLAHTA'),
      kotama: const Kotama(id: 'KOT-01', nama: 'KODAM IV/DIPONEGORO', kode: 'KODAM_IV'),
      isActive: true,
      anggota: const Anggota(
        id: 'ANG-005',
        nrp: '11060078',
        nama: 'Rahmat Hidayat',
        pangkat: 'Kapten Inf',
        golongan: 'Pama',
        korps: 'Inf',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 3600000,
        simpananSukarela: 7250000,
        creditLimit: 12000000,
        status: 'Aktif',
      ),
    ),
  ];

  /// Login via backend API or Demo fallback
  Future<UserSessionData> login(String username, String password) async {
    final cleanUsername = username.trim().toLowerCase();

    // 1. Coba login ke API backend
    try {
      final res = await ApiService.instance.post('/auth/login', body: {
        'username': username,
        'password': password,
      });

      if (res is Map<String, dynamic>) {
        final token = res['access_token']?.toString() ?? res['token']?.toString();
        if (token != null) {
          ApiService.instance.setAuthToken(token);
          await saveToken(token);
        }

        final userItemJson = res['user'] ?? res;
        final user = UserSessionData.fromJson(userItemJson);
        await saveSession(user);
        return user;
      }
    } catch (e) {
      debugPrint('[AUTH] Backend login failed: $e, checking demo accounts');
    }

    // 2. Demo fallback matching usernames or roles
    final demo = demoAccounts.firstWhere(
      (acc) =>
          acc.username.toLowerCase() == cleanUsername ||
          acc.role.name.toLowerCase() == cleanUsername ||
          acc.role.shortLabel.toLowerCase() == cleanUsername ||
          acc.role.label.toLowerCase() == cleanUsername,
      orElse: () => demoAccounts.first, // fallback default admin
    );

    await saveSession(demo);
    return demo;
  }

  /// Restore session from device storage
  Future<UserSessionData?> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_kTokenKey);
      if (token != null) {
        ApiService.instance.setAuthToken(token);
      }

      final userJsonString = prefs.getString(_kUserKey);
      if (userJsonString != null) {
        final map = jsonDecode(userJsonString) as Map<String, dynamic>;
        final user = UserSessionData.fromJson(map);

        // Check if role was switched
        final activeRoleStr = prefs.getString(_kActiveRoleKey);
        final origRoleStr = prefs.getString(_kOriginalRoleKey);

        if (activeRoleStr != null) {
          final activeRole = Role.fromString(activeRoleStr);
          final origRole = origRoleStr != null ? Role.fromString(origRoleStr) : user.role;
          return user.copyWith(
            role: activeRole,
            originalRole: origRole,
          );
        }
        return user;
      }
    } catch (e) {
      debugPrint('[AUTH] Restore session error: $e');
    }
    return null;
  }

  /// Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
  }

  /// Save session data
  Future<void> saveSession(UserSessionData user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_kUserKey, jsonString);
    await prefs.setString(_kActiveRoleKey, user.role.value);
    if (user.originalRole != null) {
      await prefs.setString(_kOriginalRoleKey, user.originalRole!.value);
    }
  }

  /// Switch active role (for Admin previewing other roles)
  Future<void> saveActiveRole(Role activeRole, Role originalRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kActiveRoleKey, activeRole.value);
    await prefs.setString(_kOriginalRoleKey, originalRole.value);
  }

  /// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kUserKey);
    await prefs.remove(_kActiveRoleKey);
    await prefs.remove(_kOriginalRoleKey);
    ApiService.instance.setAuthToken(null);
  }
}
