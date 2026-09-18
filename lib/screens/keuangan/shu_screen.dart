import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/shu.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Pengawasan & Perhitungan SHU (Sisa Hasil Usaha)
class ShuScreen extends StatefulWidget {
  const ShuScreen({super.key});

  @override
  State<ShuScreen> createState() => _ShuScreenState();
}

class _ShuScreenState extends State<ShuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<ShuAnggotaItem> _rawAnggota = const [
    ShuAnggotaItem(nrp: '11020033', nama: 'Letkol Cba Dedi Kurnia', pangkat: 'Letkol Cba', modal: 17300000, transaksi: 24500000),
    ShuAnggotaItem(nrp: '11060078', nama: 'Kapten Inf Rahmat Hidayat', pangkat: 'Kapten Inf', modal: 10850000, transaksi: 18200000),
    ShuAnggotaItem(nrp: '21980045', nama: 'Serma Budi Santoso', pangkat: 'Serma', modal: 6500000, transaksi: 9400000),
    ShuAnggotaItem(nrp: '21930112', nama: 'Pelda Agus Wibowo', pangkat: 'Pelda', modal: 8000000, transaksi: 11200000),
    ShuAnggotaItem(nrp: '198504112009', nama: 'PNS Sri Wahyuni', pangkat: 'Penata Muda', modal: 4700000, transaksi: 6100000),
    ShuAnggotaItem(nrp: '11150221', nama: 'Mayor Kav Fajar Nugroho', pangkat: 'Mayor Kav', modal: 14000000, transaksi: 15800000),
  ];

  late ShuSummary _summary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _summary = ShuSummary.calculate(
      tahunBuku: 2026,
      totalPendapatan: 380000000,
      totalBeban: 195000000,
      pajakPersen: 0,
      rawAnggota: _rawAnggota,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Pengawasan SHU 2026',
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: '7 Pos Alokasi'),
            Tab(text: 'Rincian Per Anggota'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: '/shu'),
      body: Column(
        children: [
          // Banner Total SHU
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E3A2F), Color(0xFF2D5A43)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TOTAL SHU BERSIH (TB 2026)', style: TextStyle(color: Color(0xFFFDE68A), fontSize: 10, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatRp(_summary.totalShuBersih),
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Pendapatan - Biaya', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text(
                        '${CurrencyFormatter.formatRp(_summary.totalPendapatan)} - ${CurrencyFormatter.formatRp(_summary.totalBeban)}',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAlokasiTab(),
                _buildAnggotaTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlokasiTab() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: _summary.alokasi.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final a = _summary.alokasi[idx];
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text('${a.persen.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryDark, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.pos, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                    Text('Alokasi ${a.persen}% dari SHU Bersih', style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.formatRp(a.nominal),
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppTheme.primary),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnggotaTab() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: _summary.anggotaShu.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final item = _summary.anggotaShu[idx];
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
                  Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    CurrencyFormatter.formatRp(item.totalShu),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppTheme.primary),
                  ),
                ],
              ),
              Text('NRP: ${item.nrp} • Pangkat: ${item.pangkat ?? '-'}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Jasa Modal (20%): ${CurrencyFormatter.formatRp(item.shuJasaModal)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  Text('Jasa Usaha (30%): ${CurrencyFormatter.formatRp(item.shuJasaUsaha)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
