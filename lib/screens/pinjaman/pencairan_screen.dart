import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/pinjaman.dart';
import '../../providers/pinjaman_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Pencairan Dana Pinjaman & Kwitansi
class PencairanScreen extends StatelessWidget {
  const PencairanScreen({super.key});

  void _showCairkanModal(BuildContext context, Pinjaman item) {
    final catatanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: AppTheme.primary),
            SizedBox(width: 8),
            Text('Pencairan Pinjaman'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor: ${item.nomorPinjaman ?? item.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              'Peminjam: ${item.anggota?.nama ?? 'Personel'} (${item.anggota?.nrp ?? '-'})',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nominal Pencairan:', style: TextStyle(fontSize: 12)),
                  Text(
                    CurrencyFormatter.formatRp(item.nominal),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.primaryDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Metode Pembayaran / No. Rekening Penerima:', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            TextField(
              controller: catatanCtrl,
              decoration: InputDecoration(
                hintText: 'Contoh: Transfer BRI No Rek 0184-01-xxxx / Tunai Kasir',
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = context.read<PinjamanProvider>();
              final ok = await provider.cairkanPinjaman(item.id, catatan: catatanCtrl.text);
              if (ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pinjaman ${item.nomorPinjaman ?? item.id} berhasil dicairkan! Kwitansi dibuat.')),
                );
              }
            },
            child: const Text('Konfirmasi Cairkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();
    final queue = pinjaman.pencairanQueue;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Pencairan & Kwitansi'),
      drawer: const AppDrawer(currentRoute: '/pencairan'),
      body: queue.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 64, color: AppTheme.success),
                  SizedBox(height: 12),
                  Text('Semua berkas pinjaman yang disetujui telah dicairkan.', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: queue.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final item = queue[idx];
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
                          Text(
                            item.nomorPinjaman ?? item.id,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ACC Keprim Siap Cair',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.anggota?.nama ?? 'Personel TNI AD',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.anggota?.pangkat ?? '-'} • NRP: ${item.anggota?.nrp ?? '-'}',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                          Text(
                            CurrencyFormatter.formatRp(item.nominal),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primary),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.payments_rounded, color: Colors.white, size: 18),
                          label: const Text('Proses Pencairan & Cetak Kwitansi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: () => _showCairkanModal(context, item),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
