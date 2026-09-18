import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/anggota.dart';
import '../../utils/military_ranks.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/military_badge.dart';

/// Screen Data Anggota Koperasi Satuan TNI AD (Diurutkan berdasarkan Hierarki Pangkat)
class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({super.key});

  @override
  State<AnggotaScreen> createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  final List<Anggota> _rawList = [
    const Anggota(id: 'ANG-001', nrp: '11110234', nama: 'Arif Setiawan', pangkat: 'Mayor Cba', golongan: 'Pamen', korps: 'Cba', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 4200000, simpananSukarela: 9800000, creditLimit: 15000000, status: 'Aktif'),
    const Anggota(id: 'ANG-002', nrp: '10980017', nama: 'Bagus Prayitno', pangkat: 'Kolonel Inf', golongan: 'Pamen', korps: 'Inf', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 6000000, simpananSukarela: 25000000, creditLimit: 30000000, status: 'Aktif'),
    const Anggota(id: 'ANG-003', nrp: '11020033', nama: 'Dedi Kurnia', pangkat: 'Letkol Cba', golongan: 'Pamen', korps: 'Cba', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 4800000, simpananSukarela: 12500000, creditLimit: 20000000, status: 'Aktif'),
    const Anggota(id: 'ANG-004', nrp: '21980045', nama: 'Budi Santoso', pangkat: 'Serma', golongan: 'Bintara', korps: 'Chb', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 2400000, simpananSukarela: 4100000, creditLimit: 10000000, status: 'Aktif'),
    const Anggota(id: 'ANG-005', nrp: '11060078', nama: 'Rahmat Hidayat', pangkat: 'Kapten Inf', golongan: 'Pama', korps: 'Inf', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 3600000, simpananSukarela: 7250000, creditLimit: 12000000, status: 'Aktif'),
    const Anggota(id: 'ANG-006', nrp: '198504112009', nama: 'Sri Wahyuni', pangkat: 'Penata Muda', golongan: 'PNS', korps: 'PNS', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 1800000, simpananSukarela: 2900000, creditLimit: 8000000, status: 'Aktif'),
    const Anggota(id: 'ANG-007', nrp: '21930112', nama: 'Agus Wibowo', pangkat: 'Pelda', golongan: 'Bintara', korps: 'Czi', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 2700000, simpananSukarela: 5300000, creditLimit: 10000000, status: 'Cuti'),
    const Anggota(id: 'ANG-008', nrp: '31770091', nama: 'Hendra Gunawan', pangkat: 'Sertu', golongan: 'Bintara', korps: 'Inf', satminkal: 'INFOLAHTADAM IV/DIP', simpananWajib: 1500000, simpananSukarela: 1750000, creditLimit: 5000000, status: 'Aktif'),
  ];

  String _search = '';

  @override
  Widget build(BuildContext context) {
    // Sort otomatis berdasarkan hierarki pangkat militer TNI AD (Highest to lowest)
    final sorted = MilitaryRanks.sortByPangkat(_rawList);

    var list = sorted;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((a) =>
        a.nama.toLowerCase().contains(q) ||
        a.nrp.contains(q) ||
        a.pangkat.toLowerCase().contains(q)
      ).toList();
    }

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Data Anggota Satuan'),
      drawer: const AppDrawer(currentRoute: '/anggota'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama personel, pangkat, NRP...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total ${list.length} Personel Terdaftar', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                const Text('Urutan Pangkat Tertinggi (Hierarki)', style: TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final a = list[idx];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.primarySoft,
                        child: Text(
                          '${idx + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryDark, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MilitaryRanks.formatNamaLengkapDinas(a.nama, a.pangkat, a.korps, a.golongan),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            ),
                            Text('NRP: ${a.nrp} • ${a.satminkal}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      MilitaryRankBadge(pangkat: a.pangkat, korps: a.korps, kategori: a.golongan),
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
