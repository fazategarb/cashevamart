class ApiConfig {
  ApiConfig._();

  /// Production API (same as website)
  static const String productionUrl = 'https://casheva-db.onrender.com/api';

  /// Development API (localhost via Android emulator)
  static const String developmentUrl = 'http://10.0.2.2:3000/api';

  /// Active API base URL
  static String get baseUrl => productionUrl;

  // ── Auth ──
  static const String loginEndpoint = '/auth/login';
  static const String profileEndpoint = '/auth/profile';

  // ── Dashboard ──
  static const String dashboardSummary = '/dashboard/summary';
  static String dashboardCharts({int? tahun}) =>
      '/dashboard/charts${tahun != null ? '?tahun=$tahun' : ''}';

  // ── Anggota ──
  static const String anggota = '/anggota';
  static String anggotaById(String id) => '/anggota/$id';

  // ── Simpanan ──
  static const String simpanan = '/simpanan';
  static const String simpananRekap = '/simpanan/rekap';
  static const String simpananBatch = '/simpanan/batch';
  static String simpananByAnggota(String anggotaId) =>
      '/simpanan/anggota/$anggotaId';

  // ── Pinjaman ──
  static const String pinjaman = '/pinjaman';
  static String pinjamanById(String id) => '/pinjaman/$id';
  static String pinjamanStatus(String id) => '/pinjaman/$id/status';
  static String pinjamanCairkan(String id) => '/pinjaman/$id/cairkan';
  static String pinjamanPelunasan(String id) =>
      '/pinjaman/$id/pelunasan-dipercepat';
  static const String pengaturanBunga = '/pinjaman/pengaturan-bunga';
  static String bayarAngsuran(String angsuranId) =>
      '/pinjaman/angsuran/$angsuranId/bayar';
  static String kalkulasiDinamis(String pinjamanId) =>
      '/pinjaman/$pinjamanId/kalkulasi-dinamis';
  static String bayarDinamis(String pinjamanId) =>
      '/pinjaman/$pinjamanId/bayar-dinamis';
  static String plafond(String anggotaId) => '/pinjaman/plafond/$anggotaId';
  static String rekapAngsuranBulanan(int bulan, int tahun) =>
      '/pinjaman/rekap-angsuran-bulanan?bulan=$bulan&tahun=$tahun';

  // ── Keuangan ──
  static const String pendapatan = '/keuangan/pendapatan';
  static const String biayaOperasional = '/keuangan/biaya';
  static const String ringkasanKeuangan = '/keuangan/ringkasan';

  // ── Reports ──
  static const String reportLaporan = '/reports/laporan-keuangan';
  static const String reportShuAnggota = '/reports/shu-anggota';

  // ── Master ──
  static const String masterPangkat = '/master/pangkat';
  static const String masterKorps = '/master/korps';
  static const String masterSatminkal = '/master/satminkal';
  static const String masterKotama = '/master/kotama';

  // ── Kopstuk ──
  static const String kopstuk = '/kopstuk';

  // ── Tajuk TTD ──
  static const String tajukTtd = '/tajuk-ttd';

  // ── Users ──
  static const String users = '/users';
  static String userById(String id) => '/users/$id';

  // ── Dokumen ──
  static const String dokumen = '/dokumen';
  static String dokumenByPinjaman(String pinjamanId) =>
      '/dokumen/pinjaman/$pinjamanId';
  static String dokumenUpload(String pinjamanId) =>
      '/dokumen/pinjaman/$pinjamanId/upload';

  // ── Backup ──
  static const String backupStatus = '/backup/status';
  static const String backupDownload = '/backup/download-encrypted';
}
