/// Model Kop Surat Dinas TNI AD (Kopstuk)
class Kopstuk {
  final String? id;
  final String? satminkalId;
  final String namaSatuan;
  final String namaBalak;
  final String alamat;
  final String nomorTelepon;
  final String? logoUrl;

  const Kopstuk({
    this.id,
    this.satminkalId,
    required this.namaSatuan,
    required this.namaBalak,
    required this.alamat,
    required this.nomorTelepon,
    this.logoUrl,
  });

  factory Kopstuk.fromJson(Map<String, dynamic> json) {
    return Kopstuk(
      id: json['id']?.toString(),
      satminkalId: json['satminkalId']?.toString(),
      namaSatuan: json['namaSatuan']?.toString() ?? 'KOMANDO DAERAH MILITER IV/DIPONEGORO',
      namaBalak: json['namaBalak']?.toString() ?? 'INFORMASI DAN PENGOLAHAN DATA',
      alamat: json['alamat']?.toString() ?? 'Jl. Perintis Kemerdekaan No. 1 Semarang',
      nomorTelepon: json['nomorTelepon']?.toString() ?? '(024) 7474241',
      logoUrl: json['logoUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'satminkalId': satminkalId,
    'namaSatuan': namaSatuan,
    'namaBalak': namaBalak,
    'alamat': alamat,
    'nomorTelepon': nomorTelepon,
    'logoUrl': logoUrl,
  };
}

/// Model Tajuk Tanda Tangan Pejabat (TajukTtd)
class TajukTtd {
  final String id;
  final String jabatan;
  final String namaPejabat;
  final String pangkat;
  final String nrp;
  final bool isAktif;
  final String kategori;

  const TajukTtd({
    required this.id,
    required this.jabatan,
    required this.namaPejabat,
    required this.pangkat,
    required this.nrp,
    this.isAktif = true,
    required this.kategori,
  });

  factory TajukTtd.fromJson(Map<String, dynamic> json) {
    return TajukTtd(
      id: json['id']?.toString() ?? '',
      jabatan: json['jabatan']?.toString() ?? '',
      namaPejabat: json['namaPejabat']?.toString() ?? '',
      pangkat: json['pangkat']?.toString() ?? '',
      nrp: json['nrp']?.toString() ?? '',
      isAktif: json['isAktif'] == true,
      kategori: json['kategori']?.toString() ?? 'KEPRIM',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'jabatan': jabatan,
    'namaPejabat': namaPejabat,
    'pangkat': pangkat,
    'nrp': nrp,
    'isAktif': isAktif,
    'kategori': kategori,
  };
}
