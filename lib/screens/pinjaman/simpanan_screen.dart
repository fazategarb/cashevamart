import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/simpanan.dart';
import '../../providers/auth_provider.dart';
import '../../providers/simpanan_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/stat_card.dart';

/// Screen Simpanan Anggota & Rekapitulasi Kas
class SimpananScreen extends StatefulWidget {
  const SimpananScreen({super.key});

  @override
  State<SimpananScreen> createState() => _SimpananScreenState();
}

class _SimpananScreenState extends State<SimpananScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSetorDialog(BuildContext context) {
    final nominalCtrl = TextEditingController(text: '150000');
    final catatanCtrl = TextEditingController();
    String selectedJenis = 'SUKARELA';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Setor Simpanan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Jenis Simpanan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: selectedJenis,
                  items: const [
                    DropdownMenuItem(value: 'SUKARELA', child: Text('Simpanan Sukarela')),
                    DropdownMenuItem(value: 'WAJIB', child: Text('Simpanan Wajib')),
                    DropdownMenuItem(value: 'POKOK', child: Text('Simpanan Pokok')),
                  ],
                  onChanged: (v) => setDialogState(() => selectedJenis = v ?? 'SUKARELA'),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Nominal Setor (Rp)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: nominalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.monetization_on_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Keterangan / Berita', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: catatanCtrl,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Transfer Bank / Tunai Kasir',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nom = double.tryParse(nominalCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                if (nom <= 0) return;
                final auth = context.read<AuthProvider>();
                final simp = context.read<SimpananProvider>();
                final anggotaId = auth.currentUser?.anggota?.id ?? 'ANG-001';

                Navigator.pop(ctx);
                await simp.setorSimpanan(
                  anggotaId: anggotaId,
                  jenis: selectedJenis,
                  nominal: nom,
                  keterangan: catatanCtrl.text,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Setoran simpanan berhasil diproses')),
                  );
                }
              },
              child: const Text('Simpan Setoran'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final simp = context.watch<SimpananProvider>();

    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Simpanan Anggota',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.primary),
            tooltip: 'Setor Simpanan',
            onPressed: () => _showSetorDialog(context),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/simpanan'),
      body: Column(
        children: [
          // Stat Overview Cards
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Seluruh Simpanan',
                    value: CurrencyFormatter.formatRp(simp.totalSimpananSemua),
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatCard(
                    title: 'Simpanan Sukarela',
                    value: CurrencyFormatter.formatRp(simp.totalSimpananSukarela),
                    icon: Icons.savings_rounded,
                    color: AppTheme.chart3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Simpanan Wajib',
                    value: CurrencyFormatter.formatRp(simp.totalSimpananWajib),
                    icon: Icons.shield_rounded,
                    color: AppTheme.gold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatCard(
                    title: 'Simpanan Pokok',
                    value: CurrencyFormatter.formatRp(simp.totalSimpananPokok),
                    icon: Icons.lock_outline_rounded,
                    color: AppTheme.chart4,
                  ),
                ),
              ],
            ),
          ),

          // Tabs Rekap vs Mutasi
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Rekap Anggota', icon: Icon(Icons.people_outline_rounded, size: 18)),
                Tab(text: 'Mutasi Saya', icon: Icon(Icons.receipt_long_rounded, size: 18)),
              ],
            ),
          ),

          // Filter bar for tab 0
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari anggota, NRP, pangkat...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          // Content Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRekapList(simp.rekap),
                _buildMutasiList(simp.mutasiSaya),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRekapList(List<RekapSimpananAnggota> list) {
    var filtered = list;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((r) =>
        r.nama.toLowerCase().contains(q) || r.nrpNip.toLowerCase().contains(q)
      ).toList();
    }

    if (filtered.isEmpty) {
      return const Center(child: Text('Tidak ada data simpanan.', style: TextStyle(color: AppTheme.textMuted)));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final item = filtered[idx];
        return Container(
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
                  Text(
                    item.nama,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  Text(
                    CurrencyFormatter.formatRp(item.totalSimpanan),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${item.pangkat ?? '-'} • NRP: ${item.nrpNip}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              const Divider(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Wajib: ${CurrencyFormatter.formatRp(item.simpananWajib)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  Text('Sukarela: ${CurrencyFormatter.formatRp(item.simpananSukarela)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMutasiList(List<MutasiSimpanan> list) {
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada transaksi mutasi.', style: TextStyle(color: AppTheme.textMuted)));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.tipe == TipeMutasiSimpanan.setor ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.tipe == TipeMutasiSimpanan.setor ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: item.tipe == TipeMutasiSimpanan.setor ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.keterangan ?? item.tipe.label,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.formatTanggal(item.tanggal, includeTime: true),
                      style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                '${item.tipe == TipeMutasiSimpanan.setor ? '+' : '-'}${CurrencyFormatter.formatRp(item.jumlah)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: item.tipe == TipeMutasiSimpanan.setor ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
