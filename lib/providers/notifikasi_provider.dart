import 'package:flutter/foundation.dart';
import '../models/notifikasi.dart';

/// Provider Notifikasi Real-time
class NotifikasiProvider extends ChangeNotifier {
  final List<NotifikasiItem> _items = [
    NotifikasiItem(
      id: 'NOTIF-01',
      judul: 'Persetujuan Pinjaman Disetujui',
      pesan: 'Pengajuan pinjaman PJM-2026-0184 atas nama Serma Budi Santoso telah di-ACC Keprim.',
      tipe: TipeNotifikasi.sukses,
      waktu: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      routeTarget: '/pinjaman',
    ),
    NotifikasiItem(
      id: 'NOTIF-02',
      judul: 'Antrean Verifikasi Juru Bayar',
      pesan: 'Terdapat 3 berkas pengajuan pinjaman baru yang siap diverifikasi kelayakan gajinya.',
      tipe: TipeNotifikasi.verifikasi,
      waktu: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      routeTarget: '/verifikasi',
    ),
    NotifikasiItem(
      id: 'NOTIF-03',
      judul: 'Pesanan Belanja Siap Diantar',
      pesan: 'Pesanan ORD-20260806-0001 sedang diantar ke Barak Remaja Batalyon B.',
      tipe: TipeNotifikasi.pesanan,
      waktu: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
      routeTarget: '/pesanan-antar',
    ),
  ];

  List<NotifikasiItem> get items => _items;
  int get unreadCount => _items.where((i) => !i.isRead).length;

  void markAsRead(String id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void addNotification(NotifikasiItem item) {
    _items.insert(0, item);
    notifyListeners();
  }
}
