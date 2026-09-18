import 'package:flutter/foundation.dart';
import '../models/toko.dart';
import '../services/toko_service.dart';

/// Provider Pengelolaan Toko, POS & Keranjang Belanja
class TokoProvider extends ChangeNotifier {
  List<Produk> _produkList = [];
  List<KategoriProduk> _kategoriList = [];
  final List<CartItem> _cart = [];
  String? _selectedKategoriId;
  String _searchQuery = '';
  bool _isLoading = false;

  List<Produk> get produkList => _produkList;
  List<KategoriProduk> get kategoriList => _kategoriList;
  List<CartItem> get cart => _cart;
  String? get selectedKategoriId => _selectedKategoriId;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  int get totalCartItemCount =>
      _cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal =>
      _cart.fold(0.0, (sum, item) => sum + item.subtotal);

  TokoProvider() {
    loadCatalog();
  }

  Future<void> loadCatalog() async {
    _isLoading = true;
    notifyListeners();
    try {
      _kategoriList = await TokoService.instance.getKategoriList();
      _produkList = await TokoService.instance.getProdukList(
        kategoriId: _selectedKategoriId,
        query: _searchQuery,
      );
    } catch (e) {
      debugPrint('[TOKO PROVIDER] Load error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setKategori(String? katId) {
    _selectedKategoriId = katId;
    loadCatalog();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadCatalog();
  }

  void addToCart(Produk produk, {int quantity = 1, bool isSatuanBesar = false}) {
    final existingIdx = _cart.indexWhere((item) => item.produk.id == produk.id);
    if (existingIdx >= 0) {
      _cart[existingIdx].quantity += quantity;
    } else {
      _cart.add(CartItem(
        produk: produk,
        quantity: quantity,
        isSatuanBesar: isSatuanBesar,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(String produkId, int newQuantity) {
    final idx = _cart.indexWhere((item) => item.produk.id == produkId);
    if (idx >= 0) {
      if (newQuantity <= 0) {
        _cart.removeAt(idx);
      } else {
        _cart[idx].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String produkId) {
    _cart.removeWhere((item) => item.produk.id == produkId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
