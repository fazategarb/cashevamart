import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/toko.dart';
import '../../providers/toko_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Terminal POS Kasir Toko Koperasi
class PosKasirScreen extends StatefulWidget {
  const PosKasirScreen({super.key});

  @override
  State<PosKasirScreen> createState() => _PosKasirScreenState();
}

class _PosKasirScreenState extends State<PosKasirScreen> {
  final _barcodeCtrl = TextEditingController();
  final List<CartItem> _posCart = [];
  String _selectedPaymentMethod = 'TUNAI'; // 'TUNAI' | 'QRIS' | 'POTONG_GAJI'
  double _bayarUang = 0;

  double get _subtotal => _posCart.fold(0.0, (sum, i) => sum + i.subtotal);

  void _scanBarcode(String code, List<Produk> allProducts) {
    if (code.trim().isEmpty) return;
    final cleanCode = code.trim().toLowerCase();
    final found = allProducts.firstWhere(
      (p) => p.barcode.toLowerCase() == cleanCode || p.nama.toLowerCase().contains(cleanCode),
      orElse: () => allProducts.first,
    );

    setState(() {
      final existingIdx = _posCart.indexWhere((i) => i.produk.id == found.id);
      if (existingIdx >= 0) {
        _posCart[existingIdx].quantity += 1;
      } else {
        _posCart.add(CartItem(produk: found, quantity: 1));
      }
      _barcodeCtrl.clear();
    });
  }

  void _showStrukBayar(BuildContext context) {
    final noStruk = 'STR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final kembalian = _bayarUang > _subtotal ? _bayarUang - _subtotal : 0.0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Center(
          child: Column(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 40),
              SizedBox(height: 8),
              Text('Transaksi Berhasil', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text('PRIMKOPKAR INFOLAHTADAM IV/DIP', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Text('No. Struk: $noStruk', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              const Divider(height: 16),
              ..._posCart.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${item.produk.nama} x${item.quantity}', style: const TextStyle(fontSize: 11))),
                    Text(CurrencyFormatter.formatRp(item.subtotal), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Belanja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(CurrencyFormatter.formatRp(_subtotal), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppTheme.primary)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Metode Bayar: $_selectedPaymentMethod', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  if (_selectedPaymentMethod == 'TUNAI' && _bayarUang > 0)
                    Text('Kembali: ${CurrencyFormatter.formatRp(kembalian)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.success)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _posCart.clear();
                _bayarUang = 0;
              });
            },
            child: const Text('Tutup Struk'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            icon: const Icon(Icons.print_rounded, size: 16, color: Colors.white),
            label: const Text('Cetak Struk', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _posCart.clear();
                _bayarUang = 0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Struk berhasil dicetak via Thermal Bluetooth Printer')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toko = context.watch<TokoProvider>();

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Terminal POS Kasir'),
      drawer: const AppDrawer(currentRoute: '/pos'),
      body: Column(
        children: [
          // Barcode Scanner Input
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFF1F5F9),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _barcodeCtrl,
                    decoration: InputDecoration(
                      hintText: 'Scan / Masukkan Barcode / Nama...',
                      prefixIcon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    onSubmitted: (code) => _scanBarcode(code, toko.produkList),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _scanBarcode(_barcodeCtrl.text, toko.produkList),
                  child: const Text('Cari', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Quick Item Picker Grid
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: toko.produkList.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final p = toko.produkList[idx];
                return InkWell(
                  onTap: () {
                    setState(() {
                      final ex = _posCart.indexWhere((i) => i.produk.id == p.id);
                      if (ex >= 0) {
                        _posCart[ex].quantity += 1;
                      } else {
                        _posCart.add(CartItem(produk: p, quantity: 1));
                      }
                    });
                  },
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p.nama, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(CurrencyFormatter.formatRp(p.hargaAkhir), style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Struk Keranjang Kasir
          Expanded(
            child: _posCart.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.point_of_sale_rounded, size: 54, color: AppTheme.textMuted),
                        SizedBox(height: 8),
                        Text('Scan barcode atau pilih barang di atas', style: TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _posCart.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final item = _posCart[idx];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.produk.nama, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  Text(
                                    '${CurrencyFormatter.formatRp(item.hargaSatuan)} x ${item.quantity}',
                                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppTheme.danger),
                                  onPressed: () {
                                    setState(() {
                                      if (item.quantity > 1) {
                                        item.quantity -= 1;
                                      } else {
                                        _posCart.removeAt(idx);
                                      }
                                    });
                                  },
                                ),
                                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 18, color: AppTheme.primary),
                                  onPressed: () => setState(() => item.quantity += 1),
                                ),
                              ],
                            ),
                            Text(CurrencyFormatter.formatRp(item.subtotal), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.primary)),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Footer Kasir Pembayaran
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Tagihan Kasir:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text(
                      CurrencyFormatter.formatRp(_subtotal),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildPayChip('TUNAI'),
                    const SizedBox(width: 8),
                    _buildPayChip('QRIS'),
                    const SizedBox(width: 8),
                    _buildPayChip('POTONG_GAJI', label: 'Cicilan Gaji'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _posCart.isEmpty ? null : () => _showStrukBayar(context),
                    child: const Text('Selesaikan Pembayaran & Cetak', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayChip(String value, {String? label}) {
    final isSelected = _selectedPaymentMethod == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPaymentMethod = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppTheme.primary : const Color(0xFFCBD5E1)),
          ),
          child: Center(
            child: Text(
              label ?? value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
