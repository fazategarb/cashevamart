import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// Service untuk data keuangan koperasi (pendapatan, biaya operasional, ringkasan)
class KeuanganService {
  KeuanganService._();
  static final KeuanganService instance = KeuanganService._();

  /// Ambil data pendapatan
  Future<List<Map<String, dynamic>>> getPendapatan() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.pendapatan);
      if (res is List) {
        return res.whereType<Map<String, dynamic>>().toList();
      }
    } catch (e) {
      debugPrint('[KEUANGAN] getPendapatan error: $e');
    }

    // Demo fallback
    return [
      {'id': 'PDT-001', 'kategori': 'Jasa Pinjaman (Bunga USIPA)', 'jumlah': 285000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'PDT-002', 'kategori': 'Provisi & Administrasi Pinjaman', 'jumlah': 42000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'PDT-003', 'kategori': 'Laba Unit Toko & Usaha', 'jumlah': 68000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'PDT-004', 'kategori': 'Laba Unit Gadai', 'jumlah': 12000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'PDT-005', 'kategori': 'Pendapatan Lainnya', 'jumlah': 5000000, 'bulan': 8, 'tahun': 2026},
    ];
  }

  /// Ambil data biaya operasional
  Future<List<Map<String, dynamic>>> getBiayaOperasional() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.biayaOperasional);
      if (res is List) {
        return res.whereType<Map<String, dynamic>>().toList();
      }
    } catch (e) {
      debugPrint('[KEUANGAN] getBiayaOperasional error: $e');
    }

    // Demo fallback
    return [
      {'id': 'BOP-001', 'kategori': 'Gaji & Honor Karyawan', 'jumlah': 48000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'BOP-002', 'kategori': 'Biaya Operasional Toko', 'jumlah': 32000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'BOP-003', 'kategori': 'Biaya Administrasi & Umum', 'jumlah': 18000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'BOP-004', 'kategori': 'Biaya Penyusutan Aset', 'jumlah': 15000000, 'bulan': 8, 'tahun': 2026},
      {'id': 'BOP-005', 'kategori': 'Biaya Rapat & Kegiatan', 'jumlah': 8500000, 'bulan': 8, 'tahun': 2026},
      {'id': 'BOP-006', 'kategori': 'Biaya Lain-Lain', 'jumlah': 5500000, 'bulan': 8, 'tahun': 2026},
    ];
  }

  /// Ambil ringkasan keuangan keseluruhan
  Future<Map<String, dynamic>> getRingkasan() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.ringkasanKeuangan);
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[KEUANGAN] getRingkasan error: $e');
    }

    // Demo fallback
    return {
      'totalPendapatan': 412000000,
      'totalBiaya': 127000000,
      'labaKotor': 285000000,
      'totalAset': 4805000000,
      'totalSimpanan': 1340000000,
      'totalPinjaman': 940000000,
      'rasioKesehatan': 92.5,
    };
  }
}
