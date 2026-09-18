import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/military_ranks.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Profil Personel & Detail Sesi
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final anggota = user?.anggota;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Profil Personel'),
      drawer: const AppDrawer(currentRoute: '/profil'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kartu ID Militer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A2F), Color(0xFF2D5A43)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFC89D42), width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.person_rounded, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user != null
                        ? MilitaryRanks.formatNamaLengkapDinas(
                            user.namaLengkap,
                            anggota?.pangkat,
                            anggota?.korps,
                            anggota?.golongan,
                          )
                        : 'Personel TNI AD',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NRP: ${anggota?.nrp ?? user?.username ?? '-'}',
                    style: const TextStyle(
                      color: Color(0xFFFDE68A),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Peran: ${auth.activeRole.label}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Rincian Data Personel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Kedinasan & Keanggotaan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Divider(height: 20),
                  _buildDetailRow('Nama Lengkap', user?.namaLengkap ?? '-'),
                  _buildDetailRow('Pangkat / Golongan', '${anggota?.pangkat ?? '-'} (${anggota?.golongan ?? '-'})'),
                  _buildDetailRow('Korps Kecabangan', anggota?.korps ?? '-'),
                  _buildDetailRow('Satminkal', user?.satminkal?.nama ?? 'INFOLAHTADAM IV/DIPONEGORO'),
                  _buildDetailRow('Kotama', user?.kotama?.nama ?? 'KODAM IV/DIPONEGORO'),
                  _buildDetailRow('Status Anggota', anggota?.status ?? 'Aktif'),
                  _buildDetailRow('Role Sistem', auth.activeRole.value),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Opsi Akun
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keamanan & Pengaturan Sesi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.lock_reset_rounded, color: AppTheme.primary),
                    title: const Text('Ubah Kata Sandi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fitur ubah kata sandi terintegrasi dengan portal dinas.')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.fingerprint_rounded, color: AppTheme.primary),
                    title: const Text('Biometrik & PIN Cepat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const Text(' :  ', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
