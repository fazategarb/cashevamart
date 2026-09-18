/// Model Pos Alokasi SHU Koperasi
class ShuAlokasiPos {
  final String pos;
  final double persen;
  final double nominal;

  const ShuAlokasiPos({
    required this.pos,
    required this.persen,
    this.nominal = 0.0,
  });

  factory ShuAlokasiPos.fromJson(Map<String, dynamic> json) {
    return ShuAlokasiPos(
      pos: json['pos']?.toString() ?? '',
      persen: (json['persen'] is num) ? (json['persen'] as num).toDouble() : 0.0,
      nominal: (json['nominal'] is num) ? (json['nominal'] as num).toDouble() : 0.0,
    );
  }
}

/// Rekap SHU Anggota Perorangan
class ShuAnggotaItem {
  final String nrp;
  final String nama;
  final String? pangkat;
  final double modal;
  final double transaksi;
  final double shuJasaModal;
  final double shuJasaUsaha;
  final double totalShu;

  const ShuAnggotaItem({
    required this.nrp,
    required this.nama,
    this.pangkat,
    required this.modal,
    required this.transaksi,
    this.shuJasaModal = 0.0,
    this.shuJasaUsaha = 0.0,
    this.totalShu = 0.0,
  });

  factory ShuAnggotaItem.fromJson(Map<String, dynamic> json) {
    final m = (json['modal'] is num) ? (json['modal'] as num).toDouble() : 0.0;
    final t = (json['transaksi'] is num) ? (json['transaksi'] as num).toDouble() : 0.0;
    final jm = (json['shuJasaModal'] is num) ? (json['shuJasaModal'] as num).toDouble() : 0.0;
    final ju = (json['shuJasaUsaha'] is num) ? (json['shuJasaUsaha'] as num).toDouble() : 0.0;
    final tot = (json['totalShu'] is num) ? (json['totalShu'] as num).toDouble() : (jm + ju);

    return ShuAnggotaItem(
      nrp: json['nrp']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      pangkat: json['pangkat']?.toString(),
      modal: m,
      transaksi: t,
      shuJasaModal: jm,
      shuJasaUsaha: ju,
      totalShu: tot,
    );
  }
}

/// Ringkasan Pengawasan SHU Tahunan
class ShuSummary {
  final int tahunBuku;
  final double totalPendapatan;
  final double totalBeban;
  final double totalShuKotor;
  final double pajak;
  final double totalShuBersih;
  final double totalSimpananAnggota;
  final double totalTransaksiAnggota;
  final List<ShuAlokasiPos> alokasi;
  final List<ShuAnggotaItem> anggotaShu;

  const ShuSummary({
    required this.tahunBuku,
    required this.totalPendapatan,
    required this.totalBeban,
    required this.totalShuKotor,
    required this.pajak,
    required this.totalShuBersih,
    required this.totalSimpananAnggota,
    required this.totalTransaksiAnggota,
    required this.alokasi,
    required this.anggotaShu,
  });

  factory ShuSummary.calculate({
    required int tahunBuku,
    required double totalPendapatan,
    required double totalBeban,
    double pajakPersen = 0.0,
    required List<ShuAnggotaItem> rawAnggota,
  }) {
    final shuKotor = totalPendapatan - totalBeban;
    final pajak = shuKotor > 0 ? shuKotor * (pajakPersen / 100) : 0.0;
    final shuBersih = shuKotor - pajak;

    // Persentase standar sesuai AD/ART TNI AD
    final distribusiPersen = [
      {'pos': 'Jasa Modal Anggota', 'persen': 20.0},
      {'pos': 'Jasa Usaha / Transaksi Anggota', 'persen': 30.0},
      {'pos': 'Dana Cadangan Koperasi', 'persen': 20.0},
      {'pos': 'Dana Pengurus & Pengawas', 'persen': 10.0},
      {'pos': 'Dana Pendidikan Koperasi', 'persen': 5.0},
      {'pos': 'Dana Sosial & Pembinaan Satuan', 'persen': 10.0},
      {'pos': 'Dana Karyawan / Staf', 'persen': 5.0},
    ];

    final alokasiList = distribusiPersen.map((d) {
      final p = d['persen'] as double;
      return ShuAlokasiPos(
        pos: d['pos'] as String,
        persen: p,
        nominal: shuBersih * (p / 100.0),
      );
    }).toList();

    final danaJasaModal = shuBersih * 0.20;
    final danaJasaUsaha = shuBersih * 0.30;

    double sumModal = 0.0;
    double sumTransaksi = 0.0;
    for (final a in rawAnggota) {
      sumModal += a.modal;
      sumTransaksi += a.transaksi;
    }

    final calculatedAnggota = rawAnggota.map((a) {
      final jm = sumModal > 0 ? (a.modal / sumModal) * danaJasaModal : 0.0;
      final ju = sumTransaksi > 0 ? (a.transaksi / sumTransaksi) * danaJasaUsaha : 0.0;
      return ShuAnggotaItem(
        nrp: a.nrp,
        nama: a.nama,
        pangkat: a.pangkat,
        modal: a.modal,
        transaksi: a.transaksi,
        shuJasaModal: jm,
        shuJasaUsaha: ju,
        totalShu: jm + ju,
      );
    }).toList();

    return ShuSummary(
      tahunBuku: tahunBuku,
      totalPendapatan: totalPendapatan,
      totalBeban: totalBeban,
      totalShuKotor: shuKotor,
      pajak: pajak,
      totalShuBersih: shuBersih,
      totalSimpananAnggota: sumModal,
      totalTransaksiAnggota: sumTransaksi,
      alokasi: alokasiList,
      anggotaShu: calculatedAnggota,
    );
  }
}
