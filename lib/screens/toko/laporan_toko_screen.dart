import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/stat_card.dart';

/// Screen Laporan Keuangan & Penjualan Unit Toko
class LaporanTokoScreen extends StatelessWidget {
  const LaporanTokoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalOmzet = 64800000.0;
    const hpp = 48600000.0;
    const labaKotor = totalOmzet - hpp;
    const operasional = 3200000.0;
    const labaBersih = labaKotor - operasional;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Laporan Keuangan Toko'),
      drawer: const AppDrawer(currentRoute: '/laporan-toko'),
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
                  title: 'Total Omzet Toko',
                  value: CurrencyFormatter.formatRp(totalOmzet),
                  icon: Icons.store_rounded,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF15803D),
                  trendPill: '+12.4%',
                  isPositiveTrend: true,
                ),
                StatCard(
                  title: 'Laba Bersih Toko',
                  value: CurrencyFormatter.formatRp(labaBersih),
                  icon: Icons.monetization_on_rounded,
                  iconBg: const Color(0xFFE0E7FF),
                  iconColor: const Color(0xFF4338CA),
                  trendPill: 'Margin 20%',
                  isPositiveTrend: true,
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
                  const Text('Rincian Laba Rugi Unit Toko (Bulan Berjalan)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const Divider(height: 20),
                  _buildRow('1. Penjualan Kotor (Omzet)', CurrencyFormatter.formatRp(totalOmzet)),
                  _buildRow('2. Harga Pokok Penjualan (HPP)', '- ${CurrencyFormatter.formatRp(hpp)}'),
                  const Divider(height: 14),
                  _buildRow('Laba Kotor Toko', CurrencyFormatter.formatRp(labaKotor), isBold: true),
                  _buildRow('3. Biaya Operasional & Listrik Toko', '- ${CurrencyFormatter.formatRp(operasional)}'),
                  const Divider(height: 14),
                  _buildRow('Laba Bersih Toko (Masuk SHU)', CurrencyFormatter.formatRp(labaBersih), isBold: true, isHighlight: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 13 : 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? AppTheme.primaryDark : AppTheme.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 15 : (isBold ? 13 : 12),
              fontWeight: FontWeight.w800,
              color: isHighlight ? AppTheme.primary : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
