import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../models/toko.dart';
import '../../providers/auth_provider.dart';
import '../../providers/toko_provider.dart';
import '../../services/toko_service.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';

/// Screen Keranjang Belanja & Checkout Pembayaran
class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  String _metodeBayar = 'POTONG_GAJI'; // 'TUNAI' | 'QRIS' | 'POTONG_GAJI'
  String _tipePengiriman = 'AMBIL_SENDIRI'; // 'AMBIL_SENDIRI' | 'TITIP_PIKET' | 'DELIVERY'
  final _lokasiCtrl = TextEditingController(text: 'Barak Remaja Batalyon B');

  @override
  void dispose() {
    _lokasiCtrl.dispose();
    super.dispose();
  }

  void _prosesCheckout() {
    final toko = context.read<TokoProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;

    final nomorPesanan = 'ORD-20260806-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final ongkir = _tipePengiriman == 'DELIVERY' ? 5000.0 : 0.0;
    final totalTagihan = toko.cartSubtotal + ongkir;

    final newOrder = PesananOnline(
      id: nomorPesanan,
      nomorPesanan: nomorPesanan,
      anggotaNama: user?.namaLengkap ?? 'Kapten Cpm Indra, S.Kom.',
      anggotaNrp: user?.anggota?.nrp ?? user?.username ?? '1122334455',
      tipe: _tipePengiriman == 'DELIVERY'
          ? TipePengiriman.deliveryCepat
          : (_tipePengiriman == 'TITIP_PIKET' ? TipePengiriman.titipPiketSatuan : TipePengiriman.ambilSendiri),
      lokasi: _tipePengiriman == 'DELIVERY' ? _lokasiCtrl.text : (_tipePengiriman == 'TITIP_PIKET' ? 'Meja Piket Penjagaan Utama' : 'Meja Kasir Toko Koperasi'),
      petugasPiket: _tipePengiriman == 'TITIP_PIKET' ? 'Serda Yoga Pratama (Piket Jaga)' : null,
      noHp: '081299887766',
      totalBelanja: toko.cartSubtotal,
      ongkir: ongkir,
      totalTagihan: totalTagihan,
      status: StatusPesanan.sedangDiantar,
      estimasiMenit: 30,
      menitBerjalan: 1,
      isTerlambatSla: false,
      kompensasiDiskon: 0,
      items: toko.cart.map((i) => PesananItemDetail(
        nama: i.produk.nama,
        jumlah: i.quantity,
        harga: i.produk.hargaAkhir,
      )).toList(),
      waktuPesan: '06 Agu 2026 14:45',
    );

    TokoService.instance.tambahPesanan(newOrder);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppTheme.success),
            SizedBox(width: 8),
            Text('Pesanan Diterima'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Pesanan: $nomorPesanan',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text('Total Belanja: ${CurrencyFormatter.formatRp(toko.cartSubtotal)}'),
            Text('Metode Bayar: ${_metodeBayar == 'POTONG_GAJI' ? 'Cicilan / Potong Gaji' : _metodeBayar}'),
            Text('Opsi Pengiriman: ${_tipePengiriman == 'DELIVERY' ? 'Antar Cepat' : (_tipePengiriman == 'TITIP_PIKET' ? 'Titip di Piket' : 'Ambil di Toko')}'),
            const SizedBox(height: 8),
            const Text(
              'Pesanan telah dicatat dan akan segera diproses oleh petugas kasir koperasi.',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            onPressed: () {
              toko.clearCart();
              Navigator.pop(ctx);
              context.push('/pesanan-antar');
            },
            child: const Text('Lihat Status Pesanan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toko = context.watch<TokoProvider>();
    final cart = toko.cart;
    final subtotal = toko.cartSubtotal;
    final ongkir = _tipePengiriman == 'DELIVERY' ? 5000.0 : 0.0;
    final grandTotal = subtotal + ongkir;

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Keranjang Belanja'),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 64, color: AppTheme.textMuted),
                  const SizedBox(height: 12),
                  const Text('Keranjang belanja Anda kosong.', style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                    onPressed: () => context.pop(),
                    child: const Text('Belanja Sekarang', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // List Item Keranjang
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final item = cart[idx];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.produk.gambar,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.produk.nama,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    CurrencyFormatter.formatRp(item.hargaSatuan),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline_rounded, size: 20, color: AppTheme.danger),
                                  onPressed: () => toko.updateQuantity(item.produk.id, item.quantity - 1),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline_rounded, size: 20, color: AppTheme.primary),
                                  onPressed: () => toko.updateQuantity(item.produk.id, item.quantity + 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Opsi Pengiriman
                  const Text('Opsi Pengiriman / Pengambilan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        _buildRadioItem(
                          title: 'Ambil Sendiri di Toko',
                          subtitle: 'Bebas biaya ongkos kirim',
                          value: 'AMBIL_SENDIRI',
                          groupValue: _tipePengiriman,
                          onSelected: (v) => setState(() => _tipePengiriman = v),
                        ),
                        const Divider(height: 8),
                        _buildRadioItem(
                          title: 'Titip di Meja Piket Satuan',
                          subtitle: 'Dititipkan ke petugas jaga piket satuan',
                          value: 'TITIP_PIKET',
                          groupValue: _tipePengiriman,
                          onSelected: (v) => setState(() => _tipePengiriman = v),
                        ),
                        const Divider(height: 8),
                        _buildRadioItem(
                          title: 'Delivery Cepat ke Barak / Rumdis (+Rp 5.000)',
                          subtitle: 'Diantar kurir prajurit dalam 30 menit',
                          value: 'DELIVERY',
                          groupValue: _tipePengiriman,
                          onSelected: (v) => setState(() => _tipePengiriman = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Metode Pembayaran
                  const Text('Metode Pembayaran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        _buildRadioItem(
                          title: 'Potong Gaji Payroll (Kredit Toko)',
                          subtitle: 'Dipotong otomatis saat gajian tanggal 1',
                          value: 'POTONG_GAJI',
                          groupValue: _metodeBayar,
                          onSelected: (v) => setState(() => _metodeBayar = v),
                        ),
                        const Divider(height: 8),
                        _buildRadioItem(
                          title: 'QRIS / Dompet Digital',
                          subtitle: 'BCA, Mandiri, BRI, BNI, Dana, GoPay',
                          value: 'QRIS',
                          groupValue: _metodeBayar,
                          onSelected: (v) => setState(() => _metodeBayar = v),
                        ),
                        const Divider(height: 8),
                        _buildRadioItem(
                          title: 'Tunai di Kasir',
                          subtitle: 'Bayar saat mengambil barang',
                          value: 'TUNAI',
                          groupValue: _metodeBayar,
                          onSelected: (v) => setState(() => _metodeBayar = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Ringkasan Belanja
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal Belanja', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            Text(CurrencyFormatter.formatRp(subtotal), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Ongkos Kirim', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            Text(CurrencyFormatter.formatRp(ongkir), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Tagihan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                            Text(
                              CurrencyFormatter.formatRp(grandTotal),
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppTheme.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _prosesCheckout,
                      child: const Text('Konfirmasi & Buat Pesanan', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRadioItem({
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required ValueChanged<String> onSelected,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                      color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
