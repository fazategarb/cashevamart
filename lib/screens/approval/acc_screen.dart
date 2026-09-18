import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/pinjaman.dart';
import '../../providers/pinjaman_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Persetujuan Akhir Keprim (ACC)
class AccScreen extends StatefulWidget {
  const AccScreen({super.key});

  @override
  State<AccScreen> createState() => _AccScreenState();
}

class _AccScreenState extends State<AccScreen> {
  void _handleAccAction(Pinjaman item, bool isApproved) {
    final catatanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isApproved ? 'Otorisasi ACC Keprim' : 'Tolak ACC Keprim'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pinjaman: ${item.nomorPinjaman ?? item.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text('Prajurit: ${item.anggota?.nama ?? 'Personel'} (${item.anggota?.nrp ?? '-'})', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nominal ACC:', style: TextStyle(fontSize: 12)),
                  Text(CurrencyFormatter.formatRp(item.nominal), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Instruksi / Catatan Keprim:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: catatanCtrl,
              decoration: InputDecoration(
                hintText: isApproved ? 'Disetujui untuk dicairkan oleh Bendahara' : 'Alasan penolakan Keprim...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: isApproved ? AppTheme.primary : AppTheme.danger),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              final provider = context.read<PinjamanProvider>();
              final targetStatus = isApproved ? StatusPinjaman.menungguDokumen : StatusPinjaman.ditolak;
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
                          ? 'Pinjaman ${item.nomorPinjaman ?? item.id} berhasil di-ACC Keprim! Diteruskan ke Bendahara untuk pencairan dana.'
                          : 'Pengajuan ${item.nomorPinjaman ?? item.id} ditolak.',
                    ),
                  ),
                );
              }
            },
            child: Text(isApproved ? 'ACC Pinjaman' : 'Tolak', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();
    final queue = pinjaman.accQueue;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Persetujuan Akhir (ACC)'),
      drawer: const AppDrawer(currentRoute: '/acc'),
      body: queue.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt_rounded, size: 64, color: AppTheme.success),
                  SizedBox(height: 12),
                  Text('Tidak ada pengajuan yang menunggu ACC Keprim.', style: TextStyle(color: AppTheme.textSecondary)),
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
                            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Rekomendasi Dan Lengkap', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
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
                          Text('Plafon Pinjaman: ${CurrencyFormatter.formatRp(item.nominal)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('Tenor: ${item.tenorBulan} Bln', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.danger), padding: const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () => _handleAccAction(item, false),
                              child: const Text('Tolak ACC', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, padding: const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () => _handleAccAction(item, true),
                              child: const Text('ACC Keprim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
