import 'package:flutter/foundation.dart';
import '../models/pinjaman.dart';
import '../services/pinjaman_service.dart';

/// Provider Pengelolaan Pinjaman dan Approval
class PinjamanProvider extends ChangeNotifier {
  List<Pinjaman> _loans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Pinjaman> get loans => _loans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Pinjaman> get pendingLoans =>
      _loans.where((l) => l.status == StatusPinjaman.diajukan).toList();

  List<Pinjaman> get jurbayQueue =>
      _loans.where((l) => l.status == StatusPinjaman.verifikasiJuruBayar || l.status == StatusPinjaman.diajukan).toList();

  List<Pinjaman> get rekomendasiQueue =>
      _loans.where((l) => l.status == StatusPinjaman.rekomendasiPimpinan).toList();

  List<Pinjaman> get accQueue =>
      _loans.where((l) => l.status == StatusPinjaman.setujuKeprim || l.status == StatusPinjaman.setujuKaprim).toList();

  List<Pinjaman> get pencairanQueue =>
      _loans.where((l) => l.status == StatusPinjaman.menungguDokumen || l.status == StatusPinjaman.setujuKeprim).toList();

  PinjamanProvider() {
    loadLoans();
  }

  Future<void> loadLoans({StatusPinjaman? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _loans = await PinjamanService.instance.getAllPinjaman(status: status);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createLoan({
    required String anggotaId,
    required double nominal,
    required int tenorBulan,
    String? catatan,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newLoan = await PinjamanService.instance.createPinjaman(
        anggotaId: anggotaId,
        nominal: nominal,
        tenorBulan: tenorBulan,
        catatan: catatan,
      );
      _loans.insert(0, newLoan);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStatus({
    required String id,
    required StatusPinjaman status,
    String? catatan,
    String? alasanPenolakan,
  }) async {
    try {
      final updated = await PinjamanService.instance.updateStatus(
        id: id,
        status: status,
        catatan: catatan,
        alasanPenolakan: alasanPenolakan,
      );
      final idx = _loans.indexWhere((l) => l.id == id);
      if (idx >= 0) {
        _loans[idx] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cairkanPinjaman(String id, {String? catatan}) async {
    try {
      final updated = await PinjamanService.instance.cairkanPinjaman(id, catatan: catatan);
      final idx = _loans.indexWhere((l) => l.id == id);
      if (idx >= 0) {
        _loans[idx] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
