import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/toko_provider.dart';
import '../../widgets/stat_card.dart';

/// Dashboard Khusus Kasir Toko Koperasi
class DashboardKasir extends StatelessWidget {
  const DashboardKasir({super.key});

  @override
  Widget build(BuildContext context) {
    final toko = context.watch<TokoProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC89D42).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFC89D42), width: 0.8),
                        ),
                        child: const Text(
                          'KASIR UNIT TOKO & POS',
                          style: TextStyle(
                            color: Color(0xFFFDE68A),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Terminal Kasir & Pesanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Layanan belanja langsung, pesanan antar barak, titip piket & pembayaran QRIS/Cicilan.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.point_of_sale_rounded, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              StatCard(
                title: 'Penjualan Hari Ini',
                value: 'Rp 4.250.000',
                icon: Icons.monetization_on_rounded,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF15803D),
                trendPill: '48 Struk',
                isPositiveTrend: true,
                onTap: () => context.push('/toko-transaksi'),
              ),
              StatCard(
                title: 'Pesanan Antar & Piket',
                value: '2 Pesanan',
                icon: Icons.access_time_rounded,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFB45309),
                subtitle: 'Perlu Pengiriman',
                onTap: () => context.push('/pesanan-antar'),
              ),
              StatCard(
                title: 'Katalog Produk Aktif',
                value: '${toko.produkList.length} Item',
                icon: Icons.inventory_2_rounded,
                iconBg: const Color(0xFFE0E7FF),
                iconColor: const Color(0xFF4338CA),
                subtitle: 'Stok Sembako & Atribut',
                onTap: () => context.push('/inventori'),
              ),
              StatCard(
                title: 'Unit Gadai Aktif',
                value: '1 SBG',
                icon: Icons.diamond_rounded,
                iconBg: const Color(0xFFF3E8FF),
                iconColor: const Color(0xFF7E22CE),
                subtitle: 'Emas & Elektronik',
                onTap: () => context.push('/gadai'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
              label: const Text(
                'Buka Terminal Kasir POS',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              onPressed: () => context.push('/pos'),
            ),
          ),
        ],
      ),
    );
  }
}
