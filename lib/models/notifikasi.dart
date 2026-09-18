enum TipeNotifikasi {
  info('INFO'),
  sukses('SUKSES'),
  peringatan('PERINGATAN'),
  danger('DANGER'),
  pinjaman('PINJAMAN'),
  verifikasi('VERIFIKASI'),
  pesanan('PESANAN'),
  rat('RAT');

  const TipeNotifikasi(this.value);
  final String value;
}

class NotifikasiItem {
  final String id;
  final String judul;
  final String pesan;
  final TipeNotifikasi tipe;
  final DateTime waktu;
  final bool isRead;
  final String? routeTarget;
  final Map<String, dynamic>? data;

  const NotifikasiItem({
    required this.id,
    required this.judul,
    required this.pesan,
    this.tipe = TipeNotifikasi.info,
    required this.waktu,
    this.isRead = false,
    this.routeTarget,
    this.data,
  });

  NotifikasiItem copyWith({
    bool? isRead,
  }) {
    return NotifikasiItem(
      id: id,
      judul: judul,
      pesan: pesan,
      tipe: tipe,
      waktu: waktu,
      isRead: isRead ?? this.isRead,
      routeTarget: routeTarget,
      data: data,
    );
  }

  factory NotifikasiItem.fromJson(Map<String, dynamic> json) {
    return NotifikasiItem(
      id: json['id']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      pesan: json['pesan']?.toString() ?? '',
      tipe: TipeNotifikasi.values.firstWhere(
        (t) => t.value == json['tipe']?.toString().toUpperCase(),
        orElse: () => TipeNotifikasi.info,
      ),
      waktu: json['waktu'] != null
          ? (DateTime.tryParse(json['waktu'].toString()) ?? DateTime.now())
          : DateTime.now(),
      isRead: json['isRead'] == true,
      routeTarget: json['routeTarget']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
