import 'package:flutter/material.dart';
import '../models/user.dart';

/// Navigation item definition
class NavItem {
  final String title;
  final String route;
  final IconData icon;
  final String? badge;

  const NavItem({
    required this.title,
    required this.route,
    required this.icon,
    this.badge,
  });
}

/// Grouped Navigation Section
class NavGroup {
  final String groupTitle;
  final List<NavItem> items;

  const NavGroup({
    required this.groupTitle,
    required this.items,
  });
}

/// Role-based access control and navigation rules
class RbacHelper {
  RbacHelper._();

  static const Set<String> sharedPaths = {'/', '/login', '/profil', '/notifikasi'};

  /// Extra paths granted beyond drawer navigation
  static const Map<Role, List<String>> extraAccess = {
    Role.adminKoperasi: [
      '/users',
      '/master-data',
      '/kopstuk',
      '/audit',
      '/rekomendasi',
      '/anggota',
      '/pinjaman',
      '/acc',
      '/likuiditas',
      '/laporan',
      '/verifikasi',
      '/simpanan',
      '/pencairan',
      '/angsuran',
      '/pengajuan',
      '/gaji',
      '/shu',
      '/audit-flow',
      '/transaksi',
      '/toko-transaksi',
      '/pos',
      '/inventori',
      '/supplier',
      '/pesanan-antar',
      '/marketplace-anggota',
      '/gadai',
      '/poin-undian',
      '/laporan-toko',
      '/katalog-belanja',
      '/keranjang',
    ],
    Role.keprim: [
      '/rekomendasi',
      '/acc',
      '/likuiditas',
      '/laporan',
      '/pinjaman',
      '/anggota',
      '/transaksi',
      '/laporan-toko',
      '/katalog-belanja',
    ],
    Role.bendahara: [
      '/pengajuan',
      '/simpanan',
      '/pencairan',
      '/angsuran',
      '/rekomendasi',
      '/transaksi',
      '/laporan-toko',
      '/laporan',
      '/katalog-belanja',
    ],
    Role.juruBayar: [
      '/verifikasi',
      '/pencairan',
      '/angsuran',
      '/transaksi',
      '/katalog-belanja',
    ],
    Role.anggota: [
      '/gaji',
      '/pengajuan',
      '/angsuran',
      '/simpanan',
      '/katalog-belanja',
      '/pesanan-antar',
      '/poin-undian',
      '/marketplace-anggota',
      '/gadai',
      '/keranjang',
    ],
    Role.pimpinan: [
      '/rekomendasi',
      '/anggota',
      '/pinjaman',
      '/transaksi',
      '/katalog-belanja',
    ],
    Role.kasirToko: [
      '/pos',
      '/inventori',
      '/pesanan-antar',
      '/toko-transaksi',
      '/transaksi',
      '/poin-undian',
      '/gadai',
      '/laporan-toko',
      '/katalog-belanja',
    ],
    Role.pengawas: [
      '/shu',
      '/audit-flow',
      '/laporan',
      '/transaksi',
      '/laporan-toko',
      '/katalog-belanja',
    ],
  };

  /// Grouped Navigation per Role (matching website role-nav.ts exactly)
  static Map<Role, List<NavGroup>> get roleNavGrouped => {
    Role.adminKoperasi: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Simpan Pinjam (USIPA)',
        items: [
          NavItem(title: 'Pengajuan Pinjaman', route: '/pengajuan', icon: Icons.note_add_rounded),
          NavItem(title: 'Simpanan Anggota', route: '/simpanan', icon: Icons.savings_rounded),
          NavItem(title: 'Pencairan & Invoice', route: '/pencairan', icon: Icons.receipt_long_rounded),
          NavItem(title: 'Rekap Angsuran', route: '/angsuran', icon: Icons.checklist_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Unit Toko & Usaha',
        items: [
          NavItem(title: 'Kasir POS Toko', route: '/pos', icon: Icons.point_of_sale_rounded),
          NavItem(title: 'Katalog & Stok Barang', route: '/inventori', icon: Icons.inventory_2_rounded),
          NavItem(title: 'Supplier & Pengadaan', route: '/supplier', icon: Icons.local_shipping_rounded),
          NavItem(title: 'Pesanan Antar & Piket', route: '/pesanan-antar', icon: Icons.access_time_rounded),
          NavItem(title: 'Marketplace Anggota', route: '/marketplace-anggota', icon: Icons.store_rounded),
          NavItem(title: 'Unit Gadai & Lelang', route: '/gadai', icon: Icons.diamond_rounded),
          NavItem(title: 'Poin & Undian RAT', route: '/poin-undian', icon: Icons.card_giftcard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Rekap Transaksi',
        items: [
          NavItem(title: 'Semua Transaksi', route: '/transaksi', icon: Icons.swap_horiz_rounded),
          NavItem(title: 'Riwayat Transaksi Toko', route: '/toko-transaksi', icon: Icons.shopping_bag_rounded),
          NavItem(title: 'Laporan Keuangan Toko', route: '/laporan-toko', icon: Icons.assessment_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Approval & Pengawasan',
        items: [
          NavItem(title: 'Antrean Verifikasi (Jurbay)', route: '/verifikasi', icon: Icons.verified_user_rounded),
          NavItem(title: 'Antrean Rekomendasi (Dan/Ka)', route: '/rekomendasi', icon: Icons.fact_check_rounded),
          NavItem(title: 'Persetujuan ACC (Keprim)', route: '/acc', icon: Icons.task_alt_rounded),
          NavItem(title: 'Likuiditas Kas', route: '/likuiditas', icon: Icons.account_balance_wallet_rounded),
          NavItem(title: 'Pengawasan SHU', route: '/shu', icon: Icons.calculate_rounded),
          NavItem(title: 'Laporan Keuangan', route: '/laporan', icon: Icons.bar_chart_rounded),
          NavItem(title: 'Audit Flow Approval', route: '/audit-flow', icon: Icons.account_tree_rounded),
          NavItem(title: 'Audit Logs', route: '/audit', icon: Icons.history_edu_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Master & Pengaturan',
        items: [
          NavItem(title: 'Manajemen User & Anggota', route: '/users', icon: Icons.manage_accounts_rounded),
          NavItem(title: 'Data Anggota Koperasi', route: '/anggota', icon: Icons.groups_rounded),
          NavItem(title: 'Master Data TNI AD', route: '/master-data', icon: Icons.storage_rounded),
          NavItem(title: 'Kopstuk & TTD', route: '/kopstuk', icon: Icons.approval_rounded),
        ],
      ),
    ],

    Role.kasirToko: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard Kasir', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Unit Toko & Kasir',
        items: [
          NavItem(title: 'Kasir POS Toko', route: '/pos', icon: Icons.point_of_sale_rounded),
          NavItem(title: 'Katalog & Stok Barang', route: '/inventori', icon: Icons.inventory_2_rounded),
          NavItem(title: 'Pesanan Antar & Piket', route: '/pesanan-antar', icon: Icons.access_time_rounded),
          NavItem(title: 'Poin & Undian RAT', route: '/poin-undian', icon: Icons.card_giftcard_rounded),
          NavItem(title: 'Unit Gadai & Lelang', route: '/gadai', icon: Icons.diamond_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Transaksi & Laporan',
        items: [
          NavItem(title: 'Semua Transaksi', route: '/transaksi', icon: Icons.swap_horiz_rounded),
          NavItem(title: 'Riwayat Transaksi Toko', route: '/toko-transaksi', icon: Icons.shopping_bag_rounded),
          NavItem(title: 'Laporan Penjualan Toko', route: '/laporan-toko', icon: Icons.assessment_rounded),
        ],
      ),
    ],

    Role.pimpinan: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard Komando', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Approval & Personel',
        items: [
          NavItem(title: 'Antrean Rekomendasi', route: '/rekomendasi', icon: Icons.fact_check_rounded),
          NavItem(title: 'Data Anggota Satuan', route: '/anggota', icon: Icons.groups_rounded),
          NavItem(title: 'Riwayat Pinjaman Satuan', route: '/pinjaman', icon: Icons.history_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Transaksi & Belanja',
        items: [
          NavItem(title: 'Semua Transaksi', route: '/transaksi', icon: Icons.swap_horiz_rounded),
          NavItem(title: 'Katalog Belanja Toko', route: '/katalog-belanja', icon: Icons.shopping_bag_rounded),
        ],
      ),
    ],

    Role.keprim: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard Keprim', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Approval Otorisasi',
        items: [
          NavItem(title: 'Antrean Rekomendasi', route: '/rekomendasi', icon: Icons.fact_check_rounded),
          NavItem(title: 'Persetujuan Akhir (ACC)', route: '/acc', icon: Icons.task_alt_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Transaksi & Keuangan',
        items: [
          NavItem(title: 'Semua Transaksi', route: '/transaksi', icon: Icons.swap_horiz_rounded),
          NavItem(title: 'Likuiditas Kas', route: '/likuiditas', icon: Icons.account_balance_wallet_rounded),
          NavItem(title: 'Laporan Keuangan Toko', route: '/laporan-toko', icon: Icons.assessment_rounded),
          NavItem(title: 'Laporan Keuangan', route: '/laporan', icon: Icons.bar_chart_rounded),
        ],
      ),
    ],

    Role.bendahara: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard Bendahara', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Simpan Pinjam (USIPA)',
        items: [
          NavItem(title: 'Pengajuan Pinjaman', route: '/pengajuan', icon: Icons.note_add_rounded),
          NavItem(title: 'Antrean Rekomendasi', route: '/rekomendasi', icon: Icons.fact_check_rounded),
          NavItem(title: 'Simpanan Anggota', route: '/simpanan', icon: Icons.savings_rounded),
          NavItem(title: 'Pencairan & Invoice', route: '/pencairan', icon: Icons.receipt_long_rounded),
          NavItem(title: 'Rekap Angsuran', route: '/angsuran', icon: Icons.checklist_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Rekap Transaksi & Laporan',
        items: [
          NavItem(title: 'Semua Transaksi', route: '/transaksi', icon: Icons.swap_horiz_rounded),
          NavItem(title: 'Laporan Keuangan Toko', route: '/laporan-toko', icon: Icons.assessment_rounded),
          NavItem(title: 'Laporan Keuangan Koperasi', route: '/laporan', icon: Icons.bar_chart_rounded),
        ],
      ),
    ],

    Role.juruBayar: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard Juru Bayar', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Verifikasi & Pembayaran',
        items: [
          NavItem(title: 'Antrean Verifikasi', route: '/verifikasi', icon: Icons.verified_user_rounded),
          NavItem(title: 'Pencairan & Invoice', route: '/pencairan', icon: Icons.receipt_long_rounded),
          NavItem(title: 'Rekap Angsuran', route: '/angsuran', icon: Icons.checklist_rounded),
          NavItem(title: 'Semua Transaksi', route: '/transaksi', icon: Icons.swap_horiz_rounded),
        ],
      ),
    ],

    Role.anggota: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard Anggota', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Simpan Pinjam Saya',
        items: [
          NavItem(title: 'Pengajuan USIPA', route: '/pengajuan', icon: Icons.note_add_rounded),
          NavItem(title: 'Simpanan Saya', route: '/simpanan', icon: Icons.savings_rounded),
          NavItem(title: 'Riwayat Angsuran Saya', route: '/angsuran', icon: Icons.checklist_rounded),
          NavItem(title: 'Rincian Gaji & Potongan', route: '/gaji', icon: Icons.payments_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Toko & Layanan',
        items: [
          NavItem(title: 'Katalog Belanja Toko', route: '/katalog-belanja', icon: Icons.shopping_bag_rounded),
          NavItem(title: 'Pesanan Saya & Piket', route: '/pesanan-antar', icon: Icons.access_time_rounded),
          NavItem(title: 'Poin & Undian RAT', route: '/poin-undian', icon: Icons.card_giftcard_rounded),
          NavItem(title: 'Marketplace UMKM', route: '/marketplace-anggota', icon: Icons.store_rounded),
          NavItem(title: 'Layanan Gadai & Lelang', route: '/gadai', icon: Icons.diamond_rounded),
        ],
      ),
    ],

    Role.pengawas: [
      const NavGroup(
        groupTitle: 'Utama',
        items: [
          NavItem(title: 'Dashboard Pengawas', route: '/', icon: Icons.dashboard_rounded),
        ],
      ),
      const NavGroup(
        groupTitle: 'Pengawasan & Audit',
        items: [
          NavItem(title: 'Pengawasan SHU', route: '/shu', icon: Icons.calculate_rounded),
          NavItem(title: 'Semua Transaksi', route: '/transaksi', icon: Icons.swap_horiz_rounded),
          NavItem(title: 'Laporan Keuangan Toko', route: '/laporan-toko', icon: Icons.assessment_rounded),
          NavItem(title: 'Laporan Pendapatan & Biaya', route: '/laporan', icon: Icons.monetization_on_rounded),
          NavItem(title: 'Audit Flow Approval', route: '/audit-flow', icon: Icons.account_tree_rounded),
        ],
      ),
    ],
  };

  /// Flat list of nav items for a role
  static List<NavItem> navItemsFor(Role role) {
    final groups = roleNavGrouped[role] ?? [];
    return groups.expand((g) => g.items).toList();
  }

  /// Check if a role can access a specific route
  static bool canAccess(Role role, String route, [Role? originalRole]) {
    if (sharedPaths.contains(route)) return true;
    if (role == Role.adminKoperasi || originalRole == Role.adminKoperasi) return true;

    final effective = originalRole ?? role;
    final allowedRoutes = {
      ...sharedPaths,
      ...navItemsFor(effective).map((i) => i.route),
      ...(extraAccess[effective] ?? []),
    };

    return allowedRoutes.contains(route);
  }

  /// Primary CTA on dashboard per role
  static ({String route, String label})? getDashboardCta(Role role) {
    switch (role) {
      case Role.juruBayar:
        return (route: '/verifikasi', label: 'Buka Antrean Verifikasi');
      case Role.pimpinan:
        return (route: '/rekomendasi', label: 'Buka Antrean Rekomendasi');
      case Role.keprim:
        return (route: '/acc', label: 'Buka Persetujuan ACC');
      case Role.bendahara:
        return (route: '/pengajuan', label: 'Ajukan Pinjaman');
      case Role.anggota:
        return (route: '/gaji', label: 'Lihat Rincian Gaji');
      case Role.adminKoperasi:
        return (route: '/users', label: 'Kelola Pengguna');
      case Role.pengawas:
        return (route: '/shu', label: 'Buka Pengawasan SHU');
      case Role.kasirToko:
        return (route: '/pos', label: 'Buka Kasir POS');
    }
  }
}
