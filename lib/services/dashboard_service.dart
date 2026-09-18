import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// Service untuk mengambil data dashboard (summary KPI + chart data)
class DashboardService {
  DashboardService._();
  static final DashboardService instance = DashboardService._();

  /// Ambil ringkasan dashboard (total anggota, simpanan, pinjaman, dll)
  Future<Map<String, dynamic>> getSummary() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.dashboardSummary);
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[DASHBOARD] getSummary error: $e');
    }

    // Demo fallback data identik website
    return {
      'totalAnggota': 127,
      'totalSimpanan': 1340000000,
      'totalPinjaman': 940000000,
      'pinjamanAktif': 38,
      'totalAset': 4805000000,
      'shuTahunIni': 285000000,
      'angsuranBulanIni': 366000000,
      'targetAngsuran': 380000000,
      'simpananWajib': 820000000,
      'simpananSukarela': 520000000,
      'pendapatan': 412000000,
      'biayaOperasional': 127000000,
      'labaKotor': 285000000,
      'antreanVerifikasi': 3,
      'antreanRekomendasi': 4,
      'antreanAcc': 2,
      'menungguCairan': 1,
    };
  }

  /// Ambil data chart tren simpanan & pinjaman bulanan
  Future<Map<String, dynamic>> getCharts({int? tahun}) async {
    try {
      final res = await ApiService.instance.get(ApiConfig.dashboardCharts(tahun: tahun));
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[DASHBOARD] getCharts error: $e');
    }

    // Demo fallback chart data identik website casheva-data.ts
    return {
      'trenData': [
        {'bulan': 'Jan', 'simpanan': 820, 'pinjaman': 540},
        {'bulan': 'Feb', 'simpanan': 880, 'pinjaman': 610},
        {'bulan': 'Mar', 'simpanan': 940, 'pinjaman': 700},
        {'bulan': 'Apr', 'simpanan': 1010, 'pinjaman': 665},
        {'bulan': 'Mei', 'simpanan': 1090, 'pinjaman': 780},
        {'bulan': 'Jun', 'simpanan': 1180, 'pinjaman': 820},
        {'bulan': 'Jul', 'simpanan': 1265, 'pinjaman': 905},
        {'bulan': 'Agu', 'simpanan': 1340, 'pinjaman': 940},
        {'bulan': 'Sep', 'simpanan': 1420, 'pinjaman': 1010},
        {'bulan': 'Okt', 'simpanan': 1505, 'pinjaman': 1080},
        {'bulan': 'Nov', 'simpanan': 1590, 'pinjaman': 1120},
        {'bulan': 'Des', 'simpanan': 1690, 'pinjaman': 1195},
      ],
      'angsuranData': [
        {'bulan': 'Jan', 'target': 320, 'realisasi': 298},
        {'bulan': 'Feb', 'target': 325, 'realisasi': 315},
        {'bulan': 'Mar', 'target': 330, 'realisasi': 322},
        {'bulan': 'Apr', 'target': 340, 'realisasi': 305},
        {'bulan': 'Mei', 'target': 352, 'realisasi': 344},
        {'bulan': 'Jun', 'target': 360, 'realisasi': 358},
        {'bulan': 'Jul', 'target': 371, 'realisasi': 349},
        {'bulan': 'Agu', 'target': 380, 'realisasi': 366},
      ],
      'pengajuanSatuanData': [
        {'bulan': 'Mar', 'pengajuan': 12, 'disetujui': 9},
        {'bulan': 'Apr', 'pengajuan': 15, 'disetujui': 12},
        {'bulan': 'Mei', 'pengajuan': 11, 'disetujui': 10},
        {'bulan': 'Jun', 'pengajuan': 18, 'disetujui': 14},
        {'bulan': 'Jul', 'pengajuan': 21, 'disetujui': 17},
        {'bulan': 'Agu', 'pengajuan': 16, 'disetujui': 11},
      ],
      'likuiditasData': [
        {'bulan': 'Mar', 'kas': 4200, 'pencairan': 980},
        {'bulan': 'Apr', 'kas': 4380, 'pencairan': 1120},
        {'bulan': 'Mei', 'kas': 4510, 'pencairan': 1040},
        {'bulan': 'Jun', 'kas': 4290, 'pencairan': 1380},
        {'bulan': 'Jul', 'kas': 4620, 'pencairan': 1210},
        {'bulan': 'Agu', 'kas': 4805, 'pencairan': 1150},
      ],
    };
  }
}
