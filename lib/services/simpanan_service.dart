import 'package:flutter/foundation.dart';
import '../models/simpanan.dart';
import 'api_service.dart';

/// Service untuk modul Simpanan
class SimpananService {
  SimpananService._();
  static final SimpananService instance = SimpananService._();

  static final List<RekapSimpananAnggota> mockRekap = [
    const RekapSimpananAnggota(
      anggotaId: 'ANG-003',
      nama: 'Dedi Kurnia',
      nrpNip: '11020033',
      pangkat: 'Letkol Cba',
      kategoriPangkat: 'PAMEN',
      korps: 'Cba',
      simpananPokok: 500000,
      simpananWajib: 4800000,
      simpananSukarela: 12500000,
      totalSimpanan: 17800000,
    ),
    const RekapSimpananAnggota(
      anggotaId: 'ANG-005',
      nama: 'Rahmat Hidayat',
      nrpNip: '11060078',
      pangkat: 'Kapten Inf',
      kategoriPangkat: 'PAMA',
      korps: 'Inf',
      simpananPokok: 500000,
      simpananWajib: 3600000,
      simpananSukarela: 7250000,
      totalSimpanan: 11350000,
    ),
    const RekapSimpananAnggota(
      anggotaId: 'ANG-004',
      nama: 'Budi Santoso',
      nrpNip: '21980045',
      pangkat: 'Serma',
      kategoriPangkat: 'BINTARA',
      korps: 'Chb',
      simpananPokok: 500000,
      simpananWajib: 2400000,
      simpananSukarela: 4100000,
      totalSimpanan: 7000000,
    ),
    const RekapSimpananAnggota(
      anggotaId: 'ANG-007',
      nama: 'Agus Wibowo',
      nrpNip: '21930112',
      pangkat: 'Pelda',
      kategoriPangkat: 'BINTARA',
      korps: 'Czi',
      simpananPokok: 500000,
      simpananWajib: 2700000,
      simpananSukarela: 5300000,
      totalSimpanan: 8500000,
    ),
    const RekapSimpananAnggota(
      anggotaId: 'ANG-006',
      nama: 'Sri Wahyuni',
      nrpNip: '198504112009',
      pangkat: 'Penata Muda',
      kategoriPangkat: 'PNS',
      korps: 'PNS',
      simpananPokok: 500000,
      simpananWajib: 1800000,
      simpananSukarela: 2900000,
      totalSimpanan: 5200000,
    ),
  ];

  /// Ambil rekap simpanan seluruh anggota
  Future<List<RekapSimpananAnggota>> getRekap() async {
    try {
      final res = await ApiService.instance.get('/simpanan/rekap');
      if (res is List) {
        return res.map((x) => RekapSimpananAnggota.fromJson(x as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('[SIMPANAN] Get rekap error: $e');
    }
    return mockRekap;
  }

  /// Ambil mutasi transaksi simpanan anggota tertentu
  Future<List<MutasiSimpanan>> getByAnggota(String anggotaId) async {
    try {
      final res = await ApiService.instance.get('/simpanan/anggota/$anggotaId');
      if (res is List) {
        return res.map((x) => MutasiSimpanan.fromJson(x as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('[SIMPANAN] Get by anggota error: $e');
    }

    // Mock mutasi
    return [
      MutasiSimpanan(
        id: 'MUT-01',
        rekeningId: 'REK-01',
        nomorTransaksi: 'TRX-SIMP-001',
        tipe: TipeMutasiSimpanan.setor,
        jumlah: 150000,
        saldoSebelum: 1350000,
        saldoSetelah: 1500000,
        keterangan: 'Potongan Gaji Otomatis - Simpanan Wajib',
        tanggal: DateTime.now().subtract(const Duration(days: 5)),
      ),
      MutasiSimpanan(
        id: 'MUT-02',
        rekeningId: 'REK-02',
        nomorTransaksi: 'TRX-SIMP-002',
        tipe: TipeMutasiSimpanan.setor,
        jumlah: 250000,
        saldoSebelum: 1500000,
        saldoSetelah: 1750000,
        keterangan: 'Setoran Sukarela via Bank BNI Virtual Account',
        tanggal: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
  }

  /// Setor Simpanan
  Future<dynamic> setorSimpanan({
    required String anggotaId,
    required String jenis, // "POKOK" | "WAJIB" | "SUKARELA" | "KHUSUS"
    required double nominal,
    String? keterangan,
  }) async {
    return ApiService.instance.post('/simpanan/setor', body: {
      'anggotaId': anggotaId,
      'jenis': jenis,
      'nominal': nominal,
      'keterangan': keterangan,
    });
  }

  /// Potongan Sukarela Massal
  Future<dynamic> potonganSukarelaMassal({
    double? nominalPamen,
    double? nominalPama,
    double? nominalBataAsn,
  }) async {
    return ApiService.instance.post('/simpanan/sukarela/massal', body: {
      'nominalPamen': nominalPamen ?? 300000,
      'nominalPama': nominalPama ?? 250000,
      'nominalBataAsn': nominalBataAsn ?? 150000,
      'bulan': DateTime.now().month,
      'tahun': DateTime.now().year,
    });
  }
}
