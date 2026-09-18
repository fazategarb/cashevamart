import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/pinjaman.dart';
import '../../providers/pinjaman_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Antrean Verifikasi Juru Bayar (Juyar)
class VerifikasiScreen extends StatefulWidget {
  const VerifikasiScreen({super.key});

  @override
  State<VerifikasiScreen> createState() => _VerifikasiScreenState();
}

class _VerifikasiScreenState extends State<VerifikasiScreen> {
  void _handleAction(Pinjaman item, bool isApproved) {
    final catatanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isApproved ? 'Verifikasi Setujui Pengajuan' : 'Tolak Verifikasi Pengajuan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pinjaman: ${item.nomorPinjaman ?? item.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              'Personel: ${item.anggota?.nama ?? 'Prajurit'} (${item.anggota?.nrp ?? '-'})',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              isApproved
                  ? 'Catatan Verifikasi Juru Bayar (Opsional):'
                  : 'Alasan Penolakan Kelayakan Gaji (Wajib):',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: catatanCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: isApproved
                    ? 'Contoh: Sisa gaji memenuhi syarat ambang batas 40%'
                    : 'Contoh: Rasio potongan melebihi 40% dari sisa gaji',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isApproved ? AppTheme.primary : AppTheme.danger,
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              final provider = context.read<PinjamanProvider>();
              final targetStatus = isApproved ? StatusPinjaman.rekomendasiPimpinan : StatusPinjaman.ditolak;
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
                          ? 'Pengajuan ${item.nomorPinjaman ?? item.id} berhasil diverifikasi dan diteruskan ke Komandan Satuan.'
                          : 'Pengajuan ${item.nomorPinjaman ?? item.id} ditolak.',
                    ),
                  ),
                );
              }
            },
            child: Text(isApproved ? 'Setujui Verifikasi' : 'Tolak', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();
    final queue = pinjaman.jurbayQueue;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Antrean Verifikasi (Jurbay)'),
      drawer: const AppDrawer(currentRoute: '/verifikasi'),
      body: queue.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_rounded, size: 64, color: AppTheme.success),
                  SizedBox(height: 12),
                  Text('Tidak ada antrean verifikasi baru.', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: queue.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final item = queue[idx];
                const gaji = 5400000.0;
                const tunkin = 2100000.0;
                const pot = 1450000.0;
                const sisa = gaji + tunkin - pot;
                final cicilan = item.nominal / item.tenorBulan + (item.nominal * 0.12 / 12);
                final rasio = (cicilan / sisa) * 100;
                final isLayak = rasio <= 40.0;

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
                              color: isLayak ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isLayak ? 'Layak Verifikasi' : 'Batas 40% Terlampaui',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isLayak ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.anggota?.nama ?? 'Personel TNI AD',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                      ),
                      Text(
                        '${item.anggota?.pangkat ?? '-'} • NRP: ${item.anggota?.nrp ?? '-'} • ${item.anggota?.satminkal ?? 'INFOLAHTADAM IV/DIP'}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Plafon Pinjaman: ${CurrencyFormatter.formatRp(item.nominal)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text('Tenor: ${item.tenorBulan} Bln', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cicilan: ${CurrencyFormatter.formatRp(cicilan)}/bln', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          Text('Rasio: ${rasio.toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isLayak ? AppTheme.success : AppTheme.danger)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.danger),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => _handleAction(item, false),
                              child: const Text('Tolak', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => _handleAction(item, true),
                              child: const Text('Setujui Verifikasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
