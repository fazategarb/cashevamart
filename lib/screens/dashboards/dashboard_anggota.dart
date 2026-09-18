import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../utils/military_ranks.dart';
import '../../widgets/stat_card.dart';

/// Dashboard Khusus Anggota Koperasi (Prajurit & PNS TNI AD)
class DashboardAnggota extends StatelessWidget {
  const DashboardAnggota({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final anggota = user?.anggota;

    final totalSimp = (anggota?.simpananWajib ?? 1500000.0) + (anggota?.simpananSukarela ?? 1750000.0) + 500000.0;
    final sisaPinj = 8125000.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kartu Identitas Personel Militer
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A2F), Color(0xFF2D5A43)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            'NRP: ${anggota?.nrp ?? '31770091'} • ${anggota?.satminkal ?? 'INFOLAHTADAM IV/DIP'}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saldo Total Simpanan',
                            style: TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.formatRp(totalSimp),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Limit Kredit USIPA',
                            style: TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.formatRp(anggota?.creditLimit ?? 5000000),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFDE68A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4 Metrik Anggota
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              StatCard(
                title: 'Simpanan Sukarela',
                value: CurrencyFormatter.formatRp(anggota?.simpananSukarela ?? 1750000),
                icon: Icons.savings_rounded,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
                subtitle: 'Bisa Ditarik Kapan Saja',
                onTap: () => context.push('/simpanan'),
              ),
              StatCard(
                title: 'Sisa Pinjaman USIPA',
                value: CurrencyFormatter.formatRp(sisaPinj),
                icon: Icons.receipt_long_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
                subtitle: 'Angsuran Ke-5 / 18 Bln',
                onTap: () => context.push('/angsuran'),
              ),
              StatCard(
                title: 'Potongan Gaji Bulan Ini',
                value: 'Rp 1.450.000',
                icon: Icons.payments_rounded,
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4338CA),
                subtitle: 'Lihat Rincian Slip Gaji',
                onTap: () => context.push('/gaji'),
              ),
              StatCard(
                title: 'Poin Belanja & Undian',
                value: '185 Poin',
                icon: Icons.card_giftcard_rounded,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7E22CE),
                trendPill: '2 Kupon RAT',
                isPositiveTrend: true,
                onTap: () => context.push('/poin-undian'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Shortcut Menu Anggota
          const Text(
            'Layanan & Belanja Prajurit',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildActionTile(
                  icon: Icons.shopping_bag_rounded,
                  label: 'Katalog Belanja',
                  color: AppTheme.primary,
                  onTap: () => context.push('/katalog-belanja'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionTile(
                  icon: Icons.note_add_rounded,
                  label: 'Ajukan USIPA',
                  color: const Color(0xFF2563EB),
                  onTap: () => context.push('/pengajuan'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildActionTile(
                  icon: Icons.access_time_rounded,
                  label: 'Pesanan & Piket',
                  color: const Color(0xFFD97706),
                  onTap: () => context.push('/pesanan-antar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionTile(
                  icon: Icons.store_rounded,
                  label: 'Marketplace UMKM',
                  color: const Color(0xFF7C3AED),
                  onTap: () => context.push('/marketplace-anggota'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
