import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/stat_card.dart';

/// Screen Likuiditas Kas Koperasi & Arus Kas
class LikuiditasScreen extends StatelessWidget {
  const LikuiditasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalKas = 480500000.0;
    const pencairanBulanIni = 115000000.0;
    const angsuranMasuk = 366000000.0;
    const rasioLikuiditas = 417.8; // %

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Likuiditas Kas'),
      drawer: const AppDrawer(currentRoute: '/likuiditas'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                StatCard(
                  title: 'Saldo Kas Tersedia',
                  value: CurrencyFormatter.formatRp(totalKas),
                  icon: Icons.account_balance_wallet_rounded,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF15803D),
                  trendPill: 'Sangat Aman',
                  isPositiveTrend: true,
                ),
                StatCard(
                  title: 'Rasio Likuiditas Kas',
                  value: '${rasioLikuiditas.toStringAsFixed(1)}%',
                  icon: Icons.speed_rounded,
                  iconBg: const Color(0xFFE0E7FF),
                  iconColor: const Color(0xFF4338CA),
                  subtitle: 'Standar Min: 120%',
                ),
                StatCard(
                  title: 'Arus Kas Masuk (Inflow)',
                  value: CurrencyFormatter.formatRp(angsuranMasuk),
                  icon: Icons.arrow_downward_rounded,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF15803D),
                  subtitle: 'Angsuran & Simpanan',
                ),
                StatCard(
                  title: 'Arus Kas Keluar (Outflow)',
                  value: CurrencyFormatter.formatRp(pencairanBulanIni),
                  icon: Icons.arrow_upward_rounded,
                  iconBg: const Color(0xFFFEF3C7),
                  iconColor: const Color(0xFFB45309),
                  subtitle: 'Pencairan Pinjaman',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Analisis Kesehatan Kas Koperasi (Sehat)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const Divider(height: 20),
                  const Text(
                    'Kondisi kas Koperasi berada pada tingkat yang sangat likuid. Saldo kas bank dan tunai mampu menutupi seluruh antrean pencairan pinjaman baru dan kewajiban operasional.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
