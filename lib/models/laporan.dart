import 'kopstuk.dart';

/// Report Anggota
class ReportAnggotaResponse {
  final Kopstuk? kopstuk;
  final TajukTtd? tajukTtd;
  final List<ReportAnggotaRow> data;

  const ReportAnggotaResponse({
    this.kopstuk,
    this.tajukTtd,
    required this.data,
  });

  factory ReportAnggotaResponse.fromJson(Map<String, dynamic> json) {
    return ReportAnggotaResponse(
      kopstuk: json['kopstuk'] != null ? Kopstuk.fromJson(json['kopstuk']) : null,
      tajukTtd: json['tajukTtd'] != null ? TajukTtd.fromJson(json['tajukTtd']) : null,
      data: json['data'] is List
          ? (json['data'] as List).map((x) => ReportAnggotaRow.fromJson(x)).toList()
          : [],
    );
  }
}

class ReportAnggotaRow {
  final int no;
  final String nama;
  final String pangkatKorpsNrp;
  final String kesatuan;
  final String tmtAnggota;
  final String status;
  final String keterangan;

  const ReportAnggotaRow({
    required this.no,
    required this.nama,
    required this.pangkatKorpsNrp,
    required this.kesatuan,
    required this.tmtAnggota,
    required this.status,
    required this.keterangan,
  });

  factory ReportAnggotaRow.fromJson(Map<String, dynamic> json) {
    return ReportAnggotaRow(
      no: (json['no'] is num) ? (json['no'] as num).toInt() : 1,
      nama: json['nama']?.toString() ?? '',
      pangkatKorpsNrp: json['pangkatKorpsNrp']?.toString() ?? '',
      kesatuan: json['kesatuan']?.toString() ?? '',
      tmtAnggota: json['tmtAnggota']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Aktif',
      keterangan: json['keterangan']?.toString() ?? '-',
    );
  }
}

/// Report Rekap Simpanan
class ReportRekapSimpananResponse {
  final Kopstuk? kopstuk;
  final TajukTtd? tajukTtd;
  final List<ReportRekapSimpananRow> data;
  final double totalWajib;
  final double totalKhusus;
  final double totalSukarela;
  final double grandTotal;

  const ReportRekapSimpananResponse({
    this.kopstuk,
    this.tajukTtd,
    required this.data,
    required this.totalWajib,
    required this.totalKhusus,
    required this.totalSukarela,
    required this.grandTotal,
  });

  factory ReportRekapSimpananResponse.fromJson(Map<String, dynamic> json) {
    return ReportRekapSimpananResponse(
      kopstuk: json['kopstuk'] != null ? Kopstuk.fromJson(json['kopstuk']) : null,
      tajukTtd: json['tajukTtd'] != null ? TajukTtd.fromJson(json['tajukTtd']) : null,
      data: json['data'] is List
          ? (json['data'] as List).map((x) => ReportRekapSimpananRow.fromJson(x)).toList()
          : [],
      totalWajib: (json['totalWajib'] is num) ? (json['totalWajib'] as num).toDouble() : 0.0,
      totalKhusus: (json['totalKhusus'] is num) ? (json['totalKhusus'] as num).toDouble() : 0.0,
      totalSukarela: (json['totalSukarela'] is num) ? (json['totalSukarela'] as num).toDouble() : 0.0,
      grandTotal: (json['grandTotal'] is num) ? (json['grandTotal'] as num).toDouble() : 0.0,
    );
  }
}

class ReportRekapSimpananRow {
  final int no;
  final String nama;
  final String pangkatKorpsNrp;
  final String kesatuan;
  final double simpananWajib;
  final double simpananKhusus;
  final double simpananSukarela;
  final double total;

  const ReportRekapSimpananRow({
    required this.no,
    required this.nama,
    required this.pangkatKorpsNrp,
    required this.kesatuan,
    required this.simpananWajib,
    required this.simpananKhusus,
    required this.simpananSukarela,
    required this.total,
  });

  factory ReportRekapSimpananRow.fromJson(Map<String, dynamic> json) {
    return ReportRekapSimpananRow(
      no: (json['no'] is num) ? (json['no'] as num).toInt() : 1,
      nama: json['nama']?.toString() ?? '',
      pangkatKorpsNrp: json['pangkatKorpsNrp']?.toString() ?? '',
      kesatuan: json['kesatuan']?.toString() ?? '',
      simpananWajib: (json['simpananWajib'] is num) ? (json['simpananWajib'] as num).toDouble() : 0.0,
      simpananKhusus: (json['simpananKhusus'] is num) ? (json['simpananKhusus'] as num).toDouble() : 0.0,
      simpananSukarela: (json['simpananSukarela'] is num) ? (json['simpananSukarela'] as num).toDouble() : 0.0,
      total: (json['total'] is num) ? (json['total'] as num).toDouble() : 0.0,
    );
  }
}

/// Report Pinjaman Anggota
class ReportPinjamanAnggotaResponse {
  final Kopstuk? kopstuk;
  final TajukTtd? tajukTtd;
  final int tahun;
  final List<ReportPinjamanRow> data;
  final double totalPinjaman;

  const ReportPinjamanAnggotaResponse({
    this.kopstuk,
    this.tajukTtd,
    required this.tahun,
    required this.data,
    required this.totalPinjaman,
  });

  factory ReportPinjamanAnggotaResponse.fromJson(Map<String, dynamic> json) {
    return ReportPinjamanAnggotaResponse(
      kopstuk: json['kopstuk'] != null ? Kopstuk.fromJson(json['kopstuk']) : null,
      tajukTtd: json['tajukTtd'] != null ? TajukTtd.fromJson(json['tajukTtd']) : null,
      tahun: (json['tahun'] is num) ? (json['tahun'] as num).toInt() : 2026,
      data: json['data'] is List
          ? (json['data'] as List).map((x) => ReportPinjamanRow.fromJson(x)).toList()
          : [],
      totalPinjaman: (json['totalPinjaman'] is num) ? (json['totalPinjaman'] as num).toDouble() : 0.0,
    );
  }
}

class ReportPinjamanRow {
  final int no;
  final String nama;
  final String pangkatKorpsNrp;
  final String kesatuan;
  final double jumlahPinjaman;
  final int jangkaWaktuBulan;
  final String angsuranMulai;
  final String angsuranSelesai;
  final String tglAkad;
  final String keterangan;

  const ReportPinjamanRow({
    required this.no,
    required this.nama,
    required this.pangkatKorpsNrp,
    required this.kesatuan,
    required this.jumlahPinjaman,
    required this.jangkaWaktuBulan,
    required this.angsuranMulai,
    required this.angsuranSelesai,
    required this.tglAkad,
    required this.keterangan,
  });

  factory ReportPinjamanRow.fromJson(Map<String, dynamic> json) {
    return ReportPinjamanRow(
      no: (json['no'] is num) ? (json['no'] as num).toInt() : 1,
      nama: json['nama']?.toString() ?? '',
      pangkatKorpsNrp: json['pangkatKorpsNrp']?.toString() ?? '',
      kesatuan: json['kesatuan']?.toString() ?? '',
      jumlahPinjaman: (json['jumlahPinjaman'] is num) ? (json['jumlahPinjaman'] as num).toDouble() : 0.0,
      jangkaWaktuBulan: (json['jangkaWaktuBulan'] is num) ? (json['jangkaWaktuBulan'] as num).toInt() : 12,
      angsuranMulai: json['angsuranMulai']?.toString() ?? '',
      angsuranSelesai: json['angsuranSelesai']?.toString() ?? '',
      tglAkad: json['tglAkad']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '-',
    );
  }
}

/// Akad Kredit & Kwitansi Reports
class ReportAkadKreditResponse {
  final Kopstuk? kopstuk;
  final TajukTtd? tajukTtd;
  final Map<String, dynamic> debitur;
  final Map<String, dynamic> pinjaman;
  final List<dynamic> jadwal;
  final double totalPokok;
  final double totalBunga;
  final double totalAngsuran;

  const ReportAkadKreditResponse({
    this.kopstuk,
    this.tajukTtd,
    required this.debitur,
    required this.pinjaman,
    required this.jadwal,
    required this.totalPokok,
    required this.totalBunga,
    required this.totalAngsuran,
  });

  factory ReportAkadKreditResponse.fromJson(Map<String, dynamic> json) {
    return ReportAkadKreditResponse(
      kopstuk: json['kopstuk'] != null ? Kopstuk.fromJson(json['kopstuk']) : null,
      tajukTtd: json['tajukTtd'] != null ? TajukTtd.fromJson(json['tajukTtd']) : null,
      debitur: json['debitur'] as Map<String, dynamic>? ?? {},
      pinjaman: json['pinjaman'] as Map<String, dynamic>? ?? {},
      jadwal: json['jadwal'] as List<dynamic>? ?? [],
      totalPokok: (json['totalPokok'] is num) ? (json['totalPokok'] as num).toDouble() : 0.0,
      totalBunga: (json['totalBunga'] is num) ? (json['totalBunga'] as num).toDouble() : 0.0,
      totalAngsuran: (json['totalAngsuran'] is num) ? (json['totalAngsuran'] as num).toDouble() : 0.0,
    );
  }
}
