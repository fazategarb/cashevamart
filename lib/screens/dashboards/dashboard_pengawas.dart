import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/stat_card.dart';

/// Dashboard Khusus Badan Pengawas Koperasi
class DashboardPengawas extends StatelessWidget {
  const DashboardPengawas({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B0764), Color(0xFF581C87)],
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
                          'BADAN PENGAWAS KOPERASI',
                          style: TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Audit Finansial & Pengawasan SHU',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Transparansi pembagian SHU, laporan laba rugi, neraca, & log jejak audit approval.',
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
                  child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 36),
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
                title: 'Alokasi SHU 2026',
                value: 'Rp 185 Juta',
                icon: Icons.pie_chart_rounded,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7E22CE),
                subtitle: '7 Pos Resmi AD/ART',
                onTap: () => context.push('/shu'),
              ),
              StatCard(
                title: 'Kesehatan Neraca',
                value: 'Sangat Sehat',
                icon: Icons.health_and_safety_rounded,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
                trendPill: 'Skor A',
                isPositiveTrend: true,
                onTap: () => context.push('/laporan'),
              ),
              StatCard(
                title: 'Audit Flow Approval',
                value: '100% Tercatat',
                icon: Icons.account_tree_rounded,
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4338CA),
                subtitle: 'Jejak Digital Aman',
                onTap: () => context.push('/audit-flow'),
              ),
              StatCard(
                title: 'Semua Transaksi',
                value: '1,248 TRX',
                icon: Icons.swap_horiz_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
                subtitle: 'Unit USIPA & Toko',
                onTap: () => context.push('/transaksi'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.calculate_rounded, color: Colors.white),
              label: const Text(
                'Buka Pengawasan Alokasi SHU',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              onPressed: () => context.push('/shu'),
            ),
          ),
        ],
      ),
    );
  }
}
