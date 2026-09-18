/// Kategori Pangkat TNI AD
enum KategoriPangkat {
  pati('PATI'),
  pamen('PAMEN'),
  pama('PAMA'),
  bintara('BINTARA'),
  bataAsn('BATA_ASN'),
  pns('PNS');

  const KategoriPangkat(this.value);
  final String value;

  static KategoriPangkat fromString(String s) {
    return KategoriPangkat.values.firstWhere(
      (e) => e.value == s || e.name.toUpperCase() == s.toUpperCase(),
      orElse: () => KategoriPangkat.bintara,
    );
  }
}

class Kotama {
  final String id;
  final String kode;
  final String nama;

  const Kotama({
    required this.id,
    required this.kode,
    required this.nama,
  });

  factory Kotama.fromJson(Map<String, dynamic> json) => Kotama(
        id: json['id'] as String? ?? '',
        kode: json['kode'] as String? ?? '',
        nama: json['nama'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kode': kode,
        'nama': nama,
      };

  @override
  String toString() => nama;
}

class Satminkal {
  final String id;
  final String kode;
  final String nama;
  final String? kotamaId;
  final Kotama? kotama;

  const Satminkal({
    required this.id,
    required this.kode,
    required this.nama,
    this.kotamaId,
    this.kotama,
  });

  factory Satminkal.fromJson(Map<String, dynamic> json) => Satminkal(
        id: json['id'] as String? ?? '',
        kode: json['kode'] as String? ?? '',
        nama: json['nama'] as String? ?? '',
        kotamaId: json['kotamaId'] as String?,
        kotama: json['kotama'] != null
            ? Kotama.fromJson(json['kotama'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kode': kode,
        'nama': nama,
        'kotamaId': kotamaId,
        'kotama': kotama?.toJson(),
      };

  @override
  String toString() => nama;
}

class Pangkat {
  final String id;
  final int kodePkt;
  final String? kode;
  final String nama;
  final String kategori;

  const Pangkat({
    required this.id,
    required this.kodePkt,
    this.kode,
    required this.nama,
    required this.kategori,
  });

  factory Pangkat.fromJson(Map<String, dynamic> json) => Pangkat(
        id: json['id'] as String? ?? '',
        kodePkt: (json['kodePkt'] as num?)?.toInt() ?? 0,
        kode: json['kode']?.toString(),
        nama: json['nama'] as String? ?? '',
        kategori: json['kategori'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kodePkt': kodePkt,
        'kode': kode,
        'nama': nama,
        'kategori': kategori,
      };

  @override
  String toString() => nama;
}

class Korps {
  final String id;
  final String kode;
  final String nama;

  const Korps({
    required this.id,
    required this.kode,
    required this.nama,
  });

  factory Korps.fromJson(Map<String, dynamic> json) => Korps(
        id: json['id'] as String? ?? '',
        kode: json['kode'] as String? ?? '',
        nama: json['nama'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'kode': kode,
        'nama': nama,
      };

  @override
  String toString() => nama;
}

class Anggota {
  final String id;
  final String nrp;
  final String nama;
  final String pangkat;
  final String? golongan;
  final String? korps;
  final String? satminkal;
  final String? tmtAnggota;
  final bool isAktif;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final double? totalSimpanan;
  final double? simpananPokok;
  final double? simpananWajib;
  final double? simpananSukarela;
  final double? creditLimit;
  final String? role;

  const Anggota({
    required this.id,
    required this.nrp,
    required this.nama,
    this.pangkat = '',
    this.golongan,
    this.korps,
    this.satminkal,
    this.tmtAnggota,
    this.isAktif = true,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalSimpanan,
    this.simpananPokok,
    this.simpananWajib,
    this.simpananSukarela,
    this.creditLimit,
    this.role,
  });

  String get nrpNip => nrp;

  factory Anggota.fromJson(Map<String, dynamic> json) {
    String extractPangkat(dynamic p) {
      if (p == null) return '';
      if (p is String) return p;
      if (p is Map<String, dynamic>) return p['nama']?.toString() ?? '';
      return p.toString();
    }

    String? extractKorps(dynamic k) {
      if (k == null) return null;
      if (k is String) return k;
      if (k is Map<String, dynamic>) return k['nama']?.toString() ?? k['kode']?.toString();
      return k.toString();
    }

    String? extractSatminkal(dynamic s) {
      if (s == null) return null;
      if (s is String) return s;
      if (s is Map<String, dynamic>) return s['nama']?.toString() ?? s['kode']?.toString();
      return s.toString();
    }

    return Anggota(
      id: json['id'] as String? ?? '',
      nrp: json['nrp'] as String? ?? json['nrpNip'] as String? ?? '',
      nama: json['nama'] as String? ?? json['namaLengkap'] as String? ?? '',
      pangkat: extractPangkat(json['pangkat']),
      golongan: json['golongan'] as String? ??
          (json['pangkat'] is Map ? json['pangkat']['kategori'] as String? : null),
      korps: extractKorps(json['korps']),
      satminkal: extractSatminkal(json['satminkal']),
      tmtAnggota: json['tmtAnggota'] as String?,
      isAktif: json['isAktif'] as bool? ?? (json['status'] == 'Aktif' || json['status'] == null),
      status: json['status'] as String? ?? (json['isAktif'] == false ? 'Non-Aktif' : 'Aktif'),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      totalSimpanan: (json['totalSimpanan'] as num?)?.toDouble(),
      simpananPokok: (json['simpananPokok'] as num?)?.toDouble(),
      simpananWajib: (json['simpananWajib'] as num?)?.toDouble(),
      simpananSukarela: (json['simpananSukarela'] as num?)?.toDouble(),
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nrp': nrp,
        'nrpNip': nrp,
        'nama': nama,
        'pangkat': pangkat,
        'golongan': golongan,
        'korps': korps,
        'satminkal': satminkal,
        'tmtAnggota': tmtAnggota,
        'isAktif': isAktif,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'totalSimpanan': totalSimpanan,
        'simpananPokok': simpananPokok,
        'simpananWajib': simpananWajib,
        'simpananSukarela': simpananSukarela,
        'creditLimit': creditLimit,
        'role': role,
      };
}
