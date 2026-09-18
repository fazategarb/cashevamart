import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Manajemen User & Penetapan Peran (Admin)
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<Map<String, dynamic>> _users = [
    {'id': 'USR-001', 'nama': 'Mayor Cba Arif Setiawan', 'nrp': '11110234', 'role': 'Admin Koperasi', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
    {'id': 'USR-002', 'nama': 'Kolonel Inf Bagus Prayitno', 'nrp': '10980017', 'role': 'Pimpinan / Dan / Ka', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
    {'id': 'USR-003', 'nama': 'Letkol Cba Dedi Kurnia', 'nrp': '11020033', 'role': 'Keprim', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
    {'id': 'USR-004', 'nama': 'Serma Budi Santoso', 'nrp': '21980045', 'role': 'Bendahara', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
    {'id': 'USR-005', 'nama': 'Kapten Inf Rahmat Hidayat', 'nrp': '11060078', 'role': 'Pengawas Koperasi', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
    {'id': 'USR-007', 'nama': 'Pelda Agus Wibowo', 'nrp': '21930112', 'role': 'Juru Bayar', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
    {'id': 'USR-008', 'nama': 'Sertu Hendra Gunawan', 'nrp': '31770091', 'role': 'Anggota', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
    {'id': 'USR-009', 'nama': 'Serda Yoga Pratama', 'nrp': '31800142', 'role': 'Kasir Toko', 'satminkal': 'INFOLAHTADAM IV/DIP', 'status': 'Aktif'},
  ];

  String _search = '';

  @override
  Widget build(BuildContext context) {
    var list = _users;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((u) =>
        (u['nama'] as String).toLowerCase().contains(q) ||
        (u['nrp'] as String).contains(q) ||
        (u['role'] as String).toLowerCase().contains(q)
      ).toList();
    }

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Manajemen Pengguna'),
      drawer: const AppDrawer(currentRoute: '/users'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari user, nama, NRP, role...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final u = list[idx];
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
                          (u['nama'] as String).substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u['nama'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                            Text('NRP: ${u['nrp']} • ${u['satminkal']}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Text(
                          u['role'] as String,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
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
