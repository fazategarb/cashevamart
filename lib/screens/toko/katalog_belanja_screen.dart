import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../models/toko.dart';
import '../../providers/toko_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Katalog Belanja Toko Koperasi (Sembako, Kaporlap, Fast Consume & UMKM)
class KatalogBelanjaScreen extends StatefulWidget {
  const KatalogBelanjaScreen({super.key});

  @override
  State<KatalogBelanjaScreen> createState() => _KatalogBelanjaScreenState();
}

class _KatalogBelanjaScreenState extends State<KatalogBelanjaScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toko = context.watch<TokoProvider>();

    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Katalog Belanja Toko',
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: toko.totalCartItemCount > 0,
              label: Text('${toko.totalCartItemCount}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              child: const Icon(Icons.shopping_cart_outlined, size: 24),
            ),
            onPressed: () => context.push('/keranjang'),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/katalog-belanja'),
      floatingActionButton: toko.totalCartItemCount > 0
          ? FloatingActionButton.extended(
              backgroundColor: AppTheme.primary,
              icon: const Icon(Icons.shopping_bag_rounded, color: Colors.white),
              label: Text(
                '${toko.totalCartItemCount} Item (${CurrencyFormatter.formatRp(toko.cartSubtotal)})',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () => context.push('/keranjang'),
            )
          : null,
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari beras, minyak, kaos loreng, kopi...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          toko.setSearchQuery('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (v) => toko.setSearchQuery(v),
            ),
          ),

          // Horizontal Categories
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('Semua Produk'),
                    selected: toko.selectedKategoriId == null,
                    selectedColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: toko.selectedKategoriId == null ? FontWeight.bold : FontWeight.normal,
                      color: toko.selectedKategoriId == null ? Colors.white : AppTheme.textPrimary,
                    ),
                    onSelected: (val) {
                      if (val) toko.setKategori(null);
                    },
                  ),
                ),
                ...toko.kategoriList.map((kat) {
                  final isSelected = toko.selectedKategoriId == kat.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(kat.nama),
                      selected: isSelected,
                      selectedColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                      ),
                      onSelected: (val) {
                        toko.setKategori(val ? kat.id : null);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Grid Produk
          Expanded(
            child: toko.isLoading
                ? const Center(child: CircularProgressIndicator())
                : toko.produkList.isEmpty
                    ? const Center(child: Text('Produk tidak ditemukan.', style: TextStyle(color: AppTheme.textMuted)))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: toko.produkList.length,
                        itemBuilder: (context, idx) {
                          final p = toko.produkList[idx];
                          return _buildProductCard(context, p, toko);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Produk p, TokoProvider toko) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    image: DecorationImage(
                      image: NetworkImage(p.gambar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (p.isPromo)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Promo -${p.diskonPersen.toInt()}%',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                if (p.sumber == 'UMKM Anggota')
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'UMKM',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.kategoriNama,
                  style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  p.nama,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.formatRp(p.hargaAkhir),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.primary),
                    ),
                    Text(
                      'Stok ${p.stokFisik}',
                      style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.add_shopping_cart_rounded, size: 14, color: Colors.white),
                    label: const Text('Tambah', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () {
                      toko.addToCart(p);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${p.nama} ditambahkan ke keranjang'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
