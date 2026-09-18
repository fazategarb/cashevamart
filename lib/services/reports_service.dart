import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// Service untuk laporan keuangan dan SHU per anggota
class ReportsService {
  ReportsService._();
  static final ReportsService instance = ReportsService._();

  /// Ambil laporan keuangan keseluruhan
  Future<Map<String, dynamic>> getLaporanKeuangan() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.reportLaporan);
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[REPORTS] getLaporanKeuangan error: $e');
    }

    // Demo fallback
    return {
      'periode': 'Agustus 2026',
      'totalPendapatan': 412000000,
      'totalBiayaOperasional': 127000000,
      'pendapatanBersih': 285000000,
      'totalSimpanan': 1340000000,
      'totalPinjaman': 940000000,
      'totalAset': 4805000000,
      'rasioLikuiditas': 510.6,
    };
  }

  /// Ambil data SHU per anggota
  Future<List<Map<String, dynamic>>> getShuAnggota() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.reportShuAnggota);
      if (res is List) {
        return res.whereType<Map<String, dynamic>>().toList();
      }
    } catch (e) {
      debugPrint('[REPORTS] getShuAnggota error: $e');
    }

    // Demo fallback data identik website shuRows
    return [
      {'nrp': '11020033', 'nama': 'Letkol Cba Dedi Kurnia', 'modal': 17300000, 'transaksi': 24500000},
      {'nrp': '11060078', 'nama': 'Kapten Inf Rahmat Hidayat', 'modal': 10850000, 'transaksi': 18200000},
      {'nrp': '21980045', 'nama': 'Serma Budi Santoso', 'modal': 6500000, 'transaksi': 9400000},
      {'nrp': '21930112', 'nama': 'Pelda Agus Wibowo', 'modal': 8000000, 'transaksi': 11200000},
      {'nrp': '198504112009', 'nama': 'Penata Muda Sri Wahyuni', 'modal': 4700000, 'transaksi': 6100000},
      {'nrp': '11150221', 'nama': 'Mayor Kav Fajar Nugroho', 'modal': 14000000, 'transaksi': 15800000},
    ];
  }
}
