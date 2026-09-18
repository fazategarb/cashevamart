import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// Service untuk manajemen user sistem (CRUD users)
class UsersService {
  UsersService._();
  static final UsersService instance = UsersService._();

  /// Demo data identik website systemUsers di casheva-data.ts
  static final List<Map<String, dynamic>> _demoUsers = [
    {'id': 'USR-001', 'nama': 'Mayor Cba Arif Setiawan', 'nrp': '11110234', 'role': 'ADMIN_KOPERASI', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '06 Agu 2026 06:10'},
    {'id': 'USR-002', 'nama': 'Kolonel Inf Bagus Prayitno', 'nrp': '10980017', 'role': 'PIMPINAN', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '05 Agu 2026 16:42'},
    {'id': 'USR-003', 'nama': 'Letkol Cba Dedi Kurnia', 'nrp': '11020033', 'role': 'KEPRIM', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '05 Agu 2026 14:20'},
    {'id': 'USR-004', 'nama': 'Serma Budi Santoso', 'nrp': '21980045', 'role': 'BENDAHARA', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '06 Agu 2026 05:55'},
    {'id': 'USR-005', 'nama': 'Kapten Inf Rahmat Hidayat', 'nrp': '11060078', 'role': 'PENGAWAS', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '04 Agu 2026 09:31'},
    {'id': 'USR-006', 'nama': 'Penata Muda Sri Wahyuni', 'nrp': '198504112009', 'role': 'BENDAHARA', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Nonaktif', 'lastLogin': '21 Jul 2026 11:04'},
    {'id': 'USR-007', 'nama': 'Pelda Agus Wibowo', 'nrp': '21930112', 'role': 'JURU_BAYAR', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '05 Agu 2026 08:12'},
    {'id': 'USR-008', 'nama': 'Sertu Hendra Gunawan', 'nrp': '31770091', 'role': 'ANGGOTA', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '06 Agu 2026 07:05'},
    {'id': 'USR-009', 'nama': 'Serda Yoga Pratama', 'nrp': '31800142', 'role': 'KASIR_TOKO', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'status': 'Aktif', 'lastLogin': '06 Agu 2026 08:00'},
  ];

  /// Ambil seluruh user
  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.users);
      if (res is List) return res.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('[USERS] getAll error: $e');
    }
    return _demoUsers;
  }

  /// Ambil user berdasarkan ID
  Future<Map<String, dynamic>?> getById(String id) async {
    try {
      final res = await ApiService.instance.get(ApiConfig.userById(id));
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[USERS] getById error: $e');
    }
    return _demoUsers.firstWhere((u) => u['id'] == id, orElse: () => {});
  }

  /// Buat user baru
  Future<Map<String, dynamic>?> create(Map<String, dynamic> data) async {
    try {
      final res = await ApiService.instance.post(ApiConfig.users, body: data);
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[USERS] create error: $e');
      rethrow;
    }
    return null;
  }

  /// Update user
  Future<Map<String, dynamic>?> update(String id, Map<String, dynamic> data) async {
    try {
      final res = await ApiService.instance.patch(ApiConfig.userById(id), body: data);
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[USERS] update error: $e');
      rethrow;
    }
    return null;
  }

  /// Hapus user
  Future<void> delete(String id) async {
    try {
      await ApiService.instance.delete(ApiConfig.userById(id));
    } catch (e) {
      debugPrint('[USERS] delete error: $e');
      rethrow;
    }
  }
}
