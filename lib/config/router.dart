import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/profile_screen.dart';
import '../screens/notifikasi/notifikasi_screen.dart';
import '../screens/dashboards/dashboard_screen.dart';

import '../screens/pinjaman/pengajuan_pinjaman_screen.dart';
import '../screens/pinjaman/riwayat_pinjaman_screen.dart';
import '../screens/pinjaman/simpanan_screen.dart';
import '../screens/pinjaman/pencairan_screen.dart';
import '../screens/pinjaman/angsuran_screen.dart';
import '../screens/pinjaman/gaji_screen.dart';

import '../screens/approval/verifikasi_screen.dart';
import '../screens/approval/rekomendasi_screen.dart';
import '../screens/approval/acc_screen.dart';
import '../screens/approval/audit_flow_screen.dart';

import '../screens/toko/katalog_belanja_screen.dart';
import '../screens/toko/keranjang_screen.dart';
import '../screens/toko/pos_kasir_screen.dart';
import '../screens/toko/inventori_screen.dart';
import '../screens/toko/pesanan_antar_screen.dart';
import '../screens/toko/supplier_screen.dart';
import '../screens/toko/marketplace_anggota_screen.dart';
import '../screens/toko/gadai_screen.dart';
import '../screens/toko/poin_undian_screen.dart';
import '../screens/toko/toko_transaksi_screen.dart';
import '../screens/toko/laporan_toko_screen.dart';

import '../screens/keuangan/likuiditas_screen.dart';
import '../screens/keuangan/shu_screen.dart';
import '../screens/keuangan/laporan_screen.dart';
import '../screens/keuangan/transaksi_screen.dart';

import '../screens/master/users_screen.dart';
import '../screens/master/anggota_screen.dart';
import '../screens/master/master_data_screen.dart';
import '../screens/master/kopstuk_screen.dart';
import '../screens/master/audit_screen.dart';

/// GoRouter configuration covering all 33 routes matching website
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profil',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/notifikasi',
      builder: (context, state) => const NotifikasiScreen(),
    ),

    // Simpan Pinjam (USIPA)
    GoRoute(
      path: '/pengajuan',
      builder: (context, state) => const PengajuanPinjamanScreen(),
    ),
    GoRoute(
      path: '/pinjaman',
      builder: (context, state) => const RiwayatPinjamanScreen(),
    ),
    GoRoute(
      path: '/simpanan',
      builder: (context, state) => const SimpananScreen(),
    ),
    GoRoute(
      path: '/pencairan',
      builder: (context, state) => const PencairanScreen(),
    ),
    GoRoute(
      path: '/angsuran',
      builder: (context, state) => const AngsuranScreen(),
    ),
    GoRoute(
      path: '/gaji',
      builder: (context, state) => const GajiScreen(),
    ),

    // Approval & Otorisasi Militer
    GoRoute(
      path: '/verifikasi',
      builder: (context, state) => const VerifikasiScreen(),
    ),
    GoRoute(
      path: '/rekomendasi',
      builder: (context, state) => const RekomendasiScreen(),
    ),
    GoRoute(
      path: '/acc',
      builder: (context, state) => const AccScreen(),
    ),
    GoRoute(
      path: '/audit-flow',
      builder: (context, state) => const AuditFlowScreen(),
    ),

    // Unit Toko & Usaha
    GoRoute(
      path: '/katalog-belanja',
      builder: (context, state) => const KatalogBelanjaScreen(),
    ),
    GoRoute(
      path: '/keranjang',
      builder: (context, state) => const KeranjangScreen(),
    ),
    GoRoute(
      path: '/pos',
      builder: (context, state) => const PosKasirScreen(),
    ),
    GoRoute(
      path: '/inventori',
      builder: (context, state) => const InventoriScreen(),
    ),
    GoRoute(
      path: '/pesanan-antar',
      builder: (context, state) => const PesananAntarScreen(),
    ),
    GoRoute(
      path: '/supplier',
      builder: (context, state) => const SupplierScreen(),
    ),
    GoRoute(
      path: '/marketplace-anggota',
      builder: (context, state) => const MarketplaceAnggotaScreen(),
    ),
    GoRoute(
      path: '/gadai',
      builder: (context, state) => const GadaiScreen(),
    ),
    GoRoute(
      path: '/poin-undian',
      builder: (context, state) => const PoinUndianScreen(),
    ),
    GoRoute(
      path: '/toko-transaksi',
      builder: (context, state) => const TokoTransaksiScreen(),
    ),
    GoRoute(
      path: '/laporan-toko',
      builder: (context, state) => const LaporanTokoScreen(),
    ),

    // Keuangan & Pengawasan
    GoRoute(
      path: '/likuiditas',
      builder: (context, state) => const LikuiditasScreen(),
    ),
    GoRoute(
      path: '/shu',
      builder: (context, state) => const ShuScreen(),
    ),
    GoRoute(
      path: '/laporan',
      builder: (context, state) => const LaporanScreen(),
    ),
    GoRoute(
      path: '/transaksi',
      builder: (context, state) => const TransaksiScreen(),
    ),

    // Master Data & Pengaturan
    GoRoute(
      path: '/users',
      builder: (context, state) => const UsersScreen(),
    ),
    GoRoute(
      path: '/anggota',
      builder: (context, state) => const AnggotaScreen(),
    ),
    GoRoute(
      path: '/master-data',
      builder: (context, state) => const MasterDataScreen(),
    ),
    GoRoute(
      path: '/kopstuk',
      builder: (context, state) => const KopstukScreen(),
    ),
    GoRoute(
      path: '/audit',
      builder: (context, state) => const AuditScreen(),
    ),
  ],
);
