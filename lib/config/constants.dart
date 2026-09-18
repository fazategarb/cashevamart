/// Static data constants ported from casheva-data.ts
class AppConstants {
  AppConstants._();

  static const String appName = 'Casheva';
  static const String appTagline = 'Sistem Informasi Koperasi Simpan Pinjam TNI AD';
  static const String appSubtitle = 'Transparan, Akuntabel, dan Terintegrasi';
  static const String copyright = '© 2026 Koperasi TNI AD · Infolahtadam IV/Diponegoro. Created by Todskyyy';

  static const String defaultSatminkal = 'INFOLAHTADAM IV/DIPONEGORO';
  static const String defaultKotama = 'KODAM IV/DIPONEGORO';

  /// Potongan simpanan sukarela per golongan pangkat
  static const Map<String, int> potonganSukarela = {
    'Pati': 500000,
    'Pamen': 300000,
    'Pama': 250000,
    'Bintara': 200000,
    'Tamtama': 150000,
    'PNS': 150000,
    'Ba/Ta/ASN': 150000,
  };

  /// Distribusi SHU sesuai AD/ART Juknis TNI AD
  static const List<Map<String, dynamic>> shuDistribusi = [
    {'pos': 'Jasa Modal Anggota', 'persen': 20},
    {'pos': 'Jasa Usaha / Transaksi Anggota', 'persen': 30},
    {'pos': 'Dana Cadangan Koperasi', 'persen': 20},
    {'pos': 'Dana Pengurus & Pengawas', 'persen': 10},
    {'pos': 'Dana Pendidikan Koperasi', 'persen': 5},
    {'pos': 'Dana Sosial & Pembinaan Satuan', 'persen': 10},
    {'pos': 'Dana Karyawan / Staf', 'persen': 5},
  ];

  /// Alur workflow persetujuan pinjaman berjenjang
  static const List<String> workflowSteps = [
    'Pengajuan',
    'Verifikasi Jurbay',
    'Rekomendasi Dan/Ka',
    'ACC Keprim',
    'Upload Berkas',
    'Pencairan',
  ];

  /// Session idle timeout (15 menit)
  static const Duration sessionTimeout = Duration(minutes: 15);

  /// Session warning before timeout (14 menit)
  static const Duration sessionWarning = Duration(minutes: 14);

  /// Local storage keys
  static const String tokenKey = 'casheva.token';
  static const String authKey = 'casheva.auth';
  static const String roleKey = 'casheva.role';
  static const String originalRoleKey = 'casheva.originalRole';
  static const String userKey = 'casheva.user';
}
