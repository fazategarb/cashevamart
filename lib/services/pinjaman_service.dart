import 'package:flutter/foundation.dart';
import '../models/pinjaman.dart';
import '../models/anggota.dart';
import 'api_service.dart';

/// Service untuk modul Pinjaman & Angsuran
class PinjamanService {
  PinjamanService._();
  static final PinjamanService instance = PinjamanService._();

  /// Mock Data Pinjaman Terbaru untuk fallback / demo
  static final List<Pinjaman> mockLoans = [
    Pinjaman(
      id: 'PJM-2026-0184',
      anggotaId: 'ANG-004',
      nomorPinjaman: 'PJM-2026-0184',
      nominal: 15000000,
      tenorBulan: 24,
      status: StatusPinjaman.setujuKeprim,
      tanggalPengajuan: DateTime.now().subtract(const Duration(days: 2)),
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
        status: 'Aktif',
      ),
    ),
    Pinjaman(
      id: 'PJM-2026-0183',
      anggotaId: 'ANG-005',
      nomorPinjaman: 'PJM-2026-0183',
      nominal: 20000000,
      tenorBulan: 36,
      status: StatusPinjaman.rekomendasiPimpinan,
      tanggalPengajuan: DateTime.now().subtract(const Duration(days: 3)),
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
        status: 'Aktif',
      ),
    ),
    Pinjaman(
      id: 'PJM-2026-0182',
      anggotaId: 'ANG-007',
      nomorPinjaman: 'PJM-2026-0182',
      nominal: 8000000,
      tenorBulan: 18,
      status: StatusPinjaman.verifikasiJuruBayar,
      tanggalPengajuan: DateTime.now().subtract(const Duration(days: 4)),
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
        status: 'Aktif',
      ),
    ),
    Pinjaman(
      id: 'PJM-2026-0181',
      anggotaId: 'ANG-006',
      nomorPinjaman: 'PJM-2026-0181',
      nominal: 5000000,
      tenorBulan: 12,
      status: StatusPinjaman.diajukan,
      tanggalPengajuan: DateTime.now().subtract(const Duration(days: 5)),
      anggota: const Anggota(
        id: 'ANG-006',
        nrp: '198504112009',
        nama: 'Sri Wahyuni',
        pangkat: 'Penata Muda',
        golongan: 'PNS',
        korps: 'PNS',
        satminkal: 'INFOLAHTADAM IV/DIPONEGORO',
        simpananWajib: 1800000,
        simpananSukarela: 2900000,
        status: 'Aktif',
      ),
    ),
    Pinjaman(
      id: 'PJM-2026-0180',
      anggotaId: 'ANG-003',
      nomorPinjaman: 'PJM-2026-0180',
      nominal: 18000000,
      tenorBulan: 30,
      status: StatusPinjaman.dicairkan,
      tanggalPengajuan: DateTime.now().subtract(const Duration(days: 15)),
      tanggalPencairan: DateTime.now().subtract(const Duration(days: 10)),
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
        status: 'Aktif',
      ),
    ),
  ];

  /// Ambil semua pinjaman dengan filter status
  Future<List<Pinjaman>> getAllPinjaman({StatusPinjaman? status}) async {
    try {
      final query = status != null ? {'status': status.value} : null;
      final res = await ApiService.instance.get('/pinjaman', queryParams: query);
      if (res is List) {
        return res.map((x) => Pinjaman.fromJson(x as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Get pinjaman error: $e, using mock');
    }

    // Fallback filter mock
    if (status != null) {
      return mockLoans.where((l) => l.status == status).toList();
    }
    return mockLoans;
  }

  /// Ambil detail 1 pinjaman
  Future<Pinjaman> getPinjamanDetail(String id) async {
    try {
      final res = await ApiService.instance.get('/pinjaman/$id');
      if (res is Map<String, dynamic>) {
        return Pinjaman.fromJson(res);
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Detail error: $e');
    }
    return mockLoans.firstWhere(
      (l) => l.id == id || l.nomorPinjaman == id,
      orElse: () => mockLoans.first,
    );
  }

  /// Ajukan Pinjaman Baru (USIPA)
  Future<Pinjaman> createPinjaman({
    required String anggotaId,
    required double nominal,
    required int tenorBulan,
    String? catatan,
  }) async {
    try {
      final res = await ApiService.instance.post('/pinjaman', body: {
        'anggotaId': anggotaId,
        'nominal': nominal,
        'tenorBulan': tenorBulan,
        'catatan': catatan,
      });
      if (res is Map<String, dynamic>) {
        return Pinjaman.fromJson(res);
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Create error: $e');
    }

    final newLoan = Pinjaman(
      id: 'PJM-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      anggotaId: anggotaId,
      nomorPinjaman: 'PJM-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      nominal: nominal,
      tenorBulan: tenorBulan,
      status: StatusPinjaman.diajukan,
      tanggalPengajuan: DateTime.now(),
      catatan: catatan,
    );
    mockLoans.insert(0, newLoan);
    return newLoan;
  }

  /// Update Status Pinjaman (Verifikasi Jurbay, Rekomendasi Dan, ACC Keprim, Tolak)
  Future<Pinjaman> updateStatus({
    required String id,
    required StatusPinjaman status,
    String? catatan,
    String? alasanPenolakan,
  }) async {
    try {
      final res = await ApiService.instance.patch('/pinjaman/$id/status', body: {
        'status': status.value,
        'catatan': catatan,
        'alasanPenolakan': alasanPenolakan,
      });
      if (res is Map<String, dynamic>) {
        return Pinjaman.fromJson(res);
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Update status error: $e');
    }

    // Mock update
    final index = mockLoans.indexWhere((l) => l.id == id);
    if (index >= 0) {
      final current = mockLoans[index];
      final updated = Pinjaman(
        id: current.id,
        anggotaId: current.anggotaId,
        nomorPinjaman: current.nomorPinjaman,
        nominal: current.nominal,
        tenorBulan: current.tenorBulan,
        status: status,
        tanggalPengajuan: current.tanggalPengajuan,
        alasanPenolakan: alasanPenolakan,
        catatan: catatan ?? current.catatan,
        anggota: current.anggota,
      );
      mockLoans[index] = updated;
      return updated;
    }
    throw const ApiException('Pinjaman tidak ditemukan');
  }

  /// Pencairan Pinjaman
  Future<Pinjaman> cairkanPinjaman(String id, {String? catatan}) async {
    try {
      final res = await ApiService.instance.post('/pinjaman/$id/cairkan', body: {
        'tanggalPencairan': DateTime.now().toIso8601String(),
        'catatan': catatan,
      });
      if (res is Map<String, dynamic>) {
        return Pinjaman.fromJson(res);
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Cairkan error: $e');
    }

    return updateStatus(id: id, status: StatusPinjaman.dicairkan, catatan: catatan);
  }

  /// Kalkulasi Dinamis Angsuran & Pelunasan
  Future<KalkulasiDinamis> getKalkulasiDinamis(String pinjamanId) async {
    try {
      final res = await ApiService.instance.get('/pinjaman/$pinjamanId/kalkulasi-dinamis');
      if (res is Map<String, dynamic>) {
        return KalkulasiDinamis.fromJson(res);
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Kalkulasi dinamis error: $e');
    }

    // Fallback mock
    return KalkulasiDinamis(
      pinjamanId: pinjamanId,
      nominalAwal: 15000000,
      sisaPokok: 10000000,
      tenorBulan: 24,
      bungaPersenTahun: 12.0,
      bungaBulanan: 100000,
      pokokBulanan: 625000,
      tunggakanBunga: 0,
      nextBulanKe: 9,
      totalKewajibanBulanIni: 725000,
      pelunasanSisaPokok: 10000000,
      pelunasanPinaltiBunga2x: 200000,
      pelunasanTotalBayar: 10200000,
      statusPeringatan: 'NORMAL',
      keteranganJatuhTempo: 'Jatuh tempo setiap tanggal 10 bulan berjalan',
    );
  }

  /// Bayar Angsuran Dinamis
  Future<Map<String, dynamic>> bayarDinamis({
    required String pinjamanId,
    required double nominalBayar,
    int? bulanKe,
    bool isPelunasanDipercepat = false,
  }) async {
    try {
      final res = await ApiService.instance.post('/pinjaman/$pinjamanId/bayar-dinamis', body: {
        'nominalBayar': nominalBayar,
        'bulanKe': bulanKe,
        'isPelunasanDipercepat': isPelunasanDipercepat,
        'tanggalBayar': DateTime.now().toIso8601String(),
      });
      if (res is Map<String, dynamic>) {
        return res;
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Bayar dinamis error: $e');
    }

    return {
      'message': 'Pembayaran angsuran berhasil diproses',
      'noInvoice': 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'tanggalBayar': DateTime.now().toIso8601String(),
      'nominalBayar': nominalBayar,
      'isLunas': isPelunasanDipercepat,
      'pinjamanId': pinjamanId,
    };
  }

  /// Cek Plafond Anggota
  Future<PlafondInfo> getPlafond(String anggotaId) async {
    try {
      final res = await ApiService.instance.get('/pinjaman/plafond/$anggotaId');
      if (res is Map<String, dynamic>) {
        return PlafondInfo.fromJson(res);
      }
    } catch (e) {
      debugPrint('[PINJAMAN] Plafond error: $e');
    }

    return PlafondInfo(
      anggotaId: anggotaId,
      kategoriPangkat: 'BINTARA',
      maksPlafond: 30000000,
      totalPinjamanAktif: 8000000,
      sisaKuota: 22000000,
      label: 'Bintara / Tamtama (Maks Rp 30.000.000)',
    );
  }
}
