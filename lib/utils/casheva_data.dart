import 'package:flutter/material.dart';
import '../models/user.dart';

/// Comprehensive business logic utility — ported 1:1 from website casheva-data.ts
/// Contains: role mappings, status mappings, loan status colors,
/// demo data (loans, queues, gaji, SHU rows), and chart data.
class CashevaData {
  CashevaData._();

  // ═══════════════════════════════════════════════════════════════════════
  // ROLE MAPPINGS (backendRoleToFrontend / frontendRoleToBackend)
  // ═══════════════════════════════════════════════════════════════════════

  /// Map backend role enum string to frontend Role enum
  static Role backendRoleToFrontend(String? backendRole) {
    switch (backendRole?.toUpperCase()) {
      case 'ADMIN_KOPERASI':
        return Role.adminKoperasi;
      case 'PIMPINAN':
        return Role.pimpinan;
      case 'KEPRIM':
      case 'KAPRIM':
        return Role.keprim;
      case 'BENDAHARA':
        return Role.bendahara;
      case 'PENGAWAS':
        return Role.pengawas;
      case 'JURU_BAYAR':
        return Role.juruBayar;
      case 'KASIR_TOKO':
        return Role.kasirToko;
      case 'ANGGOTA':
        return Role.anggota;
      default:
        return Role.adminKoperasi;
    }
  }

  /// Map frontend Role enum to backend role string
  static String frontendRoleToBackend(Role role) {
    switch (role) {
      case Role.adminKoperasi:
        return 'ADMIN_KOPERASI';
      case Role.pimpinan:
        return 'PIMPINAN';
      case Role.keprim:
        return 'KEPRIM';
      case Role.bendahara:
        return 'BENDAHARA';
      case Role.pengawas:
        return 'PENGAWAS';
      case Role.juruBayar:
        return 'JURU_BAYAR';
      case Role.kasirToko:
        return 'KASIR_TOKO';
      case Role.anggota:
        return 'ANGGOTA';
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // LOAN STATUS MAPPINGS (backendStatusToFrontend)
  // ═══════════════════════════════════════════════════════════════════════

  /// Semua status pinjaman yang mungkin
  static const List<String> allLoanStatuses = [
    'Pending',
    'Verified Primkop',
    'Verified Jurbay',
    'Approved Dan',
    'ACC Keprim',
    'Upload Berkas',
    'Disbursed',
    'Rejected',
    'Lunas',
  ];

  /// Map backend status to frontend display string
  static String backendStatusToFrontend(String? backendStatus) {
    switch (backendStatus?.toUpperCase()) {
      case 'DIAJUKAN':
        return 'Pending';
      case 'VERIFIKASI_PRIMKOP':
        return 'Verified Primkop';
      case 'VERIFIKASI_JURU_BAYAR':
        return 'Verified Jurbay';
      case 'REKOMENDASI_PIMPINAN':
        return 'Approved Dan';
      case 'SETUJU_KEPRIM':
      case 'SETUJU_KAPRIM':
        return 'ACC Keprim';
      case 'MENUNGGU_DOKUMEN':
        return 'Upload Berkas';
      case 'DICAIRKAN':
        return 'Disbursed';
      case 'LUNAS':
        return 'Lunas';
      case 'DITOLAK':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  /// Map frontend status to backend status string
  static String frontendStatusToBackend(String frontendStatus) {
    switch (frontendStatus) {
      case 'Pending':
        return 'DIAJUKAN';
      case 'Verified Primkop':
        return 'VERIFIKASI_PRIMKOP';
      case 'Verified Jurbay':
        return 'VERIFIKASI_JURU_BAYAR';
      case 'Approved Dan':
        return 'REKOMENDASI_PIMPINAN';
      case 'ACC Keprim':
        return 'SETUJU_KEPRIM';
      case 'Upload Berkas':
        return 'MENUNGGU_DOKUMEN';
      case 'Disbursed':
        return 'DICAIRKAN';
      case 'Lunas':
        return 'LUNAS';
      case 'Rejected':
        return 'DITOLAK';
      default:
        return 'DIAJUKAN';
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // LOAN STATUS COLORS / TONE (loanStatusTone — ported from CSS classes)
  // ═══════════════════════════════════════════════════════════════════════

  /// Get color pair (background, foreground) for loan status badge
  static ({Color background, Color foreground}) loanStatusTone(String status) {
    switch (status) {
      case 'Pending':
        return (background: const Color(0xFFF1F5F1), foreground: const Color(0xFF6B7B6B));
      case 'Verified Primkop':
        return (background: const Color(0xFFE8F5E9), foreground: const Color(0xFF1B5E20));
      case 'Verified Jurbay':
        return (background: const Color(0xFFFFF3E0), foreground: const Color(0xFF5D4037));
      case 'Approved Dan':
        return (background: const Color(0xFFFFF8E1), foreground: const Color(0xFF5D4037));
      case 'ACC Keprim':
        return (background: const Color(0xFFE8F5E9), foreground: const Color(0xFF1B5E20));
      case 'Upload Berkas':
        return (background: const Color(0xFFFFF3E0).withValues(alpha: 0.4), foreground: const Color(0xFF1A2E1A));
      case 'Disbursed':
        return (background: const Color(0xFF2E7D32).withValues(alpha: 0.15), foreground: const Color(0xFF2E7D32));
      case 'Rejected':
        return (background: const Color(0xFFD32F2F).withValues(alpha: 0.12), foreground: const Color(0xFFD32F2F));
      case 'Lunas':
        return (background: const Color(0xFF2E7D32).withValues(alpha: 0.20), foreground: const Color(0xFF2E7D32));
      default:
        return (background: const Color(0xFFF1F5F1), foreground: const Color(0xFF6B7B6B));
    }
  }

  /// Get status icon for loan
  static IconData loanStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.hourglass_empty_rounded;
      case 'Verified Primkop':
      case 'Verified Jurbay':
        return Icons.verified_user_rounded;
      case 'Approved Dan':
        return Icons.fact_check_rounded;
      case 'ACC Keprim':
        return Icons.task_alt_rounded;
      case 'Upload Berkas':
        return Icons.upload_file_rounded;
      case 'Disbursed':
        return Icons.account_balance_rounded;
      case 'Rejected':
        return Icons.cancel_rounded;
      case 'Lunas':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // DEMO DATA — RECENT LOANS (recentLoans)
  // ═══════════════════════════════════════════════════════════════════════

  static final List<Map<String, dynamic>> recentLoans = [
    {'id': 'PJM-2026-0184', 'nama': 'Serma Budi Santoso', 'nrp': '21980045', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'jumlah': 15000000, 'tenor': 24, 'status': 'ACC Keprim', 'tanggal': '02 Agu 2026'},
    {'id': 'PJM-2026-0183', 'nama': 'Kapten Inf Rahmat Hidayat', 'nrp': '11060078', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'jumlah': 20000000, 'tenor': 36, 'status': 'Approved Dan', 'tanggal': '02 Agu 2026'},
    {'id': 'PJM-2026-0182', 'nama': 'Pelda Agus Wibowo', 'nrp': '21930112', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'jumlah': 8000000, 'tenor': 18, 'status': 'Verified Jurbay', 'tanggal': '01 Agu 2026'},
    {'id': 'PJM-2026-0181', 'nama': 'PNS Sri Wahyuni', 'nrp': '198504112009', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'jumlah': 5000000, 'tenor': 12, 'status': 'Pending', 'tanggal': '01 Agu 2026'},
    {'id': 'PJM-2026-0180', 'nama': 'Letkol Cba Dedi Kurnia', 'nrp': '11020033', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'jumlah': 18000000, 'tenor': 30, 'status': 'Disbursed', 'tanggal': '31 Jul 2026'},
    {'id': 'PJM-2026-0179', 'nama': 'Sertu Hendra Gunawan', 'nrp': '31770091', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'jumlah': 6000000, 'tenor': 12, 'status': 'Rejected', 'tanggal': '30 Jul 2026'},
    {'id': 'PJM-2026-0178', 'nama': 'Mayor Kav Fajar Nugroho', 'nrp': '11150221', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'jumlah': 12000000, 'tenor': 24, 'status': 'Pending', 'tanggal': '29 Jul 2026'},
  ];

  /// Hitung jumlah pinjaman per kategori status
  static ({int proses, int disetujui, int ditolak}) getLoanStatusCounts([
    List<Map<String, dynamic>>? loans,
  ]) {
    final data = loans ?? recentLoans;
    const prosesStatuses = ['Pending', 'Verified Jurbay', 'Approved Dan'];
    const accStatuses = ['ACC Keprim', 'Disbursed'];
    return (
      proses: data.where((l) => prosesStatuses.contains(l['status'])).length,
      disetujui: data.where((l) => accStatuses.contains(l['status'])).length,
      ditolak: data.where((l) => l['status'] == 'Rejected').length,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // DEMO DATA — ANTREAN JURU BAYAR (antreanJuyar)
  // ═══════════════════════════════════════════════════════════════════════

  static final List<Map<String, dynamic>> antreanJuyar = [
    {'id': 'PJM-2026-0187', 'nama': 'Sertu Hendra Gunawan', 'pangkat': 'Sertu Inf', 'nrp': '31770091', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'plafon': 6000000, 'tenor': 12, 'gaji': 5400000, 'tunkin': 2100000, 'potongan': 1450000, 'sisaGaji': 6050000, 'layak': true, 'catatan': 'Sisa gaji memenuhi ketentuan minimal'},
    {'id': 'PJM-2026-0181', 'nama': 'Penata Muda Sri Wahyuni', 'pangkat': 'Penata Muda', 'nrp': '198504112009', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'plafon': 5000000, 'tenor': 12, 'gaji': 4800000, 'tunkin': 900000, 'potongan': 2200000, 'sisaGaji': 3500000, 'layak': true, 'catatan': 'Dokumen lengkap, potongan masih dalam batas aman'},
    {'id': 'PJM-2026-0178', 'nama': 'Mayor Kav Fajar Nugroho', 'pangkat': 'Mayor Kav', 'nrp': '11150221', 'satminkal': 'INFOLAHTADAM IV/DIPONEGORO', 'plafon': 12000000, 'tenor': 24, 'gaji': 9100000, 'tunkin': 4800000, 'potongan': 5200000, 'sisaGaji': 8700000, 'layak': false, 'catatan': 'Rasio angsuran terhadap sisa gaji di atas ambang 40%'},
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // DEMO DATA — GAJI ANGGOTA (anggotaGajiProfile)
  // ═══════════════════════════════════════════════════════════════════════

  static final Map<String, dynamic> anggotaGajiProfile = {
    'nama': 'Hendra Gunawan',
    'nrp': '31770091',
    'pangkat': 'Sertu',
    'korps': '',
    'kategori': 'BINTARA',
    'satminkal': 'INFOLAHTADAM IV/DIPONEGORO',
    'gajiPokok': 5400000,
    'tunkin': 2100000,
    'tunjanganLain': 350000,
    'potongan': [
      {'nama': 'Simpanan Wajib', 'jumlah': 150000},
      {'nama': 'Simpanan Sukarela', 'jumlah': 150000},
      {'nama': 'Angsuran Pinjaman PJM-2026-0175', 'jumlah': 625000},
      {'nama': 'Cicilan Belanja Toko (Kredit POS)', 'jumlah': 185000},
      {'nama': 'Iuran Koperasi', 'jumlah': 25000},
      {'nama': 'Asuransi', 'jumlah': 500000},
    ],
  };

  // ═══════════════════════════════════════════════════════════════════════
  // DEMO DATA — ANGSURAN ANGGOTA (anggotaAngsuranSaya)
  // ═══════════════════════════════════════════════════════════════════════

  static final List<Map<String, dynamic>> anggotaAngsuranSaya = [
    {'id': 'PJM-2026-0175', 'jenis': 'USIPA (Uang)', 'pokok': 7500000, 'angsuranKe': 5, 'totalAngsuran': 18, 'angsuranBulanan': 625000, 'sisa': 8125000, 'status': 'Lancar'},
    {'id': 'KRD-2026-0042', 'jenis': 'Kredit Toko (Barang)', 'pokok': 555000, 'angsuranKe': 1, 'totalAngsuran': 3, 'angsuranBulanan': 185000, 'sisa': 370000, 'status': 'Lancar'},
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // CHART DATA (identik website casheva-data.ts)
  // ═══════════════════════════════════════════════════════════════════════

  static final List<Map<String, dynamic>> trenData = [
    {'bulan': 'Jan', 'simpanan': 820, 'pinjaman': 540},
    {'bulan': 'Feb', 'simpanan': 880, 'pinjaman': 610},
    {'bulan': 'Mar', 'simpanan': 940, 'pinjaman': 700},
    {'bulan': 'Apr', 'simpanan': 1010, 'pinjaman': 665},
    {'bulan': 'Mei', 'simpanan': 1090, 'pinjaman': 780},
    {'bulan': 'Jun', 'simpanan': 1180, 'pinjaman': 820},
    {'bulan': 'Jul', 'simpanan': 1265, 'pinjaman': 905},
    {'bulan': 'Agu', 'simpanan': 1340, 'pinjaman': 940},
    {'bulan': 'Sep', 'simpanan': 1420, 'pinjaman': 1010},
    {'bulan': 'Okt', 'simpanan': 1505, 'pinjaman': 1080},
    {'bulan': 'Nov', 'simpanan': 1590, 'pinjaman': 1120},
    {'bulan': 'Des', 'simpanan': 1690, 'pinjaman': 1195},
  ];

  static final List<Map<String, dynamic>> angsuranData = [
    {'bulan': 'Jan', 'target': 320, 'realisasi': 298},
    {'bulan': 'Feb', 'target': 325, 'realisasi': 315},
    {'bulan': 'Mar', 'target': 330, 'realisasi': 322},
    {'bulan': 'Apr', 'target': 340, 'realisasi': 305},
    {'bulan': 'Mei', 'target': 352, 'realisasi': 344},
    {'bulan': 'Jun', 'target': 360, 'realisasi': 358},
    {'bulan': 'Jul', 'target': 371, 'realisasi': 349},
    {'bulan': 'Agu', 'target': 380, 'realisasi': 366},
  ];

  static final List<Map<String, dynamic>> pengajuanSatuanData = [
    {'bulan': 'Mar', 'pengajuan': 12, 'disetujui': 9},
    {'bulan': 'Apr', 'pengajuan': 15, 'disetujui': 12},
    {'bulan': 'Mei', 'pengajuan': 11, 'disetujui': 10},
    {'bulan': 'Jun', 'pengajuan': 18, 'disetujui': 14},
    {'bulan': 'Jul', 'pengajuan': 21, 'disetujui': 17},
    {'bulan': 'Agu', 'pengajuan': 16, 'disetujui': 11},
  ];

  static final List<Map<String, dynamic>> likuiditasData = [
    {'bulan': 'Mar', 'kas': 4200, 'pencairan': 980},
    {'bulan': 'Apr', 'kas': 4380, 'pencairan': 1120},
    {'bulan': 'Mei', 'kas': 4510, 'pencairan': 1040},
    {'bulan': 'Jun', 'kas': 4290, 'pencairan': 1380},
    {'bulan': 'Jul', 'kas': 4620, 'pencairan': 1210},
    {'bulan': 'Agu', 'kas': 4805, 'pencairan': 1150},
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // SHU DATA (shuRows — demo)
  // ═══════════════════════════════════════════════════════════════════════

  static final List<Map<String, dynamic>> shuRows = [
    {'nrp': '11020033', 'nama': 'Letkol Cba Dedi Kurnia', 'modal': 17300000, 'transaksi': 24500000},
    {'nrp': '11060078', 'nama': 'Kapten Inf Rahmat Hidayat', 'modal': 10850000, 'transaksi': 18200000},
    {'nrp': '21980045', 'nama': 'Serma Budi Santoso', 'modal': 6500000, 'transaksi': 9400000},
    {'nrp': '21930112', 'nama': 'Pelda Agus Wibowo', 'modal': 8000000, 'transaksi': 11200000},
    {'nrp': '198504112009', 'nama': 'Penata Muda Sri Wahyuni', 'modal': 4700000, 'transaksi': 6100000},
    {'nrp': '11150221', 'nama': 'Mayor Kav Fajar Nugroho', 'modal': 14000000, 'transaksi': 15800000},
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // UTILITY: Workflow step index (for approval timeline)
  // ═══════════════════════════════════════════════════════════════════════

  /// Get the step index for a given loan status in the workflow
  static int getWorkflowStepIndex(String status) {
    switch (status) {
      case 'Pending':
        return 0;
      case 'Verified Primkop':
      case 'Verified Jurbay':
        return 1;
      case 'Approved Dan':
        return 2;
      case 'ACC Keprim':
        return 3;
      case 'Upload Berkas':
        return 4;
      case 'Disbursed':
      case 'Lunas':
        return 5;
      case 'Rejected':
        return -1;
      default:
        return 0;
    }
  }

  /// Check if a loan status is in "approved/positive" state
  static bool isPositiveStatus(String status) {
    return ['ACC Keprim', 'Disbursed', 'Lunas'].contains(status);
  }

  /// Check if a loan status is "in process"
  static bool isProcessingStatus(String status) {
    return ['Pending', 'Verified Primkop', 'Verified Jurbay', 'Approved Dan', 'Upload Berkas'].contains(status);
  }
}
