import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../models/pinjaman.dart';
import '../../providers/pinjaman_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/military_badge.dart';

/// Screen Riwayat & Monitoring Pinjaman
class RiwayatPinjamanScreen extends StatefulWidget {
  const RiwayatPinjamanScreen({super.key});

  @override
  State<RiwayatPinjamanScreen> createState() => _RiwayatPinjamanScreenState();
}

class _RiwayatPinjamanScreenState extends State<RiwayatPinjamanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDetailPinjaman(BuildContext context, Pinjaman item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.nomorPinjaman ?? item.id,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
                  ),
                  LoanStatusBadge(status: item.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Diajukan pada ${CurrencyFormatter.formatTanggal(item.tanggalPengajuan)}',
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              const Divider(height: 24),
              const Text('Informasi Peminjam', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              _buildDetailItem('Nama Personel', item.anggota?.nama ?? 'Personel TNI AD'),
              _buildDetailItem('NRP / NIP', item.anggota?.nrp ?? '-'),
              _buildDetailItem('Pangkat / Korps', '${item.anggota?.pangkat ?? '-'} ${item.anggota?.korps ?? ''}'),
              _buildDetailItem('Kesatuan / Satminkal', item.anggota?.satminkal ?? 'INFOLAHTADAM IV/DIP'),

              const Divider(height: 24),
              const Text('Rincian Pinjaman', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              _buildDetailItem('Nominal Pokok', CurrencyFormatter.formatRp(item.nominal)),
              _buildDetailItem('Jangka Waktu / Tenor', '${item.tenorBulan} Bulan'),
              _buildDetailItem('Suku Bunga', '1.0% Flat / Bulan (12% per Tahun)'),
              _buildDetailItem(
                'Estimasi Angsuran',
                CurrencyFormatter.formatRp(item.nominal / item.tenorBulan + (item.nominal * 0.12 / 12)),
              ),
              if (item.catatan != null) ...[
                const SizedBox(height: 8),
                _buildDetailItem('Catatan / Keperluan', item.catatan!),
              ],

              const Divider(height: 24),
              const Text('Alur Persetujuan Militer (Workflow)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              _buildWorkflowStep('1. Pengajuan Anggota', 'Selesai', true),
              _buildWorkflowStep('2. Verifikasi Kelayakan Juru Bayar', 'Cek sisa gaji & batas 40%', item.status != StatusPinjaman.diajukan),
              _buildWorkflowStep('3. Rekomendasi Dan / Ka Satuan', 'ACC Pimpinan Satker', [StatusPinjaman.setujuKeprim, StatusPinjaman.dicairkan, StatusPinjaman.lunas].contains(item.status)),
              _buildWorkflowStep('4. Persetujuan Akhir Keprim', 'Otorisasi tertinggi Koperasi', [StatusPinjaman.setujuKeprim, StatusPinjaman.dicairkan, StatusPinjaman.lunas].contains(item.status)),
              _buildWorkflowStep('5. Pencairan Kas / Transfer', 'Invoice & Kwitansi Resmi', [StatusPinjaman.dicairkan, StatusPinjaman.lunas].contains(item.status)),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildWorkflowStep(String title, String subtitle, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isCompleted ? AppTheme.primary : AppTheme.textMuted,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
                    color: isCompleted ? AppTheme.textPrimary : AppTheme.textSecondary,
                  ),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();

    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Riwayat Pinjaman',
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Proses'),
            Tab(text: 'Disetujui'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: '/pinjaman'),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Ajukan USIPA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => context.push('/pengajuan'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nomor pinjaman / nama personel...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoanList(pinjaman.loans),
                _buildLoanList(pinjaman.loans.where((l) => [StatusPinjaman.diajukan, StatusPinjaman.verifikasiJuruBayar, StatusPinjaman.rekomendasiPimpinan].contains(l.status)).toList()),
                _buildLoanList(pinjaman.loans.where((l) => [StatusPinjaman.setujuKeprim, StatusPinjaman.setujuKaprim, StatusPinjaman.menungguDokumen].contains(l.status)).toList()),
                _buildLoanList(pinjaman.loans.where((l) => [StatusPinjaman.dicairkan, StatusPinjaman.lunas].contains(l.status)).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanList(List<Pinjaman> list) {
    var filtered = list;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((l) =>
        (l.nomorPinjaman?.toLowerCase().contains(q) ?? false) ||
        (l.anggota?.nama.toLowerCase().contains(q) ?? false)
      ).toList();
    }

    if (filtered.isEmpty) {
      return const Center(
        child: Text('Tidak ada riwayat pinjaman ditemukan.', style: TextStyle(color: AppTheme.textMuted)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final item = filtered[idx];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () => _showDetailPinjaman(context, item),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
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
                      LoanStatusBadge(status: item.status),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                            'NRP: ${item.anggota?.nrp ?? '-'} • Tenor: ${item.tenorBulan} Bulan',
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
