import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/toko.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../services/toko_service.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Monitoring Pesanan Antar Barak & Titip Piket Satuan
class PesananAntarScreen extends StatefulWidget {
  const PesananAntarScreen({super.key});

  @override
  State<PesananAntarScreen> createState() => _PesananAntarScreenState();
}

class _PesananAntarScreenState extends State<PesananAntarScreen> {
  List<PesananOnline> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    final auth = context.read<AuthProvider>();
    final isStaff = auth.isAdmin || auth.activeRole == Role.kasirToko;
    final user = auth.currentUser;

    final list = await TokoService.instance.getPesananList(
      nrp: user?.anggota?.nrp ?? user?.username,
      nama: user?.anggota?.nama ?? user?.namaLengkap,
      username: user?.username,
      isStaff: isStaff,
    );

    if (mounted) {
      setState(() {
        _orders = list;
        _isLoading = false;
      });
    }
  }

  void _handleUpdateStatus(String orderId, StatusPesanan newStatus) {
    TokoService.instance.updateStatusPesanan(orderId, newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pesanan berhasil diperbarui ke: ${newStatus.label}'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isStaff = auth.isAdmin || auth.activeRole == Role.kasirToko;

    final countSedangDiantar = _orders.where((o) => o.status == StatusPesanan.sedangDiantar).length;
    final countTitipPiket = _orders.where((o) => o.status == StatusPesanan.titipDiPiket).length;

    return Scaffold(
      appBar: AppBarCasheva(title: isStaff ? 'Pesanan Antar & Piket' : 'Pesanan Saya & Piket'),
      drawer: const AppDrawer(currentRoute: '/pesanan-antar'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 2 Summary Metric Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.25)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.delivery_dining_rounded, size: 16, color: AppTheme.primary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      isStaff ? 'Sedang Diantar' : 'Pesanan Diantar',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$countSedangDiantar Pesanan',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.shield_outlined, size: 16, color: Color(0xFFB45309)),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Titip di Piket',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$countTitipPiket Pesanan',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF92400E)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isStaff ? 'Antrean Pesanan Satuan' : 'Daftar Pesanan Belanja Saya',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Text(
                          '${_orders.length} Pesanan',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Empty State
                  if (_orders.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum Ada Pesanan Aktif',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isStaff
                                ? 'Saat ini belum ada pesanan online atau delivery dari anggota.'
                                : 'Anda belum memiliki pesanan antar atau titip piket aktif saat ini.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                          if (!isStaff) ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/katalog-belanja'),
                              icon: const Icon(Icons.shopping_cart_rounded, size: 16, color: Colors.white),
                              label: const Text('Belanja di Katalog Toko', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    ..._orders.map((order) {
                      Color statusBg;
                      Color statusFg;

                      switch (order.status) {
                        case StatusPesanan.sedangDiantar:
                          statusBg = const Color(0xFFFEF3C7);
                          statusFg = const Color(0xFFB45309);
                          break;
                        case StatusPesanan.titipDiPiket:
                          statusBg = const Color(0xFFE0E7FF);
                          statusFg = const Color(0xFF4338CA);
                          break;
                        case StatusPesanan.selesai:
                          statusBg = const Color(0xFFDCFCE7);
                          statusFg = const Color(0xFF15803D);
                          break;
                        default:
                          statusBg = const Color(0xFFF1F5F9);
                          statusFg = const Color(0xFF475569);
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.nomorPesanan, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                                  child: Text(order.status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusFg)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Pemesan: ${order.anggotaNama} (${order.anggotaNrp})',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            ),
                            Text(
                              'Lokasi: ${order.lokasi}',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                            if (order.petugasPiket != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Piket Penerima: ${order.petugasPiket}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4338CA)),
                              ),
                            ],
                            const Divider(height: 18),
                            ...order.items.map((i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('• ${i.nama} x${i.jumlah}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                  Text(CurrencyFormatter.formatRp(i.harga * i.jumlah), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                            const Divider(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Waktu: ${order.waktuPesan}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                Text(
                                  CurrencyFormatter.formatRp(order.totalTagihan),
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.primary),
                                ),
                              ],
                            ),

                            // Action Buttons
                            if (order.status == StatusPesanan.sedangDiantar || order.status == StatusPesanan.titipDiPiket) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => _handleUpdateStatus(order.id, StatusPesanan.selesai),
                                  icon: const Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
                                  label: const Text(
                                    'Konfirmasi Selesai / Diterima',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF15803D),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}

