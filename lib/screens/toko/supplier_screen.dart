import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/toko_service.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Supplier & Pengadaan Barang Toko
class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suppliers = TokoService.mockSupplierList;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Supplier & Pengadaan'),
      drawer: const AppDrawer(currentRoute: '/supplier'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: suppliers.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final s = suppliers[idx];
          return Container(
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
                    Text(s.kode, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.primary)),
                    Text('Hutang: ${CurrencyFormatter.formatRp(s.totalHutang)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.danger)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(s.nama, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text('Kontak: ${s.kontak} • Telp: ${s.telepon}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                Text('Alamat: ${s.alamat}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          );
        },
      ),
    );
  }
}
