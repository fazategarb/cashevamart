import 'pinjaman.dart';

/// Tahapan Verifikasi Alur Pinjaman Militer
enum TahapVerifikasi {
  verifikasiJurbay('VERIFIKASI_JURBAY', 'Verifikasi Juru Bayar'),
  rekomendasiDan('REKOMENDASI_DAN', 'Rekomendasi Dan/Ka Satuan'),
  accKeprim('ACC_KEPRIM', 'Persetujuan ACC Keprim'),
  uploadBerkas('UPLOAD_BERKAS', 'Upload Berkas & Dokumen'),
  pencairan('PENCAIRAN', 'Pencairan Kas / Transfer');

  const TahapVerifikasi(this.value, this.label);
  final String value;
  final String label;
}

/// Item Antrean Verifikasi Juru Bayar / Komando
class AntreanVerifikasiItem {
  final String id;
  final String nomorPengajuan;
  final String anggotaId;
  final String nama;
  final String nrp;
  final String pangkat;
  final String? korps;
  final String satminkal;
  final double plafon;
  final int tenor;
  final double gajiPokok;
  final double tunkin;
  final double totalPotongan;
  final double sisaGaji;
  final double angsuranBulanan;
  final double rasioAngsuran;
  final bool isLayak;
  final String catatan;
  final StatusPinjaman statusPinjaman;
  final DateTime tanggalPengajuan;

  const AntreanVerifikasiItem({
    required this.id,
    required this.nomorPengajuan,
    required this.anggotaId,
    required this.nama,
    required this.nrp,
    required this.pangkat,
    this.korps,
    required this.satminkal,
    required this.plafon,
    required this.tenor,
    required this.gajiPokok,
    required this.tunkin,
    required this.totalPotongan,
    required this.sisaGaji,
    required this.angsuranBulanan,
    required this.rasioAngsuran,
    required this.isLayak,
    required this.catatan,
    required this.statusPinjaman,
    required this.tanggalPengajuan,
  });

  factory AntreanVerifikasiItem.fromJson(Map<String, dynamic> json) {
    final gaji = (json['gaji'] is num) ? (json['gaji'] as num).toDouble() : (json['gajiPokok'] is num ? (json['gajiPokok'] as num).toDouble() : 5000000.0);
    final tunkin = (json['tunkin'] is num) ? (json['tunkin'] as num).toDouble() : 2000000.0;
    final pot = (json['potongan'] is num) ? (json['potongan'] as num).toDouble() : (json['totalPotongan'] is num ? (json['totalPotongan'] as num).toDouble() : 1500000.0);
    final sisa = (json['sisaGaji'] is num) ? (json['sisaGaji'] as num).toDouble() : (gaji + tunkin - pot);
    final plafon = (json['plafon'] is num) ? (json['plafon'] as num).toDouble() : (json['nominal'] is num ? (json['nominal'] as num).toDouble() : (json['jumlah'] is num ? (json['jumlah'] as num).toDouble() : 10000000.0));
    final tenor = (json['tenor'] is num) ? (json['tenor'] as num).toInt() : (json['tenorBulan'] is num ? (json['tenorBulan'] as num).toInt() : 12);
    final angsuran = (json['angsuranBulanan'] is num) ? (json['angsuranBulanan'] as num).toDouble() : (plafon / tenor + (plafon * 0.12 / 12));
    final rasio = sisa > 0 ? (angsuran / sisa) * 100 : 100.0;

    return AntreanVerifikasiItem(
      id: json['id']?.toString() ?? '',
      nomorPengajuan: json['nomorPengajuan']?.toString() ?? json['id']?.toString() ?? '',
      anggotaId: json['anggotaId']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['anggota']?['nama']?.toString() ?? '',
      nrp: json['nrp']?.toString() ?? json['anggota']?['nrpNip']?.toString() ?? '',
      pangkat: json['pangkat']?.toString() ?? json['anggota']?['pangkat']?['nama']?.toString() ?? '',
      korps: json['korps']?.toString() ?? json['anggota']?['korps']?['kode']?.toString(),
      satminkal: json['satminkal']?.toString() ?? json['anggota']?['satminkal']?['nama']?.toString() ?? 'INFOLAHTADAM IV/DIPONEGORO',
      plafon: plafon,
      tenor: tenor,
      gajiPokok: gaji,
      tunkin: tunkin,
      totalPotongan: pot,
      sisaGaji: sisa,
      angsuranBulanan: angsuran,
      rasioAngsuran: rasio,
      isLayak: json['layak'] == true || rasio <= 40.0,
      catatan: json['catatan']?.toString() ?? (rasio <= 40.0 ? 'Sisa gaji memenuhi ketentuan batas aman (< 40%)' : 'Rasio angsuran terhadap sisa gaji melebihi batas 40%'),
      statusPinjaman: StatusPinjaman.fromString(json['status']?.toString()),
      tanggalPengajuan: json['tanggal'] != null ? (DateTime.tryParse(json['tanggal'].toString()) ?? DateTime.now()) : DateTime.now(),
    );
  }
}

/// DTO Verifikasi / Rekomendasi / ACC / Reject
class VerifikasiActionDto {
  final String pinjamanId;
  final bool isApproved;
  final String? catatan;
  final String? alasanPenolakan;

  const VerifikasiActionDto({
    required this.pinjamanId,
    required this.isApproved,
    this.catatan,
    this.alasanPenolakan,
  });

  Map<String, dynamic> toJson() => {
    'pinjamanId': pinjamanId,
    'status': isApproved ? 'APPROVE' : 'REJECT',
    'catatan': catatan,
    'alasanPenolakan': alasanPenolakan,
  };
}
