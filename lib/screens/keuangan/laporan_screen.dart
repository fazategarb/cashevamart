import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Laporan Keuangan Koperasi Resmi (Neraca, Laba Rugi, Rekap Pinjaman & Simpanan)
class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _cetakLaporanPDF(String jenisLaporan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.danger),
            const SizedBox(width: 8),
            Text('Cetak Dokumen Dinas ($jenisLaporan)'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KOMANDO DAERAH MILITER IV/DIPONEGORO\nINFORMASI DAN PENGOLAHAN DATA\nPRIMKOPAD KARTIKA INFOLAHTA',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, height: 1.4),
            ),
            const Divider(height: 20),
            Text(
              'Dokumen $jenisLaporan lengkap dengan Kopstuk resmi satuan militer dan tajuk tanda tangan Keprim/Dan siap dicetak atau diekspor ke PDF / Excel.',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 16),
            label: const Text('Unduh PDF Resmi', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dokumen PDF $jenisLaporan berhasil diunduh.')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Laporan Keuangan',
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: 'Neraca'),
            Tab(text: 'Laba Rugi'),
            Tab(text: 'Rekap Dinas'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: '/laporan'),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNeracaTab(),
          _buildLabaRugiTab(),
          _buildRekapDinasTab(),
        ],
      ),
    );
  }

  Widget _buildNeracaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardSection(
            title: 'AKTIVA (HARTA KOPERASI)',
            color: AppTheme.primary,
            rows: [
              {'label': 'Kas & Bank', 'value': 'Rp 480.500.000'},
              {'label': 'Piutang Pinjaman USIPA Beredar', 'value': 'Rp 940.000.000'},
              {'label': 'Persediaan Barang Dagang Toko', 'value': 'Rp 85.400.000'},
              {'label': 'Piutang SBG Unit Gadai', 'value': 'Rp 14.500.000'},
              {'label': 'Inventaris & Perlengkapan Kantor', 'value': 'Rp 45.000.000'},
              {'label': 'TOTAL AKTIVA', 'value': 'Rp 1.565.400.000', 'bold': true, 'highlight': true},
            ],
          ),
          const SizedBox(height: 16),
          _buildCardSection(
            title: 'PASIVA (KEWAJIBAN & MODAL)',
            color: const Color(0xFF2563EB),
            rows: [
              {'label': 'Hutang Dagang Supplier Toko', 'value': 'Rp 21.050.000'},
              {'label': 'Simpanan Pokok Anggota', 'value': 'Rp 214.000.000'},
              {'label': 'Simpanan Wajib Anggota', 'value': 'Rp 626.000.000'},
              {'label': 'Simpanan Sukarela Anggota', 'value': 'Rp 580.000.000'},
              {'label': 'Cadangan Modal Koperasi', 'value': 'Rp 124.350.000'},
              {'label': 'TOTAL PASIVA', 'value': 'Rp 1.565.400.000', 'bold': true, 'highlight': true},
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.primary),
              label: const Text('Cetak Neraca Keuangan (PDF Kopstuk)', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
              onPressed: () => _cetakLaporanPDF('Neraca Keuangan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabaRugiTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCardSection(
            title: 'PENDAPATAN USAHA KOPERASI',
            color: const Color(0xFF15803D),
            rows: [
              {'label': 'Pendapatan Jasa Pinjaman USIPA (12%)', 'value': 'Rp 188.000.000'},
              {'label': 'Penjualan Bersih Unit Toko Koperasi', 'value': 'Rp 129.600.000'},
              {'label': 'Pendapatan Jasa Titip Unit Gadai', 'value': 'Rp 3.400.000'},
              {'label': 'Pendapatan Komisi UMKM & Administrasi', 'value': 'Rp 4.000.000'},
              {'label': 'TOTAL PENDAPATAN KOPERASI', 'value': 'Rp 325.000.000', 'bold': true, 'highlight': true},
            ],
          ),
          const SizedBox(height: 16),
          _buildCardSection(
            title: 'BEBAN & BIAYA OPERASIONAL',
            color: const Color(0xFFDC2626),
            rows: [
              {'label': 'Harga Pokok Penjualan (HPP) Toko', 'value': 'Rp 97.200.000'},
              {'label': 'Biaya Operasional & Pemeliharaan', 'value': 'Rp 24.800.000'},
              {'label': 'Honorarium Pengurus & Staf Kasir', 'value': 'Rp 18.000.000'},
              {'label': 'TOTAL BEBAN OPERASIONAL', 'value': 'Rp 140.000.000', 'bold': true},
            ],
          ),
          const SizedBox(height: 16),
          _buildCardSection(
            title: 'SISA HASIL USAHA (SHU BERSIH)',
            color: const Color(0xFF7C3AED),
            rows: [
              {'label': 'SHU Bersih Tahun Berjalan 2026', 'value': 'Rp 185.000.000', 'bold': true, 'highlight': true},
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.primary),
              label: const Text('Cetak Laporan Laba Rugi (PDF)', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
              onPressed: () => _cetakLaporanPDF('Laba Rugi'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRekapDinasTab() {
    final listRekap = [
      {'title': 'Laporan Daftar Anggota Satuan TNI AD', 'sub': 'Daftar personil, pangkat, korps, NRP, dan status'},
      {'title': 'Laporan Rekapitulasi Simpanan', 'sub': 'Simpanan Pokok, Wajib, Sukarela per anggota'},
      {'title': 'Laporan Realisasi & Piutang Pinjaman', 'sub': 'Buku pinjaman tahunan dan sisa piutang'},
      {'title': 'Laporan Rekap Kwitansi Angsuran Bulanan', 'sub': 'Kwitansi bukti pemotongan gaji payroll'},
      {'title': 'Laporan Pembagian SHU Per Anggota', 'sub': 'Jasa modal & jasa usaha tahun buku'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: listRekap.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, idx) {
        final r = listRekap[idx];
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
                decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.description_rounded, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(r['sub']!, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.print_rounded, color: AppTheme.primary),
                onPressed: () => _cetakLaporanPDF(r['title']!),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardSection({required String title, required Color color, required List<Map<String, dynamic>> rows}) {
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
          Text(title, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: color)),
          const Divider(height: 16),
          ...rows.map((r) {
            final isBold = r['bold'] == true;
            final isHighlight = r['highlight'] == true;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r['label'] as String, style: TextStyle(fontSize: isBold ? 12 : 11, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
                  Text(
                    r['value'] as String,
                    style: TextStyle(
                      fontSize: isHighlight ? 14 : (isBold ? 12 : 11),
                      fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                      color: isHighlight ? color : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
