import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Visualisasi Alur Persetujuan Militer (Audit Flow)
class AuditFlowScreen extends StatelessWidget {
  const AuditFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'tahap': '1. Pengajuan Pinjaman (USIPA)',
        'aktor': 'Anggota Koperasi / Prajurit / PNS',
        'deskripsi': 'Pengisian formulir plafon & tenor online, persetujuan syarat potong gaji payroll.',
        'sla': '< 5 Menit',
        'icon': Icons.note_add_rounded,
        'color': AppTheme.primary,
      },
      {
        'tahap': '2. Verifikasi Kelayakan Gaji',
        'aktor': 'Juru Bayar Satuan (Juyar)',
        'deskripsi': 'Pengecekan slip gaji, tunkin, dan ambang batas cicilan maksimal 40% dari sisa penghasilan.',
        'sla': '1x24 Jam',
        'icon': Icons.verified_user_rounded,
        'color': const Color(0xFF2563EB),
      },
      {
        'tahap': '3. Rekomendasi Komando',
        'aktor': 'Pimpinan / Dan / Ka Satuan',
        'deskripsi': 'Pemberian rekomendasi kedinasan oleh Komandan Satuan kerja prajurit pemohon.',
        'sla': '1x24 Jam',
        'icon': Icons.fact_check_rounded,
        'color': const Color(0xFFD97706),
      },
      {
        'tahap': '4. Persetujuan Akhir (ACC)',
        'aktor': 'Kepala Primkopad (Keprim)',
        'deskripsi': 'Otorisasi tertinggi persetujuan pencairan kas sesuai likuiditas dan plafon pinjaman.',
        'sla': '1x24 Jam',
        'icon': Icons.task_alt_rounded,
        'color': const Color(0xFF059669),
      },
      {
        'tahap': '5. Upload Berkas & Akad',
        'aktor': 'Anggota & Staf Koperasi',
        'deskripsi': 'Penandatanganan akad kredit bermaterai dan verifikasi kelengkapan dokumen dinas.',
        'sla': 'Sesuai Jadwal',
        'icon': Icons.description_rounded,
        'color': const Color(0xFF7C3AED),
      },
      {
        'tahap': '6. Pencairan Kas / Transfer',
        'aktor': 'Bendahara Koperasi',
        'deskripsi': 'Pencairan dana ke rekening penerima, penerbitan invoice dan kwitansi resmi bendahara.',
        'sla': 'Real-time Transfer',
        'icon': Icons.payments_rounded,
        'color': const Color(0xFF15803D),
      },
    ];

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Audit Flow Approval'),
      drawer: const AppDrawer(currentRoute: '/audit-flow'),
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
                  Text('Standar Operasional Alur Otorisasi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('Jejak digital 6 tahapan approval militer transparan dan akuntabel.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: steps.length,
              itemBuilder: (context, idx) {
                final s = steps[idx];
                final isLast = idx == steps.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: (s['color'] as Color).withValues(alpha: 0.15), shape: BoxShape.circle),
                          child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 22),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 70,
                            color: const Color(0xFFCBD5E1),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(s['tahap'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.textPrimary))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                                  child: Text(s['sla'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Aktor: ${s['aktor']}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: s['color'] as Color)),
                            const SizedBox(height: 4),
                            Text(s['deskripsi'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
