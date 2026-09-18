import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/pinjaman.dart';
import '../../providers/pinjaman_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Antrean Rekomendasi Pimpinan / Dan / Ka Satuan
class RekomendasiScreen extends StatefulWidget {
  const RekomendasiScreen({super.key});

  @override
  State<RekomendasiScreen> createState() => _RekomendasiScreenState();
}

class _RekomendasiScreenState extends State<RekomendasiScreen> {
  void _handleAction(Pinjaman item, bool isApproved) {
    final catatanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isApproved ? 'Beri Rekomendasi Komandan' : 'Tolak Rekomendasi Satuan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pinjaman: ${item.nomorPinjaman ?? item.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text('Prajurit: ${item.anggota?.nama ?? 'Personel'} (${item.anggota?.nrp ?? '-'})', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            const Text('Catatan / Arahan Komandan Satker:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: catatanCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: isApproved ? 'Contoh: Disetujui untuk keperluan dinas/keluarga prajurit' : 'Alasan penolakan satuan...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: isApproved ? const Color(0xFFD97706) : AppTheme.danger),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              final provider = context.read<PinjamanProvider>();
              final targetStatus = isApproved ? StatusPinjaman.setujuKeprim : StatusPinjaman.ditolak;
              final ok = await provider.updateStatus(
                id: item.id,
                status: targetStatus,
                catatan: catatanCtrl.text,
                alasanPenolakan: !isApproved ? catatanCtrl.text : null,
              );
              if (ok) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      isApproved
                          ? 'Rekomendasi Komandan diberikan. Diteruskan ke Keprim untuk ACC final.'
                          : 'Pengajuan ${item.nomorPinjaman ?? item.id} ditolak.',
                    ),
                  ),
                );
              }
            },
            child: Text(isApproved ? 'Rekomendasikan' : 'Tolak', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();
    final queue = pinjaman.rekomendasiQueue;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Antrean Rekomendasi (Dan/Ka)'),
      drawer: const AppDrawer(currentRoute: '/rekomendasi'),
      body: queue.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fact_check_rounded, size: 64, color: AppTheme.success),
                  SizedBox(height: 12),
                  Text('Tidak ada antrean rekomendasi satuan baru.', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: queue.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
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
                          Text(item.nomorPinjaman ?? item.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Lolos Verifikasi Jurbay', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(item.anggota?.nama ?? 'Personel TNI AD', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                      Text('${item.anggota?.pangkat ?? '-'} • NRP: ${item.anggota?.nrp ?? '-'} • ${item.anggota?.satminkal ?? 'INFOLAHTADAM IV/DIP'}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nominal: ${CurrencyFormatter.formatRp(item.nominal)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('Tenor: ${item.tenorBulan} Bln', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.danger), padding: const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () => _handleAction(item, false),
                              child: const Text('Tolak', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), padding: const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () => _handleAction(item, true),
                              child: const Text('Beri Rekomendasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
