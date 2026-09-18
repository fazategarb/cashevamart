import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/pinjaman_service.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Rekapitulasi Angsuran & Pelunasan Dinamis
class AngsuranScreen extends StatefulWidget {
  const AngsuranScreen({super.key});

  @override
  State<AngsuranScreen> createState() => _AngsuranScreenState();
}

class _AngsuranScreenState extends State<AngsuranScreen> {
  final List<Map<String, dynamic>> _myInstallments = [
    {
      'id': 'PJM-2026-0175',
      'jenis': 'USIPA (Uang Tunai)',
      'pokok': 7500000.0,
      'angsuranKe': 5,
      'totalAngsuran': 18,
      'angsuranBulanan': 625000.0,
      'sisa': 8125000.0,
      'status': 'Lancar',
    },
    {
      'id': 'KRD-2026-0042',
      'jenis': 'Kredit Toko (Barang/POS)',
      'pokok': 555000.0,
      'angsuranKe': 1,
      'totalAngsuran': 3,
      'angsuranBulanan': 185000.0,
      'sisa': 370000.0,
      'status': 'Lancar',
    },
  ];

  void _showPelunasanModal(BuildContext context, Map<String, dynamic> item) async {
    final kalkulasi = await PinjamanService.instance.getKalkulasiDinamis(item['id']);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pelunasan Dipercepat', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildRow('ID Pinjaman', item['id']),
            _buildRow('Jenis Pembiayaan', item['jenis']),
            _buildRow('Sisa Pokok Pinjaman', CurrencyFormatter.formatRp(kalkulasi.pelunasanSisaPokok)),
            _buildRow('Pinalti Bunga Berjalan (2x)', CurrencyFormatter.formatRp(kalkulasi.pelunasanPinaltiBunga2x)),
            const Divider(height: 20),
            _buildRow('Total Kewajiban Pelunasan', CurrencyFormatter.formatRp(kalkulasi.pelunasanTotalBayar), isBold: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                onPressed: () async {
                  Navigator.pop(ctx);
                  await PinjamanService.instance.bayarDinamis(
                    pinjamanId: item['id'],
                    nominalBayar: kalkulasi.pelunasanTotalBayar,
                    isPelunasanDipercepat: true,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pelunasan dipercepat berhasil dikonfirmasi.')),
                    );
                  }
                },
                child: const Text('Bayar Lunas Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isBold ? 14 : 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary)),
          Text(value, style: TextStyle(fontSize: isBold ? 15 : 12, fontWeight: FontWeight.bold, color: isBold ? AppTheme.primary : AppTheme.textPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCasheva(title: 'Rekap Angsuran'),
      drawer: const AppDrawer(currentRoute: '/angsuran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E3A2F), Color(0xFF2D5A43)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jadwal & Riwayat Angsuran', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('Pemotongan angsuran otomatis dari slip gaji bulanan (payroll deduction).', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pinjaman & Kredit Berjalan Saya', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _myInstallments.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final item = _myInstallments[idx];
                final progress = item['angsuranKe'] / item['totalAngsuran'];

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
                          Text(item['id'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(item['status'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item['jenis'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFE2E8F0),
                        color: AppTheme.primary,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bulan Ke-${item['angsuranKe']} dari ${item['totalAngsuran']}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          Text('Sisa ${CurrencyFormatter.formatRp(item['sisa'])}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                        ],
                      ),
                      const Divider(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cicilan: ${CurrencyFormatter.formatRp(item['angsuranBulanan'])} / bln', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              side: const BorderSide(color: AppTheme.primary),
                            ),
                            onPressed: () => _showPelunasanModal(context, item),
                            child: const Text('Pelunasan Awal', style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
