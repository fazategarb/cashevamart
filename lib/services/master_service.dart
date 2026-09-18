import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// Service untuk master data TNI AD (Pangkat, Korps, Satminkal, Kotama)
class MasterService {
  MasterService._();
  static final MasterService instance = MasterService._();

  /// Ambil daftar pangkat
  Future<List<Map<String, dynamic>>> getPangkat() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.masterPangkat);
      if (res is List) return res.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('[MASTER] getPangkat error: $e');
    }

    // Demo fallback
    return [
      {'id': 'PKT-01', 'nama': 'Jenderal', 'kategori': 'PATI', 'kodePkt': 94},
      {'id': 'PKT-02', 'nama': 'Letnan Jenderal', 'kategori': 'PATI', 'kodePkt': 93},
      {'id': 'PKT-03', 'nama': 'Mayor Jenderal', 'kategori': 'PATI', 'kodePkt': 92},
      {'id': 'PKT-04', 'nama': 'Brigadir Jenderal', 'kategori': 'PATI', 'kodePkt': 91},
      {'id': 'PKT-05', 'nama': 'Kolonel', 'kategori': 'PAMEN', 'kodePkt': 83},
      {'id': 'PKT-06', 'nama': 'Letnan Kolonel', 'kategori': 'PAMEN', 'kodePkt': 82},
      {'id': 'PKT-07', 'nama': 'Mayor', 'kategori': 'PAMEN', 'kodePkt': 81},
      {'id': 'PKT-08', 'nama': 'Kapten', 'kategori': 'PAMA', 'kodePkt': 73},
      {'id': 'PKT-09', 'nama': 'Letnan Satu', 'kategori': 'PAMA', 'kodePkt': 72},
      {'id': 'PKT-10', 'nama': 'Letnan Dua', 'kategori': 'PAMA', 'kodePkt': 71},
      {'id': 'PKT-11', 'nama': 'Pembantu Letnan Satu', 'kategori': 'BINTARA', 'kodePkt': 66},
      {'id': 'PKT-12', 'nama': 'Pembantu Letnan Dua', 'kategori': 'BINTARA', 'kodePkt': 65},
      {'id': 'PKT-13', 'nama': 'Sersan Mayor', 'kategori': 'BINTARA', 'kodePkt': 64},
      {'id': 'PKT-14', 'nama': 'Sersan Kepala', 'kategori': 'BINTARA', 'kodePkt': 63},
      {'id': 'PKT-15', 'nama': 'Sersan Satu', 'kategori': 'BINTARA', 'kodePkt': 62},
      {'id': 'PKT-16', 'nama': 'Sersan Dua', 'kategori': 'BINTARA', 'kodePkt': 61},
      {'id': 'PKT-17', 'nama': 'Kopral Kepala', 'kategori': 'TAMTAMA', 'kodePkt': 56},
      {'id': 'PKT-18', 'nama': 'Kopral Satu', 'kategori': 'TAMTAMA', 'kodePkt': 55},
      {'id': 'PKT-19', 'nama': 'Kopral Dua', 'kategori': 'TAMTAMA', 'kodePkt': 54},
      {'id': 'PKT-20', 'nama': 'Prajurit Kepala', 'kategori': 'TAMTAMA', 'kodePkt': 53},
      {'id': 'PKT-21', 'nama': 'Prajurit Satu', 'kategori': 'TAMTAMA', 'kodePkt': 52},
      {'id': 'PKT-22', 'nama': 'Prajurit Dua', 'kategori': 'TAMTAMA', 'kodePkt': 51},
    ];
  }

  /// Ambil daftar korps
  Future<List<Map<String, dynamic>>> getKorps() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.masterKorps);
      if (res is List) return res.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('[MASTER] getKorps error: $e');
    }

    // Demo fallback
    return [
      {'id': 'KRP-01', 'nama': 'Infanteri', 'kode': 'Inf'},
      {'id': 'KRP-02', 'nama': 'Kavaleri', 'kode': 'Kav'},
      {'id': 'KRP-03', 'nama': 'Artileri Medan', 'kode': 'Arm'},
      {'id': 'KRP-04', 'nama': 'Artileri Pertahanan Udara', 'kode': 'Arh'},
      {'id': 'KRP-05', 'nama': 'Zeni', 'kode': 'Czi'},
      {'id': 'KRP-06', 'nama': 'Polisi Militer', 'kode': 'Cpm'},
      {'id': 'KRP-07', 'nama': 'Perhubungan', 'kode': 'Chb'},
      {'id': 'KRP-08', 'nama': 'Keuangan', 'kode': 'Cku'},
      {'id': 'KRP-09', 'nama': 'Kesehatan', 'kode': 'Ckm'},
      {'id': 'KRP-10', 'nama': 'Peralatan', 'kode': 'Cpl'},
      {'id': 'KRP-11', 'nama': 'Penerbangan', 'kode': 'Cpn'},
      {'id': 'KRP-12', 'nama': 'Ajudan Jenderal', 'kode': 'Caj'},
      {'id': 'KRP-13', 'nama': 'Topografi', 'kode': 'Ctp'},
      {'id': 'KRP-14', 'nama': 'Hukum', 'kode': 'Chk'},
      {'id': 'KRP-15', 'nama': 'Bekang', 'kode': 'Cba'},
      {'id': 'KRP-16', 'nama': 'Keamanan', 'kode': 'Cke'},
    ];
  }

  /// Ambil daftar satminkal
  Future<List<Map<String, dynamic>>> getSatminkal() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.masterSatminkal);
      if (res is List) return res.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('[MASTER] getSatminkal error: $e');
    }

    // Demo fallback
    return [
      {'id': 'SAT-01', 'nama': 'INFOLAHTADAM IV/DIPONEGORO', 'kode': 'INFOLAHTA'},
      {'id': 'SAT-02', 'nama': 'HUBDAM IV/DIPONEGORO', 'kode': 'HUBDAM'},
      {'id': 'SAT-03', 'nama': 'AJENDAM IV/DIPONEGORO', 'kode': 'AJENDAM'},
      {'id': 'SAT-04', 'nama': 'KUMDAM IV/DIPONEGORO', 'kode': 'KUMDAM'},
      {'id': 'SAT-05', 'nama': 'KESDAM IV/DIPONEGORO', 'kode': 'KESDAM'},
    ];
  }

  /// Ambil daftar kotama
  Future<List<Map<String, dynamic>>> getKotama() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.masterKotama);
      if (res is List) return res.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('[MASTER] getKotama error: $e');
    }

    // Demo fallback
    return [
      {'id': 'KOT-01', 'nama': 'KODAM IV/DIPONEGORO', 'kode': 'KODAM_IV'},
      {'id': 'KOT-02', 'nama': 'KODAM V/BRAWIJAYA', 'kode': 'KODAM_V'},
      {'id': 'KOT-03', 'nama': 'KODAM III/SILIWANGI', 'kode': 'KODAM_III'},
    ];
  }
}
