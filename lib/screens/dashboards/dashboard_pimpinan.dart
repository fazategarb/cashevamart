import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/pinjaman_provider.dart';
import '../../widgets/stat_card.dart';

/// Dashboard Komando Khusus Pimpinan / Dan / Ka Satuan
class DashboardPimpinan extends StatelessWidget {
  const DashboardPimpinan({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pinjaman = context.watch<PinjamanProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Komando
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E1C0C), Color(0xFF5C3A1E)],
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
                          'DASHBOARD KOMANDO SATUAN',
                          style: TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        auth.currentUser?.satminkal?.nama ?? 'INFOLAHTADAM IV/DIPONEGORO',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Otorisasi rekomendasi pinjaman personel prajurit & PNS satuan.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.military_tech_rounded, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Metrik Ringkasan Satuan
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              StatCard(
                title: 'Perlu Rekomendasi',
                value: '${pinjaman.rekomendasiQueue.length} Berkas',
                icon: Icons.assignment_late_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
                subtitle: 'Menunggu ACC Pimpinan',
                onTap: () => context.push('/rekomendasi'),
              ),
              StatCard(
                title: 'Total Personel Anggota',
                value: '428 Personel',
                icon: Icons.groups_rounded,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
                subtitle: 'Organik & Terdaftar',
                onTap: () => context.push('/anggota'),
              ),
              StatCard(
                title: 'Realisasi Pinjaman Satuan',
                value: 'Rp 640 Juta',
                icon: Icons.account_balance_wallet_rounded,
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4338CA),
                subtitle: 'Tahun Anggaran 2026',
                onTap: () => context.push('/pinjaman'),
              ),
              StatCard(
                title: 'Tingkat Kelancaran',
                value: '99.4%',
                icon: Icons.verified_rounded,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7E22CE),
                trendPill: 'Disiplin',
                isPositiveTrend: true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Tombol CTA Utama
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.fact_check_rounded, color: Colors.white),
              label: Text(
                'Buka Antrean Rekomendasi (${pinjaman.rekomendasiQueue.length})',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              onPressed: () => context.push('/rekomendasi'),
            ),
          ),
        ],
      ),
    );
  }
}
