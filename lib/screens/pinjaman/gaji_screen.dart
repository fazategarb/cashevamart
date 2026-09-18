import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/military_ranks.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Rincian Gaji & Potongan Personel Militer
class GajiScreen extends StatelessWidget {
  const GajiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final anggota = user?.anggota;

    const gajiPokok = 5400000.0;
    const tunkin = 2100000.0;
    const tunjanganLain = 350000.0;
    const totalPenghasilan = gajiPokok + tunkin + tunjanganLain;

    final listPotongan = [
      {'nama': 'Simpanan Wajib Koperasi', 'jumlah': 150000.0},
      {'nama': 'Simpanan Sukarela', 'jumlah': 150000.0},
      {'nama': 'Angsuran USIPA PJM-2026-0175', 'jumlah': 625000.0},
      {'nama': 'Cicilan Belanja Toko (Kredit POS)', 'jumlah': 185000.0},
      {'nama': 'Iuran Koperasi', 'jumlah': 25000.0},
      {'nama': 'Asuransi', 'jumlah': 500000.0},
    ];

    final totalPotongan = listPotongan.fold(0.0, (sum, item) => sum + (item['jumlah'] as double));
    final sisaGaji = totalPenghasilan - totalPotongan;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Rincian Gaji & Potongan'),
      drawer: const AppDrawer(currentRoute: '/gaji'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Slip Gaji Resmi
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A2F), Color(0xFF2D5A43)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SLIP GAJI & POTONGAN KOPERASI',
                            style: TextStyle(
                              color: Color(0xFFFDE68A),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user != null
                                ? MilitaryRanks.formatNamaLengkapDinas(
                                    user.namaLengkap,
                                    anggota?.pangkat,
                                    anggota?.korps,
                                    anggota?.golongan,
                                  )
                                : 'Sertu Hendra Gunawan',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NRP: ${anggota?.nrp ?? '31770091'} • Periode: Agustus 2026',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sisa Gaji Bersih (Take Home Pay):', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(
                          CurrencyFormatter.formatRp(sisaGaji),
                          style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Rincian Penghasilan
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
                  const Row(
                    children: [
                      Icon(Icons.add_circle_outline_rounded, color: AppTheme.success, size: 20),
                      SizedBox(width: 8),
                      Text('1. Rincian Penghasilan (Gaji & Tunjangan)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildGajiRow('Gaji Pokok', CurrencyFormatter.formatRp(gajiPokok)),
                  _buildGajiRow('Tunjangan Kinerja (Tunkin)', CurrencyFormatter.formatRp(tunkin)),
                  _buildGajiRow('Tunjangan Lain-lain', CurrencyFormatter.formatRp(tunjanganLain)),
                  const Divider(height: 16),
                  _buildGajiRow('Total Penghasilan Kotor', CurrencyFormatter.formatRp(totalPenghasilan), isBold: true, color: AppTheme.success),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Rincian Pemotongan
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
                  const Row(
                    children: [
                      Icon(Icons.remove_circle_outline_rounded, color: AppTheme.danger, size: 20),
                      SizedBox(width: 8),
                      Text('2. Rincian Pemotongan Juru Bayar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                    ],
                  ),
                  const Divider(height: 20),
                  ...listPotongan.map((p) => _buildGajiRow(p['nama'] as String, CurrencyFormatter.formatRp(p['jumlah']))),
                  const Divider(height: 16),
                  _buildGajiRow('Total Potongan Gaji', CurrencyFormatter.formatRp(totalPotongan), isBold: true, color: AppTheme.danger),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info Rasio Cicilan
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rasio potongan koperasi sebesar ${(totalPotongan / totalPenghasilan * 100).toStringAsFixed(1)}% dari total penghasilan. Masih berada di dalam batas aman ketentuan militer (< 40%).',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGajiRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 13 : 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 14 : 12,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              color: color ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
