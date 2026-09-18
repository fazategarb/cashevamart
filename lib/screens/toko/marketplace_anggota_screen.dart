import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/toko.dart';
import '../../services/toko_service.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Marketplace Produk UMKM Anggota & Persit
class MarketplaceAnggotaScreen extends StatefulWidget {
  const MarketplaceAnggotaScreen({super.key});

  @override
  State<MarketplaceAnggotaScreen> createState() => _MarketplaceAnggotaScreenState();
}

class _MarketplaceAnggotaScreenState extends State<MarketplaceAnggotaScreen> {
  List<PengajuanMarketplace> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await TokoService.instance.getMarketplaceList();
    if (mounted) {
      setState(() {
        _list = res;
        _isLoading = false;
      });
    }
  }

  void _showAjukanProdukModal(BuildContext context) {
    final namaCtrl = TextEditingController();
    final hargaCtrl = TextEditingController(text: '15000');
    final stokCtrl = TextEditingController(text: '20');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajukan Produk UMKM Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Produk UMKM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextField(
                controller: namaCtrl,
                decoration: const InputDecoration(hintText: 'Contoh: Keripik Tempe Renyah / Madu Asli'),
              ),
              const SizedBox(height: 12),
              const Text('Harga Jual yang Diusulkan (Rp)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextField(
                controller: hargaCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const Text('Stok Awal yang Disetorkan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextField(
                controller: stokCtrl,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengajuan produk UMKM berhasil dikirim ke pengurus koperasi')),
              );
            },
            child: const Text('Ajukan Produk', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCasheva(title: 'Marketplace UMKM Anggota'),
      drawer: const AppDrawer(currentRoute: '/marketplace-anggota'),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
        label: const Text('Jual Produk UMKM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showAjukanProdukModal(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: _list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final item = _list[idx];
                final isApproved = item.status == 'DISETUJUI';

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(item.gambar, width: 65, height: 65, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.kategori, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isApproved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: isApproved ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(item.namaProduk, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                            Text('Penjual: ${item.anggotaNama}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                            const SizedBox(height: 4),
                            Text(
                              '${CurrencyFormatter.formatRp(item.hargaUsul)} • Stok: ${item.stokAwal}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
