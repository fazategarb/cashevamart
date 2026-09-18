import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/anggota.dart';
import 'api_service.dart';

/// Service untuk CRUD data anggota koperasi
class AnggotaService {
  AnggotaService._();
  static final AnggotaService instance = AnggotaService._();

  /// Demo data anggota identik dengan website casheva-data.ts anggotaList
  static final List<Map<String, dynamic>> _demoAnggota = [
    {'nrp': '11020033', 'nama': 'Dedi Kurnia', 'pangkat': 'Letkol Cba', 'golongan': 'Pamen', 'korps': 'Cba', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 4800000, 'simpananSukarela': 12500000, 'creditLimit': 10000000, 'tipeAnggota': 'ORGANIK', 'status': 'Aktif'},
    {'nrp': '11060078', 'nama': 'Rahmat Hidayat', 'pangkat': 'Kapten Inf', 'golongan': 'Pama', 'korps': 'Inf', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 3600000, 'simpananSukarela': 7250000, 'creditLimit': 7500000, 'tipeAnggota': 'ORGANIK', 'status': 'Aktif'},
    {'nrp': '21980045', 'nama': 'Budi Santoso', 'pangkat': 'Serma', 'golongan': 'Bintara', 'korps': 'Chb', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 2400000, 'simpananSukarela': 4100000, 'creditLimit': 5000000, 'tipeAnggota': 'ORGANIK', 'status': 'Aktif'},
    {'nrp': '21930112', 'nama': 'Agus Wibowo', 'pangkat': 'Pelda', 'golongan': 'Bintara', 'korps': 'Czi', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 2700000, 'simpananSukarela': 5300000, 'creditLimit': 5000000, 'tipeAnggota': 'ORGANIK', 'status': 'Cuti'},
    {'nrp': '198504112009', 'nama': 'Sri Wahyuni', 'pangkat': 'Penata Muda', 'golongan': 'PNS', 'korps': 'PNS', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 1800000, 'simpananSukarela': 2900000, 'creditLimit': 4000000, 'tipeAnggota': 'ORGANIK', 'status': 'Aktif'},
    {'nrp': '11150221', 'nama': 'Fajar Nugroho', 'pangkat': 'Mayor Kav', 'golongan': 'Pamen', 'korps': 'Kav', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 4200000, 'simpananSukarela': 9800000, 'creditLimit': 8000000, 'tipeAnggota': 'ORGANIK', 'status': 'Aktif'},
    {'nrp': '31770091', 'nama': 'Hendra Gunawan', 'pangkat': 'Sertu', 'golongan': 'Bintara', 'korps': 'Inf', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 1500000, 'simpananSukarela': 1750000, 'creditLimit': 3500000, 'tipeAnggota': 'ORGANIK', 'status': 'Aktif'},
    {'nrp': '11090154', 'nama': 'Wahyu Prasetyo', 'pangkat': 'Lettu Chb', 'golongan': 'Pama', 'korps': 'Chb', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'simpananWajib': 3000000, 'simpananSukarela': 6400000, 'creditLimit': 6000000, 'tipeAnggota': 'ORGANIK', 'status': 'Non-Aktif'},
  ];

  /// Ambil seluruh data anggota
  Future<List<Anggota>> getAll() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.anggota);
      if (res is List) {
        return res
            .whereType<Map<String, dynamic>>()
            .map((e) => Anggota.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('[ANGGOTA] getAll error: $e');
    }

    // Demo fallback
    return _demoAnggota.map((e) => Anggota.fromJson(e)).toList();
  }

  /// Ambil anggota berdasarkan ID
  Future<Anggota?> getById(String id) async {
    try {
      final res = await ApiService.instance.get(ApiConfig.anggotaById(id));
      if (res is Map<String, dynamic>) return Anggota.fromJson(res);
    } catch (e) {
      debugPrint('[ANGGOTA] getById error: $e');
    }
    return null;
  }

  /// Tambah anggota baru
  Future<Anggota?> create(Map<String, dynamic> data) async {
    try {
      final res = await ApiService.instance.post(ApiConfig.anggota, body: data);
      if (res is Map<String, dynamic>) return Anggota.fromJson(res);
    } catch (e) {
      debugPrint('[ANGGOTA] create error: $e');
      rethrow;
    }
    return null;
  }

  /// Update data anggota
  Future<Anggota?> update(String id, Map<String, dynamic> data) async {
    try {
      final res = await ApiService.instance.patch(ApiConfig.anggotaById(id), body: data);
      if (res is Map<String, dynamic>) return Anggota.fromJson(res);
    } catch (e) {
      debugPrint('[ANGGOTA] update error: $e');
      rethrow;
    }
    return null;
  }

  /// Hapus anggota
  Future<void> delete(String id) async {
    try {
      await ApiService.instance.delete(ApiConfig.anggotaById(id));
    } catch (e) {
      debugPrint('[ANGGOTA] delete error: $e');
      rethrow;
    }
  }
}
