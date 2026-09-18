import 'anggota.dart';

/// Jenis Simpanan
enum JenisSimpanan {
  pokok('POKOK', 'Simpanan Pokok'),
  wajib('WAJIB', 'Simpanan Wajib'),
  sukarela('SUKARELA', 'Simpanan Sukarela'),
  berjangka('BERJANGKA', 'Simpanan Berjangka / Deposito');

  const JenisSimpanan(this.value, this.label);
  final String value;
  final String label;

  static JenisSimpanan fromString(String? val) {
    if (val == null) return JenisSimpanan.sukarela;
    final upper = val.toUpperCase();
    for (final e in JenisSimpanan.values) {
      if (e.value == upper || e.name == val) return e;
    }
    return JenisSimpanan.sukarela;
  }
}

/// Tipe Mutasi Simpanan
enum TipeMutasiSimpanan {
  setor('SETOR', 'Setor Simpanan', 1),
  tarik('TARIK', 'Penarikan Simpanan', -1),
  bunga('BUNGA', 'Bagi Hasil / Jasa', 1),
  koreksi('KOREKSI', 'Koreksi Saldo', 0);

  const TipeMutasiSimpanan(this.value, this.label, this.multiplier);
  final String value;
  final String label;
  final int multiplier;

  static TipeMutasiSimpanan fromString(String? val) {
    if (val == null) return TipeMutasiSimpanan.setor;
    final upper = val.toUpperCase();
    for (final e in TipeMutasiSimpanan.values) {
      if (e.value == upper || e.name == val) return e;
    }
    return TipeMutasiSimpanan.setor;
  }
}

/// Item Rekap Simpanan Per Anggota
class RekapSimpananAnggota {
  final String? id;
  final String anggotaId;
  final String nama;
  final String nrpNip;
  final String? pangkat;
  final String? kategoriPangkat;
  final String? korps;
  final String? satminkal;
  final double simpananPokok;
  final double simpananWajib;
  final double simpananSukarela;
  final double simpananKhusus;
  final double totalSimpanan;

  const RekapSimpananAnggota({
    this.id,
    required this.anggotaId,
    required this.nama,
    required this.nrpNip,
    this.pangkat,
    this.kategoriPangkat,
    this.korps,
    this.satminkal,
    this.simpananPokok = 0.0,
    this.simpananWajib = 0.0,
    this.simpananSukarela = 0.0,
    this.simpananKhusus = 0.0,
    required this.totalSimpanan,
  });

  factory RekapSimpananAnggota.fromJson(Map<String, dynamic> json) {
    final sp = (json['simpananPokok'] is num) ? (json['simpananPokok'] as num).toDouble() : (json['totalPokok'] is num ? (json['totalPokok'] as num).toDouble() : 0.0);
    final sw = (json['simpananWajib'] is num) ? (json['simpananWajib'] as num).toDouble() : (json['totalWajib'] is num ? (json['totalWajib'] as num).toDouble() : 0.0);
    final ss = (json['simpananSukarela'] is num) ? (json['simpananSukarela'] as num).toDouble() : (json['totalSukarela'] is num ? (json['totalSukarela'] as num).toDouble() : 0.0);
    final sk = (json['simpananKhusus'] is num) ? (json['simpananKhusus'] as num).toDouble() : (json['totalKhusus'] is num ? (json['totalKhusus'] as num).toDouble() : 0.0);
    final tot = (json['totalSimpanan'] is num) ? (json['totalSimpanan'] as num).toDouble() : (sp + sw + ss + sk);

    return RekapSimpananAnggota(
      id: json['id']?.toString(),
      anggotaId: json['anggotaId']?.toString() ?? json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      nrpNip: json['nrpNip']?.toString() ?? json['nrp']?.toString() ?? '',
      pangkat: json['pangkat']?.toString(),
      kategoriPangkat: json['kategoriPangkat']?.toString(),
      korps: json['korps']?.toString(),
      satminkal: json['satminkal']?.toString() ?? 'INFOLAHTADAM IV/DIPONEGORO',
      simpananPokok: sp,
      simpananWajib: sw,
      simpananSukarela: ss,
      simpananKhusus: sk,
      totalSimpanan: tot,
    );
  }
}

/// Rekening / Saldo Simpanan Anggota
class RekeningSimpanan {
  final String id;
  final String anggotaId;
  final String nomorRekening;
  final JenisSimpanan jenis;
  final double saldo;
  final DateTime? tanggalBuka;
  final bool isAktif;
  final Anggota? anggota;

  const RekeningSimpanan({
    required this.id,
    required this.anggotaId,
    required this.nomorRekening,
    required this.jenis,
    required this.saldo,
    this.tanggalBuka,
    this.isAktif = true,
    this.anggota,
  });

  factory RekeningSimpanan.fromJson(Map<String, dynamic> json) {
    return RekeningSimpanan(
      id: json['id']?.toString() ?? '',
      anggotaId: json['anggotaId']?.toString() ?? '',
      nomorRekening: json['nomorRekening']?.toString() ?? '',
      jenis: JenisSimpanan.fromString(json['jenis']?.toString()),
      saldo: (json['saldo'] is num) ? (json['saldo'] as num).toDouble() : 0.0,
      tanggalBuka: json['tanggalBuka'] != null
          ? DateTime.tryParse(json['tanggalBuka'].toString())
          : null,
      isAktif: json['isAktif'] == true || json['status'] == 'AKTIF',
      anggota: json['anggota'] != null ? Anggota.fromJson(json['anggota']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'anggotaId': anggotaId,
    'nomorRekening': nomorRekening,
    'jenis': jenis.value,
    'saldo': saldo,
    'tanggalBuka': tanggalBuka?.toIso8601String(),
    'isAktif': isAktif,
  };
}

/// Riwayat Transaksi / Mutasi Simpanan
class MutasiSimpanan {
  final String id;
  final String rekeningId;
  final String? nomorTransaksi;
  final TipeMutasiSimpanan tipe;
  final double jumlah;
  final double saldoSebelum;
  final double saldoSetelah;
  final String? keterangan;
  final DateTime tanggal;
  final String? diprosesOleh;
  final RekeningSimpanan? rekening;

  const MutasiSimpanan({
    required this.id,
    required this.rekeningId,
    this.nomorTransaksi,
    required this.tipe,
    required this.jumlah,
    required this.saldoSebelum,
    required this.saldoSetelah,
    this.keterangan,
    required this.tanggal,
    this.diprosesOleh,
    this.rekening,
  });

  factory MutasiSimpanan.fromJson(Map<String, dynamic> json) {
    return MutasiSimpanan(
      id: json['id']?.toString() ?? '',
      rekeningId: json['rekeningId']?.toString() ?? '',
      nomorTransaksi: json['nomorTransaksi']?.toString(),
      tipe: TipeMutasiSimpanan.fromString(json['tipe']?.toString() ?? json['jenisTransaksi']?.toString()),
      jumlah: (json['jumlah'] is num) ? (json['jumlah'] as num).toDouble() : (json['nominal'] is num ? (json['nominal'] as num).toDouble() : 0.0),
      saldoSebelum: (json['saldoSebelum'] is num) ? (json['saldoSebelum'] as num).toDouble() : 0.0,
      saldoSetelah: (json['saldoSetelah'] is num) ? (json['saldoSetelah'] as num).toDouble() : 0.0,
      keterangan: json['keterangan']?.toString(),
      tanggal: json['tanggal'] != null ? (DateTime.tryParse(json['tanggal'].toString()) ?? DateTime.now()) : DateTime.now(),
      diprosesOleh: json['diprosesOleh']?.toString() ?? json['operator']?.toString(),
      rekening: json['rekening'] != null ? RekeningSimpanan.fromJson(json['rekening']) : null,
    );
  }
}

/// Ringkasan Saldo Simpanan Keseluruhan atau Per Anggota
class RingkasanSimpanan {
  final double totalSimpanan;
  final double simpananPokok;
  final double simpananWajib;
  final double simpananSukarela;
  final double simpananBerjangka;
  final int totalRekening;
  final int totalAnggotaAktif;

  const RingkasanSimpanan({
    this.totalSimpanan = 0,
    this.simpananPokok = 0,
    this.simpananWajib = 0,
    this.simpananSukarela = 0,
    this.simpananBerjangka = 0,
    this.totalRekening = 0,
    this.totalAnggotaAktif = 0,
  });

  factory RingkasanSimpanan.fromJson(Map<String, dynamic> json) {
    return RingkasanSimpanan(
      totalSimpanan: (json['totalSimpanan'] is num) ? (json['totalSimpanan'] as num).toDouble() : 0.0,
      simpananPokok: (json['simpananPokok'] is num) ? (json['simpananPokok'] as num).toDouble() : 0.0,
      simpananWajib: (json['simpananWajib'] is num) ? (json['simpananWajib'] as num).toDouble() : 0.0,
      simpananSukarela: (json['simpananSukarela'] is num) ? (json['simpananSukarela'] as num).toDouble() : 0.0,
      simpananBerjangka: (json['simpananBerjangka'] is num) ? (json['simpananBerjangka'] as num).toDouble() : 0.0,
      totalRekening: (json['totalRekening'] is num) ? (json['totalRekening'] as num).toInt() : 0,
      totalAnggotaAktif: (json['totalAnggotaAktif'] is num) ? (json['totalAnggotaAktif'] as num).toInt() : 0,
    );
  }
}
