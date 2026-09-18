import '../models/toko.dart';

/// Service untuk Unit Usaha Toko, POS, Gadai, Supplier, Poin & UMKM
class TokoService {
  TokoService._();
  static final TokoService instance = TokoService._();

  static final List<KategoriProduk> mockKategori = [
    const KategoriProduk(id: 'KAT-01', nama: 'Sembako & Kebutuhan Pokok', icon: 'Package'),
    const KategoriProduk(id: 'KAT-02', nama: 'Makanan & Minuman (Fast Consume)', icon: 'UtensilsCrossed'),
    const KategoriProduk(id: 'KAT-03', nama: 'Kaporlap & Atribut TNI AD', icon: 'Shield'),
    const KategoriProduk(id: 'KAT-04', nama: 'Elektronik & Gadget', icon: 'Tv'),
    const KategoriProduk(id: 'KAT-05', nama: 'Produk UMKM Anggota', icon: 'Store'),
  ];

  static final List<Produk> mockProduk = [
    const Produk(
      id: 'PRD-001',
      barcode: '8992753123456',
      nama: 'Beras Premium Koperasi 5 Kg',
      kategoriId: 'KAT-01',
      kategoriNama: 'Sembako & Kebutuhan Pokok',
      satuanKecil: 'Sak',
      satuanBesar: 'Karung',
      pcsPerUnit: 10,
      hargaBeli: 68000,
      hargaJual: 74000,
      stokFisik: 45,
      stokMinimum: 10,
      diskonPersen: 0,
      isPromo: false,
      isFastConsume: false,
      sumber: 'Koperasi',
      gambar: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&auto=format&fit=crop&q=80',
    ),
    const Produk(
      id: 'PRD-002',
      barcode: '8991001123456',
      nama: 'Minyak Goreng Sawit 2 Liter',
      kategoriId: 'KAT-01',
      kategoriNama: 'Sembako & Kebutuhan Pokok',
      satuanKecil: 'Pcs',
      satuanBesar: 'Dus',
      pcsPerUnit: 6,
      hargaBeli: 31500,
      hargaJual: 35000,
      stokFisik: 84,
      stokMinimum: 12,
      diskonPersen: 5,
      isPromo: true,
      isFastConsume: false,
      sumber: 'Koperasi',
      gambar: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&auto=format&fit=crop&q=80',
    ),
    const Produk(
      id: 'PRD-003',
      barcode: '8993175123456',
      nama: 'Kopi Hitam Prajurit Sachet (Pak)',
      kategoriId: 'KAT-02',
      kategoriNama: 'Makanan & Minuman (Fast Consume)',
      satuanKecil: 'Renceng',
      satuanBesar: 'Dus',
      pcsPerUnit: 20,
      hargaBeli: 12000,
      hargaJual: 15000,
      stokFisik: 120,
      stokMinimum: 20,
      diskonPersen: 0,
      isPromo: false,
      isFastConsume: true,
      sumber: 'Koperasi',
      gambar: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&auto=format&fit=crop&q=80',
    ),
    const Produk(
      id: 'PRD-004',
      barcode: '8999999123456',
      nama: 'Mie Instan Goreng Rasa Spesial (Dus)',
      kategoriId: 'KAT-02',
      kategoriNama: 'Makanan & Minuman (Fast Consume)',
      satuanKecil: 'Bks',
      satuanBesar: 'Dus',
      pcsPerUnit: 40,
      hargaBeli: 108000,
      hargaJual: 120000,
      stokFisik: 38,
      stokMinimum: 10,
      diskonPersen: 0,
      isPromo: false,
      isFastConsume: true,
      sumber: 'Koperasi',
      gambar: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=400&auto=format&fit=crop&q=80',
    ),
    const Produk(
      id: 'PRD-005',
      barcode: 'TNI-KPL-00123',
      nama: 'Kaos Dalam Loreng Malvinas TNI AD',
      kategoriId: 'KAT-03',
      kategoriNama: 'Kaporlap & Atribut TNI AD',
      satuanKecil: 'Pcs',
      satuanBesar: 'Lusin',
      pcsPerUnit: 12,
      hargaBeli: 38000,
      hargaJual: 48000,
      stokFisik: 60,
      stokMinimum: 15,
      diskonPersen: 10,
      isPromo: true,
      isFastConsume: false,
      sumber: 'Koperasi',
      gambar: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=400&auto=format&fit=crop&q=80',
    ),
    const Produk(
      id: 'PRD-006',
      barcode: 'TNI-KPL-00124',
      nama: 'Sepatu PDL Kulit Kilap Jatah',
      kategoriId: 'KAT-03',
      kategoriNama: 'Kaporlap & Atribut TNI AD',
      satuanKecil: 'Pasang',
      satuanBesar: 'Karton',
      pcsPerUnit: 10,
      hargaBeli: 285000,
      hargaJual: 350000,
      stokFisik: 8,
      stokMinimum: 5,
      diskonPersen: 0,
      isPromo: false,
      isFastConsume: false,
      sumber: 'Koperasi',
      gambar: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&auto=format&fit=crop&q=80',
    ),
    const Produk(
      id: 'PRD-007',
      barcode: 'MKP-000001',
      nama: '[UMKM] Keripik Tempe Renyah Buatan Persit',
      kategoriId: 'KAT-05',
      kategoriNama: 'Produk UMKM Anggota',
      satuanKecil: 'Bks',
      satuanBesar: 'Paket',
      pcsPerUnit: 5,
      hargaBeli: 12000,
      hargaJual: 15000,
      stokFisik: 25,
      stokMinimum: 5,
      diskonPersen: 0,
      isPromo: false,
      isFastConsume: true,
      sumber: 'UMKM Anggota',
      penjualNama: 'Ny. Sri Wahyuni',
      gambar: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=400&auto=format&fit=crop&q=80',
    ),
    const Produk(
      id: 'PRD-008',
      barcode: 'MKP-000002',
      nama: '[UMKM] Sambal Bawang Teri Barak',
      kategoriId: 'KAT-05',
      kategoriNama: 'Produk UMKM Anggota',
      satuanKecil: 'Btl',
      satuanBesar: 'Lusin',
      pcsPerUnit: 12,
      hargaBeli: 20000,
      hargaJual: 25000,
      stokFisik: 18,
      stokMinimum: 5,
      diskonPersen: 0,
      isPromo: false,
      isFastConsume: true,
      sumber: 'UMKM Anggota',
      penjualNama: 'Serma Budi Santoso',
      gambar: 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=400&auto=format&fit=crop&q=80',
    ),
  ];

  static final List<PesananOnline> mockPesanan = [
    const PesananOnline(
      id: 'ORD-001',
      nomorPesanan: 'ORD-20260806-0001',
      anggotaNama: 'Sertu Hendra Gunawan',
      anggotaNrp: '31770091',
      tipe: TipePengiriman.deliveryCepat,
      lokasi: 'Barak Remaja Batalyon B - Lt. 2',
      noHp: '081398765432',
      totalBelanja: 65000,
      ongkir: 5000,
      totalTagihan: 70000,
      status: StatusPesanan.sedangDiantar,
      estimasiMenit: 30,
      menitBerjalan: 18,
      isTerlambatSla: false,
      kompensasiDiskon: 0,
      items: [
        PesananItemDetail(nama: 'Kopi Hitam Prajurit Sachet', jumlah: 2, harga: 15000),
        PesananItemDetail(nama: 'Mie Instan Goreng Rasa Spesial', jumlah: 5, harga: 3000),
        PesananItemDetail(nama: '[UMKM] Keripik Tempe Renyah', jumlah: 1, harga: 15000),
      ],
      waktuPesan: '06 Agu 2026 14:15',
    ),
    const PesananOnline(
      id: 'ORD-002',
      nomorPesanan: 'ORD-20260806-0002',
      anggotaNama: 'Kapten Inf Rahmat Hidayat',
      anggotaNrp: '11060078',
      tipe: TipePengiriman.titipPiketSatuan,
      lokasi: 'Meja Piket Penjagaan Utama',
      petugasPiket: 'Serda Yoga Pratama (Piket Jaga)',
      noHp: '081245678901',
      totalBelanja: 158000,
      ongkir: 0,
      totalTagihan: 158000,
      status: StatusPesanan.titipDiPiket,
      estimasiMenit: 45,
      menitBerjalan: 35,
      isTerlambatSla: false,
      kompensasiDiskon: 0,
      items: [
        PesananItemDetail(nama: 'Beras Premium Koperasi 5 Kg', jumlah: 1, harga: 74000),
        PesananItemDetail(nama: 'Minyak Goreng Sawit 2 Liter', jumlah: 2, harga: 35000),
        PesananItemDetail(nama: '[UMKM] Sambal Bawang Teri', jumlah: 1, harga: 25000),
      ],
      waktuPesan: '06 Agu 2026 13:30',
    ),
    const PesananOnline(
      id: 'ORD-003',
      nomorPesanan: 'ORD-20260806-0004',
      anggotaNama: 'Kapten Cpm Indra, S.Kom.',
      anggotaNrp: '1122334455',
      tipe: TipePengiriman.deliveryCepat,
      lokasi: 'Rumah Dinas Perwira Blok A No. 05',
      noHp: '081299887766',
      totalBelanja: 125000,
      ongkir: 5000,
      totalTagihan: 130000,
      status: StatusPesanan.sedangDiantar,
      estimasiMenit: 30,
      menitBerjalan: 12,
      isTerlambatSla: false,
      kompensasiDiskon: 0,
      items: [
        PesananItemDetail(nama: 'Beras Premium Koperasi 5 Kg', jumlah: 1, harga: 74000),
        PesananItemDetail(nama: 'Kopi Hitam Prajurit Sachet', jumlah: 2, harga: 15000),
        PesananItemDetail(nama: '[UMKM] Keripik Tempe Renyah', jumlah: 1, harga: 15000),
      ],
      waktuPesan: '06 Agu 2026 14:30',
    ),
  ];

  static final List<Supplier> mockSuppliers = [
    const Supplier(
      id: 'SUP-001',
      kode: 'SUP-001',
      nama: 'PT Indofood Sukses Makmur',
      kontak: 'Bpk. Bambang',
      telepon: '081234567890',
      alamat: 'Kawasan Industri Candi Semarang',
      totalHutang: 8450000,
    ),
    const Supplier(
      id: 'SUP-002',
      kode: 'SUP-002',
      nama: 'CV Kaporlap Jaya Abadi',
      kontak: 'Ibu Ratna',
      telepon: '081987654321',
      alamat: 'Jl. Pemuda No. 88 Bandung',
      totalHutang: 12600000,
    ),
    const Supplier(
      id: 'SUP-003',
      kode: 'SUP-003',
      nama: 'Perum BULOG Kanwil Jateng',
      kontak: 'Bpk. Irwan',
      telepon: '082145678912',
      alamat: 'Jl. Menteri Supeno No. 1 Semarang',
      totalHutang: 0,
    ),
  ];

  static final List<GadaiItem> mockGadai = [
    const GadaiItem(
      id: 'GD-001',
      nomorSbg: 'SBG-20260715-0012',
      anggotaNama: 'Serma Budi Santoso',
      anggotaNrp: '21980045',
      kategori: KategoriGadai.emasPerhiasan,
      namaBarang: 'Kalung Emas Kuning 22 Karat',
      spesifikasi: 'Berat 10.5 gram, kadar 87.5%, kondisi mulus + surat toko',
      nilaiTaksiran: 12500000,
      uangPinjaman: 10000000,
      jasaTitipBulan: 150000,
      tanggalGadai: '15 Jul 2026',
      jatuhTempo: '15 Nov 2026',
      status: StatusGadai.aktifBerjalan,
      foto: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400&auto=format&fit=crop&q=80',
    ),
    const GadaiItem(
      id: 'GD-002',
      nomorSbg: 'SBG-20260410-0004',
      anggotaNama: 'PNS Sri Wahyuni',
      anggotaNrp: '198504112009',
      kategori: KategoriGadai.elektronikGadget,
      namaBarang: 'Laptop Asus Vivobook 14 Core i5',
      spesifikasi: 'RAM 8GB, SSD 512GB, Charger Ori, Box Lengkap',
      nilaiTaksiran: 6500000,
      uangPinjaman: 4500000,
      jasaTitipBulan: 67500,
      tanggalGadai: '10 Apr 2026',
      jatuhTempo: '10 Agu 2026',
      status: StatusGadai.jatuhTempoLelang,
      hargaLelangBuka: 4800000,
      foto: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&auto=format&fit=crop&q=80',
    ),
  ];

  static final List<PengajuanMarketplace> mockMarketplace = [
    const PengajuanMarketplace(
      id: 'MKP-REQ-001',
      anggotaNama: 'Ny. Sri Wahyuni (Persit)',
      anggotaNrp: '198504112009',
      namaProduk: 'Keripik Tempe Renyah Gurih',
      kategori: 'Makanan Ringan',
      hargaUsul: 15000,
      stokAwal: 30,
      komisiPersen: 5,
      status: 'DISETUJUI',
      catatan: 'Kualitas kemasan bagus, higienis, layak jual di etalase',
      gambar: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=400&auto=format&fit=crop&q=80',
      tanggal: '02 Agu 2026',
    ),
    const PengajuanMarketplace(
      id: 'MKP-REQ-002',
      anggotaNama: 'Serma Budi Santoso',
      anggotaNrp: '21980045',
      namaProduk: 'Madu Hutan Asli Murni 500ml',
      kategori: 'Kesehatan & Herbal',
      hargaUsul: 85000,
      stokAwal: 15,
      komisiPersen: 7.5,
      status: 'DIAJUKAN',
      catatan: 'Menunggu pengecekan segel kemasan oleh bendahara toko',
      gambar: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400&auto=format&fit=crop&q=80',
      tanggal: '05 Agu 2026',
    ),
  ];

  Future<List<Produk>> getProdukList({String? kategoriId, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var list = mockProduk;
    if (kategoriId != null && kategoriId.isNotEmpty) {
      list = list.where((p) => p.kategoriId == kategoriId).toList();
    }
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((p) => p.nama.toLowerCase().contains(q) || p.barcode.contains(q)).toList();
    }
    return list;
  }

  Future<List<KategoriProduk>> getKategoriList() async {
    return mockKategori;
  }

  Future<List<PesananOnline>> getPesananList({
    String? nrp,
    String? nama,
    String? username,
    bool isStaff = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (isStaff) {
      return List.from(mockPesanan);
    }

    final queryNrp = (nrp ?? username ?? '').trim();
    final queryNama = (nama ?? '').toLowerCase().trim();

    return mockPesanan.where((ord) {
      if (queryNrp.isNotEmpty && ord.anggotaNrp == queryNrp) return true;
      final ordName = ord.anggotaNama.toLowerCase();
      if (queryNama.isNotEmpty && (ordName.contains(queryNama) || queryNama.contains(ordName))) {
        return true;
      }
      if ((queryNrp.toLowerCase().contains('indra') || queryNama.contains('indra')) &&
          (ordName.contains('indra') || ord.anggotaNrp == '1122334455')) {
        return true;
      }
      return false;
    }).toList();
  }

  void tambahPesanan(PesananOnline order) {
    mockPesanan.insert(0, order);
  }

  void updateStatusPesanan(String orderId, StatusPesanan newStatus) {
    final idx = mockPesanan.indexWhere((p) => p.id == orderId || p.nomorPesanan == orderId);
    if (idx != -1) {
      final old = mockPesanan[idx];
      mockPesanan[idx] = PesananOnline(
        id: old.id,
        nomorPesanan: old.nomorPesanan,
        anggotaNama: old.anggotaNama,
        anggotaNrp: old.anggotaNrp,
        tipe: old.tipe,
        lokasi: old.lokasi,
        petugasPiket: old.petugasPiket,
        noHp: old.noHp,
        totalBelanja: old.totalBelanja,
        ongkir: old.ongkir,
        totalTagihan: old.totalTagihan,
        status: newStatus,
        estimasiMenit: old.estimasiMenit,
        menitBerjalan: old.menitBerjalan,
        isTerlambatSla: old.isTerlambatSla,
        kompensasiDiskon: old.kompensasiDiskon,
        items: old.items,
        waktuPesan: old.waktuPesan,
      );
    }
  }

  Future<List<Supplier>> getSupplierList() async {
    return mockSupplierList;
  }

  static List<Supplier> get mockSupplierList => mockSuppliers;

  Future<List<GadaiItem>> getGadaiList() async {
    return mockGadai;
  }

  Future<List<PengajuanMarketplace>> getMarketplaceList() async {
    return mockMarketplace;
  }
}
