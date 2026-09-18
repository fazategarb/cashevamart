import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Log Audit Jejak Digital Aktivitas Sistem
class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      {'user': 'Mayor Cba Arif Setiawan', 'action': 'APPROVE_USER_ROLE', 'detail': 'Mengubah role user USR-007 menjadi Juru Bayar', 'ip': '192.168.1.42', 'waktu': '06 Agu 2026 14:52'},
      {'user': 'Letkol Cba Dedi Kurnia', 'action': 'ACC_LOAN', 'detail': 'Menyetujui ACC Pinjaman PJM-2026-0184 (Rp 15.000.000)', 'ip': '192.168.1.18', 'waktu': '06 Agu 2026 14:20'},
      {'user': 'Pelda Agus Wibowo', 'action': 'VERIFY_SALARY', 'detail': 'Verifikasi kelayakan sisa gaji PJM-2026-0182 (Memenuhi Syarat)', 'ip': '192.168.1.25', 'waktu': '06 Agu 2026 11:15'},
      {'user': 'Serda Yoga Pratama', 'action': 'POS_CHECKOUT', 'detail': 'Transaksi penjualan kasir POS STR-20260806-0048 (Rp 144.000)', 'ip': '192.168.1.10', 'waktu': '06 Agu 2026 10:40'},
      {'user': 'Serma Budi Santoso', 'action': 'PAYROLL_BATCH', 'detail': 'Batch pemotongan sukarela massal bulan Agustus 2026', 'ip': '192.168.1.30', 'waktu': '06 Agu 2026 08:30'},
    ];

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Audit Logs & Jejak Digital'),
      drawer: const AppDrawer(currentRoute: '/audit'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, idx) {
          final l = logs[idx];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.primarySoft, shape: BoxShape.circle),
                  child: const Icon(Icons.history_edu_rounded, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l['user']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                          Text(l['waktu']!, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                        child: Text(l['action']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                      ),
                      const SizedBox(height: 4),
                      Text(l['detail']!, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 2),
                      Text('IP: ${l['ip']}', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
