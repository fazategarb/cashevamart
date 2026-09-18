/// Kategori Produk Toko
class KategoriProduk {
  final String id;
  final String nama;
  final String icon;

  const KategoriProduk({
    required this.id,
    required this.nama,
    required this.icon,
  });

  factory KategoriProduk.fromJson(Map<String, dynamic> json) {
    return KategoriProduk(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'Package',
    );
  }
}

/// Model Produk Toko Koperasi & UMKM
class Produk {
  final String id;
  final String barcode;
  final String nama;
  final String kategoriId;
  final String kategoriNama;
  final String satuanKecil;
  final String? satuanBesar;
  final int pcsPerUnit;
  final double hargaBeli;
  final double hargaJual;
  final int stokFisik;
  final int stokMinimum;
  final double diskonPersen;
  final bool isPromo;
  final bool isFastConsume;
  final String sumber; // "Koperasi" | "UMKM Anggota"
  final String? penjualNama;
  final String gambar;

  const Produk({
    required this.id,
    required this.barcode,
    required this.nama,
    required this.kategoriId,
    required this.kategoriNama,
    required this.satuanKecil,
    this.satuanBesar,
    this.pcsPerUnit = 1,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stokFisik,
    required this.stokMinimum,
    this.diskonPersen = 0.0,
    this.isPromo = false,
    this.isFastConsume = false,
    this.sumber = 'Koperasi',
    this.penjualNama,
    required this.gambar,
  });

  double get hargaAkhir => diskonPersen > 0 ? hargaJual * (1 - diskonPersen / 100) : hargaJual;

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id']?.toString() ?? '',
      barcode: json['barcode']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      kategoriId: json['kategoriId']?.toString() ?? '',
      kategoriNama: json['kategoriNama']?.toString() ?? '',
      satuanKecil: json['satuanKecil']?.toString() ?? 'Pcs',
      satuanBesar: json['satuanBesar']?.toString(),
      pcsPerUnit: (json['pcsPerUnit'] is num) ? (json['pcsPerUnit'] as num).toInt() : 1,
      hargaBeli: (json['hargaBeli'] is num) ? (json['hargaBeli'] as num).toDouble() : 0.0,
      hargaJual: (json['hargaJual'] is num) ? (json['hargaJual'] as num).toDouble() : 0.0,
      stokFisik: (json['stokFisik'] is num) ? (json['stokFisik'] as num).toInt() : 0,
      stokMinimum: (json['stokMinimum'] is num) ? (json['stokMinimum'] as num).toInt() : 5,
      diskonPersen: (json['diskonPersen'] is num) ? (json['diskonPersen'] as num).toDouble() : 0.0,
      isPromo: json['isPromo'] == true,
      isFastConsume: json['isFastConsume'] == true,
      sumber: json['sumber']?.toString() ?? 'Koperasi',
      penjualNama: json['penjualNama']?.toString(),
      gambar: json['gambar']?.toString() ?? '',
    );
  }
}

/// Item Keranjang Belanja / POS
class CartItem {
  final Produk produk;
  int quantity;
  final bool isSatuanBesar;

  CartItem({
    required this.produk,
    this.quantity = 1,
    this.isSatuanBesar = false,
  });

  double get hargaSatuan => produk.hargaAkhir;
  double get subtotal => hargaSatuan * quantity;
}

/// Tipe Pengiriman Pesanan
enum TipePengiriman {
  ambilSendiri('AMBIL_SENDIRI', 'Ambil Sendiri di Toko'),
  titipPiketSatuan('TITIP_PIKET_SATUAN', 'Titip Piket Satuan'),
  deliveryCepat('DELIVERY_CEPAT', 'Delivery Cepat / Barak');

  const TipePengiriman(this.value, this.label);
  final String value;
  final String label;

  static TipePengiriman fromString(String? val) {
    if (val == null) return TipePengiriman.ambilSendiri;
    for (final e in TipePengiriman.values) {
      if (e.value == val || e.name == val) return e;
    }
    return TipePengiriman.ambilSendiri;
  }
}

/// Status Pesanan Online
enum StatusPesanan {
  menungguKonfirmasi('MENUNGGU_KONFIRMASI', 'Menunggu Konfirmasi'),
  diprosesPetugas('DIPROSES_PETUGAS', 'Diproses Petugas'),
  sedangDiantar('SEDANG_DIANTAR', 'Sedang Diantar'),
  titipDiPiket('TITIP_DI_PIKET', 'Dititipkan di Piket'),
  selesai('SELESAI', 'Selesai');

  const StatusPesanan(this.value, this.label);
  final String value;
  final String label;

  static StatusPesanan fromString(String? val) {
    if (val == null) return StatusPesanan.menungguKonfirmasi;
    for (final e in StatusPesanan.values) {
      if (e.value == val || e.name == val) return e;
    }
    return StatusPesanan.menungguKonfirmasi;
  }
}

/// Item Pesanan Belanja Antar / Piket
class PesananItemDetail {
  final String nama;
  final int jumlah;
  final double harga;

  const PesananItemDetail({
    required this.nama,
    required this.jumlah,
    required this.harga,
  });

  factory PesananItemDetail.fromJson(Map<String, dynamic> json) {
    return PesananItemDetail(
      nama: json['nama']?.toString() ?? '',
      jumlah: (json['jumlah'] is num) ? (json['jumlah'] as num).toInt() : 1,
      harga: (json['harga'] is num) ? (json['harga'] as num).toDouble() : 0.0,
    );
  }
}

/// Model Pesanan Online
class PesananOnline {
  final String id;
  final String nomorPesanan;
  final String anggotaNama;
  final String anggotaNrp;
  final TipePengiriman tipe;
  final String lokasi;
  final String? petugasPiket;
  final String noHp;
  final double totalBelanja;
  final double ongkir;
  final double totalTagihan;
  final StatusPesanan status;
  final int estimasiMenit;
  final int menitBerjalan;
  final bool isTerlambatSla;
  final double kompensasiDiskon;
  final List<PesananItemDetail> items;
  final String waktuPesan;

  const PesananOnline({
    required this.id,
    required this.nomorPesanan,
    required this.anggotaNama,
    required this.anggotaNrp,
    required this.tipe,
    required this.lokasi,
    this.petugasPiket,
    required this.noHp,
    required this.totalBelanja,
    required this.ongkir,
    required this.totalTagihan,
    required this.status,
    required this.estimasiMenit,
    required this.menitBerjalan,
    required this.isTerlambatSla,
    required this.kompensasiDiskon,
    required this.items,
    required this.waktuPesan,
  });

  factory PesananOnline.fromJson(Map<String, dynamic> json) {
    return PesananOnline(
      id: json['id']?.toString() ?? '',
      nomorPesanan: json['nomorPesanan']?.toString() ?? '',
      anggotaNama: json['anggotaNama']?.toString() ?? '',
      anggotaNrp: json['anggotaNrp']?.toString() ?? '',
      tipe: TipePengiriman.fromString(json['tipe']?.toString()),
      lokasi: json['lokasi']?.toString() ?? '',
      petugasPiket: json['petugasPiket']?.toString(),
      noHp: json['noHp']?.toString() ?? '',
      totalBelanja: (json['totalBelanja'] is num) ? (json['totalBelanja'] as num).toDouble() : 0.0,
      ongkir: (json['ongkir'] is num) ? (json['ongkir'] as num).toDouble() : 0.0,
      totalTagihan: (json['totalTagihan'] is num) ? (json['totalTagihan'] as num).toDouble() : 0.0,
      status: StatusPesanan.fromString(json['status']?.toString()),
      estimasiMenit: (json['estimasiMenit'] is num) ? (json['estimasiMenit'] as num).toInt() : 30,
      menitBerjalan: (json['menitBerjalan'] is num) ? (json['menitBerjalan'] as num).toInt() : 0,
      isTerlambatSla: json['isTerlambatSla'] == true,
      kompensasiDiskon: (json['kompensasiDiskon'] is num) ? (json['kompensasiDiskon'] as num).toDouble() : 0.0,
      items: json['items'] is List
          ? (json['items'] as List).map((i) => PesananItemDetail.fromJson(i)).toList()
          : [],
      waktuPesan: json['waktuPesan']?.toString() ?? '',
    );
  }
}

/// Model Supplier
class Supplier {
  final String id;
  final String kode;
  final String nama;
  final String kontak;
  final String telepon;
  final String alamat;
  final double totalHutang;

  const Supplier({
    required this.id,
    required this.kode,
    required this.nama,
    required this.kontak,
    required this.telepon,
    required this.alamat,
    required this.totalHutang,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id']?.toString() ?? '',
      kode: json['kode']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      kontak: json['kontak']?.toString() ?? '',
      telepon: json['telepon']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      totalHutang: (json['totalHutang'] is num) ? (json['totalHutang'] as num).toDouble() : 0.0,
    );
  }
}

/// Model Gadai & SBG (Surat Bukti Gadai)
enum KategoriGadai {
  emasPerhiasan('EMAS_PERHIASAN', 'Emas & Perhiasan'),
  elektronikGadget('ELEKTRONIK_GADGET', 'Elektronik & Gadget'),
  kendaraanBermotor('KENDARAAN_BERMOTOR', 'Kendaraan Bermotor');

  const KategoriGadai(this.value, this.label);
  final String value;
  final String label;

  static KategoriGadai fromString(String? val) {
    if (val == null) return KategoriGadai.emasPerhiasan;
    for (final e in KategoriGadai.values) {
      if (e.value == val || e.name == val) return e;
    }
    return KategoriGadai.emasPerhiasan;
  }
}

enum StatusGadai {
  aktifBerjalan('AKTIF_BERJALAN', 'Aktif Berjalan'),
  ditebusLunas('DITEBUS_LUNAS', 'Ditebus Lunas'),
  jatuhTempoLelang('JATUH_TEMPO_LELANG', 'Jatuh Tempo / Siap Lelang'),
  barangTerjualLelang('BARANG_TERJUAL_LELANG', 'Terjual di Lelang');

  const StatusGadai(this.value, this.label);
  final String value;
  final String label;

  static StatusGadai fromString(String? val) {
    if (val == null) return StatusGadai.aktifBerjalan;
    for (final e in StatusGadai.values) {
      if (e.value == val || e.name == val) return e;
    }
    return StatusGadai.aktifBerjalan;
  }
}

class GadaiItem {
  final String id;
  final String nomorSbg;
  final String anggotaNama;
  final String anggotaNrp;
  final KategoriGadai kategori;
  final String namaBarang;
  final String spesifikasi;
  final double nilaiTaksiran;
  final double uangPinjaman;
  final double jasaTitipBulan;
  final String tanggalGadai;
  final String jatuhTempo;
  final StatusGadai status;
  final double? hargaLelangBuka;
  final double? hargaLelangTerjual;
  final String foto;

  const GadaiItem({
    required this.id,
    required this.nomorSbg,
    required this.anggotaNama,
    required this.anggotaNrp,
    required this.kategori,
    required this.namaBarang,
    required this.spesifikasi,
    required this.nilaiTaksiran,
    required this.uangPinjaman,
    required this.jasaTitipBulan,
    required this.tanggalGadai,
    required this.jatuhTempo,
    required this.status,
    this.hargaLelangBuka,
    this.hargaLelangTerjual,
    required this.foto,
  });

  factory GadaiItem.fromJson(Map<String, dynamic> json) {
    return GadaiItem(
      id: json['id']?.toString() ?? '',
      nomorSbg: json['nomorSbg']?.toString() ?? '',
      anggotaNama: json['anggotaNama']?.toString() ?? '',
      anggotaNrp: json['anggotaNrp']?.toString() ?? '',
      kategori: KategoriGadai.fromString(json['kategori']?.toString()),
      namaBarang: json['namaBarang']?.toString() ?? '',
      spesifikasi: json['spesifikasi']?.toString() ?? '',
      nilaiTaksiran: (json['nilaiTaksiran'] is num) ? (json['nilaiTaksiran'] as num).toDouble() : 0.0,
      uangPinjaman: (json['uangPinjaman'] is num) ? (json['uangPinjaman'] as num).toDouble() : 0.0,
      jasaTitipBulan: (json['jasaTitipBulan'] is num) ? (json['jasaTitipBulan'] as num).toDouble() : 0.0,
      tanggalGadai: json['tanggalGadai']?.toString() ?? '',
      jatuhTempo: json['jatuhTempo']?.toString() ?? '',
      status: StatusGadai.fromString(json['status']?.toString()),
      hargaLelangBuka: (json['hargaLelangBuka'] is num) ? (json['hargaLelangBuka'] as num).toDouble() : null,
      hargaLelangTerjual: (json['hargaLelangTerjual'] is num) ? (json['hargaLelangTerjual'] as num).toDouble() : null,
      foto: json['foto']?.toString() ?? '',
    );
  }
}

/// Model Pengajuan Produk UMKM Anggota
class PengajuanMarketplace {
  final String id;
  final String anggotaNama;
  final String anggotaNrp;
  final String namaProduk;
  final String kategori;
  final double hargaUsul;
  final int stokAwal;
  final double komisiPersen;
  final String status; // "DIAJUKAN" | "DISETUJUI" | "DITOLAK"
  final String? catatan;
  final String gambar;
  final String tanggal;

  const PengajuanMarketplace({
    required this.id,
    required this.anggotaNama,
    required this.anggotaNrp,
    required this.namaProduk,
    required this.kategori,
    required this.hargaUsul,
    required this.stokAwal,
    required this.komisiPersen,
    required this.status,
    this.catatan,
    required this.gambar,
    required this.tanggal,
  });

  factory PengajuanMarketplace.fromJson(Map<String, dynamic> json) {
    return PengajuanMarketplace(
      id: json['id']?.toString() ?? '',
      anggotaNama: json['anggotaNama']?.toString() ?? '',
      anggotaNrp: json['anggotaNrp']?.toString() ?? '',
      namaProduk: json['namaProduk']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      hargaUsul: (json['hargaUsul'] is num) ? (json['hargaUsul'] as num).toDouble() : 0.0,
      stokAwal: (json['stokAwal'] is num) ? (json['stokAwal'] as num).toInt() : 0,
      komisiPersen: (json['komisiPersen'] is num) ? (json['komisiPersen'] as num).toDouble() : 5.0,
      status: json['status']?.toString() ?? 'DIAJUKAN',
      catatan: json['catatan']?.toString(),
      gambar: json['gambar']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '',
    );
  }
}

/// Model Poin & Undian Doorprize RAT
class PoinDanUndian {
  final int totalPoin;
  final int totalPoinKlaim;
  final List<String> kuponSaya;
  final double targetBelanjaNominal;
  final double belanjaBulanIni;
  final int bonusPoinTarget;
  final EventUndian eventAktif;

  const PoinDanUndian({
    required this.totalPoin,
    required this.totalPoinKlaim,
    required this.kuponSaya,
    required this.targetBelanjaNominal,
    required this.belanjaBulanIni,
    required this.bonusPoinTarget,
    required this.eventAktif,
  });

  factory PoinDanUndian.fromJson(Map<String, dynamic> json) {
    return PoinDanUndian(
      totalPoin: (json['totalPoin'] is num) ? (json['totalPoin'] as num).toInt() : 0,
      totalPoinKlaim: (json['totalPoinKlaim'] is num) ? (json['totalPoinKlaim'] as num).toInt() : 0,
      kuponSaya: json['kuponSaya'] is List ? (json['kuponSaya'] as List).map((k) => k.toString()).toList() : [],
      targetBelanjaNominal: (json['targetBelanjaNominal'] is num) ? (json['targetBelanjaNominal'] as num).toDouble() : 500000.0,
      belanjaBulanIni: (json['belanjaBulanIni'] is num) ? (json['belanjaBulanIni'] as num).toDouble() : 0.0,
      bonusPoinTarget: (json['bonusPoinTarget'] is num) ? (json['bonusPoinTarget'] as num).toInt() : 100,
      eventAktif: json['eventAktif'] != null
          ? EventUndian.fromJson(json['eventAktif'])
          : const EventUndian(
              id: 'EVT-DEFAULT',
              nama: 'Undian Doorprize RAT',
              hadiahUtama: 'Sepeda Motor & Logam Mulia',
              poinPerKupon: 50,
              tanggalUndi: '20 Des 2026',
              totalKuponTerdaftar: 428,
            ),
    );
  }
}

class EventUndian {
  final String id;
  final String nama;
  final String hadiahUtama;
  final int poinPerKupon;
  final String tanggalUndi;
  final int totalKuponTerdaftar;

  const EventUndian({
    required this.id,
    required this.nama,
    required this.hadiahUtama,
    required this.poinPerKupon,
    required this.tanggalUndi,
    required this.totalKuponTerdaftar,
  });

  factory EventUndian.fromJson(Map<String, dynamic> json) {
    return EventUndian(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? '',
      hadiahUtama: json['hadiahUtama']?.toString() ?? '',
      poinPerKupon: (json['poinPerKupon'] is num) ? (json['poinPerKupon'] as num).toInt() : 50,
      tanggalUndi: json['tanggalUndi']?.toString() ?? '',
      totalKuponTerdaftar: (json['totalKuponTerdaftar'] is num) ? (json['totalKuponTerdaftar'] as num).toInt() : 0,
    );
  }
}
