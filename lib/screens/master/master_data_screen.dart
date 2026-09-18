import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Master Data TNI AD (Pangkat, Korps, Satminkal, Kotama)
class MasterDataScreen extends StatefulWidget {
  const MasterDataScreen({super.key});

  @override
  State<MasterDataScreen> createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _pangkatList = [
    {'nama': 'Jenderal TNI', 'kategori': 'PATI', 'kode': 94},
    {'nama': 'Letnan Jenderal TNI', 'kategori': 'PATI', 'kode': 93},
    {'nama': 'Mayor Jenderal TNI', 'kategori': 'PATI', 'kode': 92},
    {'nama': 'Brigadir Jenderal TNI', 'kategori': 'PATI', 'kode': 91},
    {'nama': 'Kolonel', 'kategori': 'PAMEN', 'kode': 83},
    {'nama': 'Letnan Kolonel', 'kategori': 'PAMEN', 'kode': 82},
    {'nama': 'Mayor', 'kategori': 'PAMEN', 'kode': 81},
    {'nama': 'Kapten', 'kategori': 'PAMA', 'kode': 73},
    {'nama': 'Letnan Satu', 'kategori': 'PAMA', 'kode': 72},
    {'nama': 'Letnan Dua', 'kategori': 'PAMA', 'kode': 71},
    {'nama': 'Pembantu Letnan Satu', 'kategori': 'BINTARA', 'kode': 66},
    {'nama': 'Pembantu Letnan Dua', 'kategori': 'BINTARA', 'kode': 65},
    {'nama': 'Sersan Mayor', 'kategori': 'BINTARA', 'kode': 64},
    {'nama': 'Sersan Kepala', 'kategori': 'BINTARA', 'kode': 63},
    {'nama': 'Sersan Satu', 'kategori': 'BINTARA', 'kode': 62},
    {'nama': 'Sersan Dua', 'kategori': 'BINTARA', 'kode': 61},
    {'nama': 'Kopral Kepala', 'kategori': 'TAMTAMA', 'kode': 56},
    {'nama': 'Kopral Satu', 'kategori': 'TAMTAMA', 'kode': 55},
    {'nama': 'Kopral Dua', 'kategori': 'TAMTAMA', 'kode': 54},
    {'nama': 'Prajurit Kepala', 'kategori': 'TAMTAMA', 'kode': 53},
    {'nama': 'Prajurit Satu', 'kategori': 'TAMTAMA', 'kode': 52},
    {'nama': 'Prajurit Dua', 'kategori': 'TAMTAMA', 'kode': 51},
  ];

  final _korpsList = [
    {'kode': 'Inf', 'nama': 'Infanteri'},
    {'kode': 'Kav', 'nama': 'Kavaleri'},
    {'kode': 'Arm', 'nama': 'Artileri Medan'},
    {'kode': 'Arh', 'nama': 'Artileri Pertahanan Udara'},
    {'kode': 'Czi', 'nama': 'Zeni'},
    {'kode': 'Cpb', 'nama': 'Perhubungan / Chb'},
    {'kode': 'Cba', 'nama': 'Bekang'},
    {'kode': 'Cpl', 'nama': 'Peralatan'},
    {'kode': 'Ckm', 'nama': 'Kesehatan Militer'},
    {'kode': 'Cpm', 'nama': 'Polisi Militer'},
    {'kode': 'Caj', 'nama': 'Ajudan Jenderal'},
    {'kode': 'Cku', 'nama': 'Keuangan'},
    {'kode': 'Chk', 'nama': 'Hukum'},
    {'kode': 'Ctp', 'nama': 'Topografi'},
    {'kode': 'Cpn', 'nama': 'Penerbad'},
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Master Data TNI AD',
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: 'Pangkat & Kode'),
            Tab(text: 'Korps Kecabangan'),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: '/master-data'),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _pangkatList.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              final p = _pangkatList[idx];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['nama'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Kategori: ${p['kategori']}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(6)),
                      child: Text('Kode: ${p['kode']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                    ),
                  ],
                ),
              );
            },
          ),
          ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _korpsList.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, idx) {
              final k = _korpsList[idx];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(k['nama']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                      child: Text(k['kode']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
