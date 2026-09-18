import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/app_theme.dart';
import '../../providers/pinjaman_provider.dart';
import '../../providers/simpanan_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/military_badge.dart';

/// Dashboard Khusus Admin Koperasi
class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();
    final simpanan = context.watch<SimpananProvider>();

    final totalSimp = simpanan.totalSimpananSemua > 0 ? simpanan.totalSimpananSemua : 1420000000.0;
    final totalPinj = 940000000.0;
    final kasKoperasi = 480500000.0;
    final shuBerjalan = 185000000.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Selamat Datang
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A2F), Color(0xFF2D5A43)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
                          'PUSAT KENDALI ADMINISTRATOR',
                          style: TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Komando Koperasi Casheva',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pusat monitoring USIPA, Toko POS, Likuiditas Kas, & Otorisasi Personel.',
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
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4 Kartu Metrik Utama
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              StatCard(
                title: 'Total Simpanan',
                value: CurrencyFormatter.formatRp(totalSimp),
                icon: Icons.savings_rounded,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
                trendPill: '+8.4%',
                isPositiveTrend: true,
                onTap: () => context.push('/simpanan'),
              ),
              StatCard(
                title: 'Pinjaman Beredar',
                value: CurrencyFormatter.formatRp(totalPinj),
                icon: Icons.receipt_long_rounded,
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4338CA),
                trendPill: '+5.2%',
                isPositiveTrend: true,
                onTap: () => context.push('/pinjaman'),
              ),
              StatCard(
                title: 'Likuiditas Kas',
                value: CurrencyFormatter.formatRp(kasKoperasi),
                icon: Icons.account_balance_wallet_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
                subtitle: 'Rasio Likuiditas Sehat',
                onTap: () => context.push('/likuiditas'),
              ),
              StatCard(
                title: 'Estimasi SHU 2026',
                value: CurrencyFormatter.formatRp(shuBerjalan),
                icon: Icons.calculate_rounded,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7E22CE),
                subtitle: 'Alokasi 7 Pos Resmi',
                onTap: () => context.push('/shu'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Shortcut Aksi Cepat
          const Text(
            'Aksi Cepat & Menu Operasional',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickAction(
                  context,
                  icon: Icons.point_of_sale_rounded,
                  label: 'Kasir POS',
                  color: AppTheme.primary,
                  onTap: () => context.push('/pos'),
                ),
                _buildQuickAction(
                  context,
                  icon: Icons.verified_user_rounded,
                  label: 'Verifikasi Jurbay',
                  color: const Color(0xFF2563EB),
                  badge: '${pinjaman.jurbayQueue.length}',
                  onTap: () => context.push('/verifikasi'),
                ),
                _buildQuickAction(
                  context,
                  icon: Icons.fact_check_rounded,
                  label: 'Rekomendasi Dan',
                  color: const Color(0xFFD97706),
                  onTap: () => context.push('/rekomendasi'),
                ),
                _buildQuickAction(
                  context,
                  icon: Icons.task_alt_rounded,
                  label: 'ACC Keprim',
                  color: const Color(0xFF059669),
                  onTap: () => context.push('/acc'),
                ),
                _buildQuickAction(
                  context,
                  icon: Icons.receipt_rounded,
                  label: 'Pencairan',
                  color: const Color(0xFF7C3AED),
                  onTap: () => context.push('/pencairan'),
                ),
                _buildQuickAction(
                  context,
                  icon: Icons.manage_accounts_rounded,
                  label: 'Kelola User',
                  color: const Color(0xFFDC2626),
                  onTap: () => context.push('/users'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Grafik Tren Simpanan vs Pinjaman (fl_chart)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tren Simpanan vs Pinjaman (Jt Rp)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        _buildLegendItem('Simpanan', AppTheme.primary),
                        const SizedBox(width: 8),
                        _buildLegendItem('Pinjaman', const Color(0xFFEAB308)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppTheme.border.withValues(alpha: 0.5),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const months = ['Jan', 'Mar', 'Mei', 'Jul', 'Sep', 'Nov'];
                              final idx = value.toInt();
                              if (idx >= 0 && idx < months.length) {
                                return Text(
                                  months[idx],
                                  style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}',
                              style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                            ),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 820),
                            FlSpot(1, 940),
                            FlSpot(2, 1090),
                            FlSpot(3, 1265),
                            FlSpot(4, 1420),
                            FlSpot(5, 1590),
                          ],
                          isCurved: true,
                          color: AppTheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 540),
                            FlSpot(1, 700),
                            FlSpot(2, 780),
                            FlSpot(3, 905),
                            FlSpot(4, 1010),
                            FlSpot(5, 1120),
                          ],
                          isCurved: true,
                          color: const Color(0xFFEAB308),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFFEAB308).withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Pengajuan Pinjaman Terbaru
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pengajuan Pinjaman Terkini',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/pinjaman'),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pinjaman.loans.take(4).length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              final item = pinjaman.loans[idx];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: AppTheme.primary, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.anggota?.nama ?? 'Personel TNI AD',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.nomorPinjaman ?? item.id} • ${CurrencyFormatter.formatRp(item.nominal)} (${item.tenorBulan} Bln)',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LoanStatusBadge(status: item.status),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
