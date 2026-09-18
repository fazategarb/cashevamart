import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Poin Belanja & Undian Doorprize RAT
class PoinUndianScreen extends StatelessWidget {
  const PoinUndianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalPoin = 185;
    const kuponSaya = ['KP-000142', 'KP-000143'];
    const targetBelanja = 500000.0;
    const belanjaBulanIni = 385000.0;
    final progress = belanjaBulanIni / targetBelanja;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Poin & Undian RAT'),
      drawer: const AppDrawer(currentRoute: '/poin-undian'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Total Poin
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C2D12), Color(0xFFC2410C)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TOTAL POIN LOYALTY SAYA', style: TextStyle(color: Color(0xFFFDE68A), fontSize: 11, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        const Text('$totalPoin Poin', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        const Text('Dapatkan 1 poin setiap belanja Rp 10.000 di toko koperasi.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 36),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Event Undian Doorprize RAT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.stars_rounded, color: Color(0xFFB45309), size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Undian Doorprize RAT 2026', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('Hadiah: Sepeda Motor Honda Beat & Emas 5g', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text('Kupon Undian Saya (Telah Diklaim):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: kuponSaya.map((k) => Chip(
                      label: Text(k, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryDark)),
                      backgroundColor: AppTheme.primarySoft,
                    )).toList(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('50 Poin ditukarkan dengan 1 Kupon Undian RAT')),
                        );
                      },
                      child: const Text('Tukar 50 Poin = 1 Kupon Undian', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Target Belanja Bulanan (Misi)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Misi Belanja Bulanan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                        child: const Text('Bonus +100 Poin', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE2E8F0),
                    color: AppTheme.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tercapai ${CurrencyFormatter.formatRp(belanjaBulanIni)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      Text('Target ${CurrencyFormatter.formatRp(targetBelanja)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
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
