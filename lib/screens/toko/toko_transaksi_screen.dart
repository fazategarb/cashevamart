import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Riwayat Transaksi Penjualan Toko & Kasir POS
class TokoTransaksiScreen extends StatelessWidget {
  const TokoTransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [
      {
        'id': 'TRX-POS-20260806-0048',
        'pembeli': 'Serma Budi Santoso',
        'items': 'Beras 5kg (1), Minyak 2L (2)',
        'metode': 'Potong Gaji',
        'total': 144000.0,
        'waktu': '06 Agu 2026 14:40',
      },
      {
        'id': 'TRX-POS-20260806-0047',
        'pembeli': 'Umum / Non-Anggota',
        'items': 'Kopi Hitam (2), Mie Goreng (5)',
        'metode': 'QRIS',
        'total': 45000.0,
        'waktu': '06 Agu 2026 14:15',
      },
      {
        'id': 'TRX-POS-20260806-0046',
        'pembeli': 'Kapten Inf Rahmat Hidayat',
        'items': 'Kaos Dalam Loreng (2)',
        'metode': 'Tunai',
        'total': 96000.0,
        'waktu': '06 Agu 2026 13:20',
      },
      {
        'id': 'TRX-POS-20260806-0045',
        'pembeli': 'Pelda Agus Wibowo',
        'items': 'Beras 5kg (2), Sambal Teri (1)',
        'metode': 'Potong Gaji',
        'total': 173000.0,
        'waktu': '06 Agu 2026 11:05',
      },
    ];

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Riwayat Transaksi Toko'),
      drawer: const AppDrawer(currentRoute: '/toko-transaksi'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, idx) {
          final item = list[idx];
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.receipt_rounded, color: AppTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['id'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('Pembeli: ${item['pembeli']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      Text(item['items'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const SizedBox(height: 2),
                      Text('Metode: ${item['metode']} • ${item['waktu']}', style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    ],
                  ),
                ),
                Text(
                  CurrencyFormatter.formatRp(item['total']),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.primary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
