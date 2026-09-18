import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Rekap Semua Transaksi Terpusat (USIPA, Toko, Simpanan, Gadai)
class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  String _selectedFilter = 'SEMUA';
  String _search = '';

  final List<Map<String, dynamic>> _allTrx = [
    {
      'id': 'TRX-PJM-0184',
      'unit': 'USIPA',
      'personel': 'Serma Budi Santoso',
      'keterangan': 'Pencairan Pinjaman USIPA',
      'tipe': 'KELUAR',
      'nominal': 15000000.0,
      'waktu': '06 Agu 2026 14:45',
    },
    {
      'id': 'TRX-POS-0048',
      'unit': 'TOKO',
      'personel': 'Serma Budi Santoso',
      'keterangan': 'Belanja POS - Beras & Minyak',
      'tipe': 'MASUK',
      'nominal': 144000.0,
      'waktu': '06 Agu 2026 14:40',
    },
    {
      'id': 'TRX-SMP-0129',
      'unit': 'SIMPANAN',
      'personel': 'Pelda Agus Wibowo',
      'keterangan': 'Setoran Simpanan Sukarela',
      'tipe': 'MASUK',
      'nominal': 250000.0,
      'waktu': '06 Agu 2026 11:30',
    },
    {
      'id': 'TRX-ANG-0211',
      'unit': 'ANGSURAN',
      'personel': 'Kapten Inf Rahmat Hidayat',
      'keterangan': 'Pembayaran Angsuran USIPA Ke-12',
      'tipe': 'MASUK',
      'nominal': 725000.0,
      'waktu': '06 Agu 2026 09:15',
    },
    {
      'id': 'TRX-GDI-0012',
      'unit': 'GADAI',
      'personel': 'Serma Budi Santoso',
      'keterangan': 'Pencairan SBG Gadai Emas 10.5g',
      'tipe': 'KELUAR',
      'nominal': 10000000.0,
      'waktu': '15 Jul 2026 10:20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var filtered = _allTrx;
    if (_selectedFilter != 'SEMUA') {
      filtered = filtered.where((t) => t['unit'] == _selectedFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      filtered = filtered.where((t) =>
        (t['personel'] as String).toLowerCase().contains(q) ||
        (t['id'] as String).toLowerCase().contains(q) ||
        (t['keterangan'] as String).toLowerCase().contains(q)
      ).toList();
    }

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Semua Transaksi'),
      drawer: const AppDrawer(currentRoute: '/transaksi'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari transaksi / nama personel...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['SEMUA', 'USIPA', 'TOKO', 'SIMPANAN', 'ANGSURAN', 'GADAI'].map((u) {
                final isSel = _selectedFilter == u;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(u, style: TextStyle(fontSize: 10, fontWeight: isSel ? FontWeight.bold : FontWeight.normal, color: isSel ? Colors.white : AppTheme.textPrimary)),
                    selected: isSel,
                    selectedColor: AppTheme.primary,
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = u);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final item = filtered[idx];
                final isMasuk = item['tipe'] == 'MASUK';

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
                          color: isMasuk ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isMasuk ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          color: isMasuk ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['id'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                                  child: Text(item['unit'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                                ),
                              ],
                            ),
                            Text(item['personel'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                            Text(item['keterangan'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                            Text(item['waktu'] as String, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${isMasuk ? '+' : '-'}${CurrencyFormatter.formatRp(item['nominal'])}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: isMasuk ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
