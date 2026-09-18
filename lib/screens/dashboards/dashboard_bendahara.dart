import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/pinjaman_provider.dart';
import '../../providers/simpanan_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/stat_card.dart';

/// Dashboard Khusus Bendahara Koperasi
class DashboardBendahara extends StatelessWidget {
  const DashboardBendahara({super.key});

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();
    final simpanan = context.watch<SimpananProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF334155)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC89D42).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFC89D42), width: 0.8),
                        ),
                        child: const Text(
                          'BENDAHARA KOPERASI',
                          style: TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pencairan Dana & Rekap Simpanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manajemen pencairan invoice, batch potongan sukarela, & rekapitulasi angsuran.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              StatCard(
                title: 'Siap Dicairkan',
                value: '${pinjaman.pencairanQueue.length} Pengajuan',
                icon: Icons.receipt_long_rounded,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
                subtitle: 'ACC Keprim Selesai',
                onTap: () => context.push('/pencairan'),
              ),
              StatCard(
                title: 'Simpanan Masuk',
                value: CurrencyFormatter.formatRp(simpanan.totalSimpananSemua > 0 ? simpanan.totalSimpananSemua : 1420000000.0),
                icon: Icons.savings_rounded,
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4338CA),
                subtitle: 'Total Kas Simpanan',
                onTap: () => context.push('/simpanan'),
              ),
              StatCard(
                title: 'Rekap Angsuran',
                value: 'Rp 380 Juta',
                icon: Icons.checklist_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
                subtitle: 'Bulan Berjalan',
                onTap: () => context.push('/angsuran'),
              ),
              StatCard(
                title: 'Laporan Toko',
                value: 'Rp 64.8 Jt',
                icon: Icons.store_rounded,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7E22CE),
                subtitle: 'Omzet Toko Bulan Ini',
                onTap: () => context.push('/laporan-toko'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.receipt_rounded, color: Colors.white),
                  label: const Text(
                    'Pencairan Dana',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  onPressed: () => context.push('/pencairan'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppTheme.primary),
                  ),
                  icon: const Icon(Icons.note_add_rounded, color: AppTheme.primary),
                  label: const Text(
                    'Ajukan Pinjaman',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary),
                  ),
                  onPressed: () => context.push('/pengajuan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
