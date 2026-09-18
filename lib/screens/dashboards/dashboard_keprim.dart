import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/pinjaman_provider.dart';
import '../../widgets/stat_card.dart';

/// Dashboard Khusus Keprim (Kepala Primkopad)
class DashboardKeprim extends StatelessWidget {
  const DashboardKeprim({super.key});

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF134E4A), Color(0xFF0F766E)],
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
                          'OTORISASI TERTINGGI PRIMKOPAD',
                          style: TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Persetujuan Final (ACC)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Otorisasi persetujuan pencairan dana pinjaman dan pemantauan likuiditas.',
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
                  child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 36),
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
                title: 'Menunggu ACC Keprim',
                value: '${pinjaman.accQueue.length} Berkas',
                icon: Icons.task_alt_rounded,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
                subtitle: 'Siap Disetujui',
                onTap: () => context.push('/acc'),
              ),
              StatCard(
                title: 'Kas Tersedia',
                value: 'Rp 480.5 Jt',
                icon: Icons.account_balance_wallet_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
                subtitle: 'Aman untuk Pencairan',
                onTap: () => context.push('/likuiditas'),
              ),
              StatCard(
                title: 'Antrean Rekomendasi',
                value: '${pinjaman.rekomendasiQueue.length}',
                icon: Icons.fact_check_rounded,
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4338CA),
                subtitle: 'Dari Pimpinan/Dan',
                onTap: () => context.push('/rekomendasi'),
              ),
              StatCard(
                title: 'Laporan Keuangan',
                value: 'Neraca Sehat',
                icon: Icons.bar_chart_rounded,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7E22CE),
                subtitle: 'Periode Berjalan',
                onTap: () => context.push('/laporan'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.badge_rounded, color: Colors.white),
              label: Text(
                'Buka Persetujuan ACC Keprim (${pinjaman.accQueue.length})',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              onPressed: () => context.push('/acc'),
            ),
          ),
        ],
      ),
    );
  }
}
