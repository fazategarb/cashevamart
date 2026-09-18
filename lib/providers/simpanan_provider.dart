import 'package:flutter/foundation.dart';
import '../models/simpanan.dart';
import '../services/simpanan_service.dart';

/// Provider Simpanan Anggota
class SimpananProvider extends ChangeNotifier {
  List<RekapSimpananAnggota> _rekap = [];
  List<MutasiSimpanan> _mutasiSaya = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RekapSimpananAnggota> get rekap => _rekap;
  List<MutasiSimpanan> get mutasiSaya => _mutasiSaya;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalSimpananSemua =>
      _rekap.fold(0.0, (sum, item) => sum + item.totalSimpanan);

  double get totalSimpananPokok =>
      _rekap.fold(0.0, (sum, item) => sum + item.simpananPokok);

  double get totalSimpananWajib =>
      _rekap.fold(0.0, (sum, item) => sum + item.simpananWajib);

  double get totalSimpananSukarela =>
      _rekap.fold(0.0, (sum, item) => sum + item.simpananSukarela);

  SimpananProvider() {
    loadRekap();
  }

  Future<void> loadRekap() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rekap = await SimpananService.instance.getRekap();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMutasiSaya(String anggotaId) async {
    try {
      _mutasiSaya = await SimpananService.instance.getByAnggota(anggotaId);
      notifyListeners();
    } catch (e) {
      debugPrint('[SIMPANAN] Load mutasi error: $e');
    }
  }

  Future<bool> setorSimpanan({
    required String anggotaId,
    required String jenis,
    required double nominal,
    String? keterangan,
  }) async {
    try {
      await SimpananService.instance.setorSimpanan(
        anggotaId: anggotaId,
        jenis: jenis,
        nominal: nominal,
        keterangan: keterangan,
      );
      await loadRekap();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
