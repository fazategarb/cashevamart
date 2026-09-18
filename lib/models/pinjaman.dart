import 'anggota.dart';

/// Status Pinjaman di Backend
enum StatusPinjaman {
  diajukan('DIAJUKAN', 'Diajukan / Pending'),
  verifikasiPrimkop('VERIFIKASI_PRIMKOP', 'Verifikasi Primkop'),
  verifikasiJuruBayar('VERIFIKASI_JURU_BAYAR', 'Verifikasi Juru Bayar'),
  rekomendasiPimpinan('REKOMENDASI_PIMPINAN', 'Rekomendasi Dan/Ka'),
  setujuKeprim('SETUJU_KEPRIM', 'ACC Keprim'),
  setujuKaprim('SETUJU_KAPRIM', 'ACC Kaprim'),
  menungguDokumen('MENUNGGU_DOKUMEN', 'Upload Berkas'),
  dicairkan('DICAIRKAN', 'Dicairkan'),
  lunas('LUNAS', 'Lunas'),
  ditolak('DITOLAK', 'Ditolak');

  const StatusPinjaman(this.value, this.label);
  final String value;
  final String label;

  static StatusPinjaman fromString(String? val) {
    if (val == null) return StatusPinjaman.diajukan;
    final upper = val.toUpperCase().trim();
    for (final e in StatusPinjaman.values) {
      if (e.value == upper || e.name == val) return e;
    }
    return StatusPinjaman.diajukan;
  }
}

/// Model Pinjaman Lengkap
class Pinjaman {
  final String id;
  final String anggotaId;
  final String? nomorPinjaman;
  final double nominal;
  final int tenorBulan;
  final double sukuBungaTahunan;
  final double angsuranPokok;
  final double angsuranBunga;
  final double totalAngsuranBulanan;
  final double sisaPokok;
  final StatusPinjaman status;
  final DateTime? tanggalPengajuan;
  final DateTime? tanggalPencairan;
  final DateTime? tanggalJatuhTempo;
  final DateTime? tanggalPelunasan;
  final String? alasanPenolakan;
  final String? catatan;
  final Anggota? anggota;
  final List<AngsuranItem>? angsuran;

  const Pinjaman({
    required this.id,
    required this.anggotaId,
    this.nomorPinjaman,
    required this.nominal,
    required this.tenorBulan,
    this.sukuBungaTahunan = 12.0,
    this.angsuranPokok = 0.0,
    this.angsuranBunga = 0.0,
    this.totalAngsuranBulanan = 0.0,
    this.sisaPokok = 0.0,
    required this.status,
    this.tanggalPengajuan,
    this.tanggalPencairan,
    this.tanggalJatuhTempo,
    this.tanggalPelunasan,
    this.alasanPenolakan,
    this.catatan,
    this.anggota,
    this.angsuran,
  });

  factory Pinjaman.fromJson(Map<String, dynamic> json) {
    return Pinjaman(
      id: json['id']?.toString() ?? '',
      anggotaId: json['anggotaId']?.toString() ?? '',
      nomorPinjaman: json['nomorPinjaman']?.toString() ?? json['kodePinjaman']?.toString(),
      nominal: (json['nominal'] is num) ? (json['nominal'] as num).toDouble() : (json['jumlah'] is num ? (json['jumlah'] as num).toDouble() : 0.0),
      tenorBulan: (json['tenorBulan'] is num) ? (json['tenorBulan'] as num).toInt() : (json['tenor'] is num ? (json['tenor'] as num).toInt() : 12),
      sukuBungaTahunan: (json['sukuBungaTahunan'] is num) ? (json['sukuBungaTahunan'] as num).toDouble() : 12.0,
      angsuranPokok: (json['angsuranPokok'] is num) ? (json['angsuranPokok'] as num).toDouble() : 0.0,
      angsuranBunga: (json['angsuranBunga'] is num) ? (json['angsuranBunga'] as num).toDouble() : 0.0,
      totalAngsuranBulanan: (json['totalAngsuranBulanan'] is num) ? (json['totalAngsuranBulanan'] as num).toDouble() : (json['angsuranBulanan'] is num ? (json['angsuranBulanan'] as num).toDouble() : 0.0),
      sisaPokok: (json['sisaPokok'] is num) ? (json['sisaPokok'] as num).toDouble() : 0.0,
      status: StatusPinjaman.fromString(json['status']?.toString()),
      tanggalPengajuan: json['tanggalPengajuan'] != null ? DateTime.tryParse(json['tanggalPengajuan'].toString()) : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
      tanggalPencairan: json['tanggalPencairan'] != null ? DateTime.tryParse(json['tanggalPencairan'].toString()) : null,
      tanggalJatuhTempo: json['tanggalJatuhTempo'] != null ? DateTime.tryParse(json['tanggalJatuhTempo'].toString()) : null,
      tanggalPelunasan: json['tanggalPelunasan'] != null ? DateTime.tryParse(json['tanggalPelunasan'].toString()) : null,
      alasanPenolakan: json['alasanPenolakan']?.toString(),
      catatan: json['catatan']?.toString(),
      anggota: json['anggota'] != null ? Anggota.fromJson(json['anggota']) : null,
      angsuran: json['angsuran'] is List
          ? (json['angsuran'] as List).map((x) => AngsuranItem.fromJson(x)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'anggotaId': anggotaId,
    'nomorPinjaman': nomorPinjaman,
    'nominal': nominal,
    'tenorBulan': tenorBulan,
    'sukuBungaTahunan': sukuBungaTahunan,
    'status': status.value,
    'catatan': catatan,
  };
}

/// Status Pembayaran Angsuran
enum StatusAngsuran {
  belumBayar('BELUM_BAYAR', 'Belum Bayar'),
  lunas('LUNAS', 'Lunas'),
  lewatJatuhTempo('LEWAT_JATUH_TEMPO', 'Terlambat'),
  sebagian('SEBAGIAN', 'Sebagian');

  const StatusAngsuran(this.value, this.label);
  final String value;
  final String label;

  static StatusAngsuran fromString(String? val) {
    if (val == null) return StatusAngsuran.belumBayar;
    final upper = val.toUpperCase().trim();
    for (final e in StatusAngsuran.values) {
      if (e.value == upper || e.name == val) return e;
    }
    return StatusAngsuran.belumBayar;
  }
}

/// Item Jadwal Angsuran
class AngsuranItem {
  final String id;
  final String pinjamanId;
  final int bulanKe;
  final double pokok;
  final double bunga;
  final double totalBayar;
  final double sisaPokokSetelahBayar;
  final DateTime? tanggalJatuhTempo;
  final DateTime? tanggalBayar;
  final StatusAngsuran status;
  final String? noKwitansi;

  const AngsuranItem({
    required this.id,
    required this.pinjamanId,
    required this.bulanKe,
    required this.pokok,
    required this.bunga,
    required this.totalBayar,
    this.sisaPokokSetelahBayar = 0.0,
    this.tanggalJatuhTempo,
    this.tanggalBayar,
    this.status = StatusAngsuran.belumBayar,
    this.noKwitansi,
  });

  factory AngsuranItem.fromJson(Map<String, dynamic> json) {
    return AngsuranItem(
      id: json['id']?.toString() ?? '',
      pinjamanId: json['pinjamanId']?.toString() ?? '',
      bulanKe: (json['bulanKe'] is num) ? (json['bulanKe'] as num).toInt() : (json['angsuranKe'] is num ? (json['angsuranKe'] as num).toInt() : 1),
      pokok: (json['pokok'] is num) ? (json['pokok'] as num).toDouble() : 0.0,
      bunga: (json['bunga'] is num) ? (json['bunga'] as num).toDouble() : 0.0,
      totalBayar: (json['totalBayar'] is num) ? (json['totalBayar'] as num).toDouble() : (json['total'] is num ? (json['total'] as num).toDouble() : 0.0),
      sisaPokokSetelahBayar: (json['sisaPokokSetelahBayar'] is num) ? (json['sisaPokokSetelahBayar'] as num).toDouble() : 0.0,
      tanggalJatuhTempo: json['tanggalJatuhTempo'] != null ? DateTime.tryParse(json['tanggalJatuhTempo'].toString()) : null,
      tanggalBayar: json['tanggalBayar'] != null ? DateTime.tryParse(json['tanggalBayar'].toString()) : null,
      status: StatusAngsuran.fromString(json['status']?.toString()),
      noKwitansi: json['noKwitansi']?.toString(),
    );
  }
}

/// Kalkulasi Dinamis Angsuran Pinjaman
class KalkulasiDinamis {
  final String pinjamanId;
  final double nominalAwal;
  final double sisaPokok;
  final int tenorBulan;
  final double bungaPersenTahun;
  final double bungaBulanan;
  final double pokokBulanan;
  final double tunggakanBunga;
  final int nextBulanKe;
  final double totalKewajibanBulanIni;
  final double pelunasanSisaPokok;
  final double pelunasanPinaltiBunga2x;
  final double pelunasanTotalBayar;
  final String statusPeringatan;
  final String keteranganJatuhTempo;
  final bool isBlacklist;

  const KalkulasiDinamis({
    required this.pinjamanId,
    required this.nominalAwal,
    required this.sisaPokok,
    required this.tenorBulan,
    required this.bungaPersenTahun,
    required this.bungaBulanan,
    required this.pokokBulanan,
    required this.tunggakanBunga,
    required this.nextBulanKe,
    required this.totalKewajibanBulanIni,
    required this.pelunasanSisaPokok,
    required this.pelunasanPinaltiBunga2x,
    required this.pelunasanTotalBayar,
    required this.statusPeringatan,
    required this.keteranganJatuhTempo,
    this.isBlacklist = false,
  });

  factory KalkulasiDinamis.fromJson(Map<String, dynamic> json) {
    final pel = json['pelunasanDipercepat'] as Map<String, dynamic>? ?? {};
    final jt = json['jatuhTempoInfo'] as Map<String, dynamic>? ?? {};

    return KalkulasiDinamis(
      pinjamanId: json['pinjamanId']?.toString() ?? '',
      nominalAwal: (json['nominalAwal'] is num) ? (json['nominalAwal'] as num).toDouble() : 0.0,
      sisaPokok: (json['sisaPokok'] is num) ? (json['sisaPokok'] as num).toDouble() : 0.0,
      tenorBulan: (json['tenorBulan'] is num) ? (json['tenorBulan'] as num).toInt() : 12,
      bungaPersenTahun: (json['bungaPersenTahun'] is num) ? (json['bungaPersenTahun'] as num).toDouble() : 12.0,
      bungaBulanan: (json['bungaBulanan'] is num) ? (json['bungaBulanan'] as num).toDouble() : 0.0,
      pokokBulanan: (json['pokokBulanan'] is num) ? (json['pokokBulanan'] as num).toDouble() : 0.0,
      tunggakanBunga: (json['tunggakanBunga'] is num) ? (json['tunggakanBunga'] as num).toDouble() : 0.0,
      nextBulanKe: (json['nextBulanKe'] is num) ? (json['nextBulanKe'] as num).toInt() : 1,
      totalKewajibanBulanIni: (json['totalKewajibanBulanIni'] is num) ? (json['totalKewajibanBulanIni'] as num).toDouble() : 0.0,
      pelunasanSisaPokok: (pel['sisaPokok'] is num) ? (pel['sisaPokok'] as num).toDouble() : 0.0,
      pelunasanPinaltiBunga2x: (pel['pinaltiBunga2x'] is num) ? (pel['pinaltiBunga2x'] as num).toDouble() : 0.0,
      pelunasanTotalBayar: (pel['totalBayar'] is num) ? (pel['totalBayar'] as num).toDouble() : 0.0,
      statusPeringatan: jt['statusPeringatan']?.toString() ?? 'NORMAL',
      keteranganJatuhTempo: jt['keterangan']?.toString() ?? '',
      isBlacklist: jt['isBlacklist'] == true,
    );
  }
}

/// Plafond Info Per Golongan
class PlafondInfo {
  final String anggotaId;
  final String kategoriPangkat;
  final double maksPlafond;
  final double totalPinjamanAktif;
  final double sisaKuota;
  final bool isBlacklist;
  final String? sanksiKeterangan;
  final String label;

  const PlafondInfo({
    required this.anggotaId,
    required this.kategoriPangkat,
    required this.maksPlafond,
    required this.totalPinjamanAktif,
    required this.sisaKuota,
    this.isBlacklist = false,
    this.sanksiKeterangan,
    required this.label,
  });

  factory PlafondInfo.fromJson(Map<String, dynamic> json) {
    return PlafondInfo(
      anggotaId: json['anggotaId']?.toString() ?? '',
      kategoriPangkat: json['kategoriPangkat']?.toString() ?? '',
      maksPlafond: (json['maksPlafond'] is num) ? (json['maksPlafond'] as num).toDouble() : 0.0,
      totalPinjamanAktif: (json['totalPinjamanAktif'] is num) ? (json['totalPinjamanAktif'] as num).toDouble() : 0.0,
      sisaKuota: (json['sisaKuota'] is num) ? (json['sisaKuota'] as num).toDouble() : 0.0,
      isBlacklist: json['isBlacklist'] == true,
      sanksiKeterangan: json['sanksiKeterangan']?.toString(),
      label: json['label']?.toString() ?? '',
    );
  }
}

/// Simulasi Pinjaman Helper
class SimulasiPinjaman {
  final double nominal;
  final int tenorBulan;
  final double sukuBungaTahunan;
  final double pokokBulanan;
  final double bungaBulanan;
  final double totalBulanan;
  final double totalBayar;
  final double totalBunga;

  SimulasiPinjaman({
    required this.nominal,
    required this.tenorBulan,
    this.sukuBungaTahunan = 12.0,
  })  : pokokBulanan = nominal / tenorBulan,
        bungaBulanan = (nominal * (sukuBungaTahunan / 100)) / 12,
        totalBulanan = (nominal / tenorBulan) + ((nominal * (sukuBungaTahunan / 100)) / 12),
        totalBayar = nominal + ((nominal * (sukuBungaTahunan / 100) / 12) * tenorBulan),
        totalBunga = (nominal * (sukuBungaTahunan / 100) / 12) * tenorBulan;
}
