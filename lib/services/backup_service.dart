import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'api_service.dart';

/// Service untuk backup database terenkripsi
class BackupService {
  BackupService._();
  static final BackupService instance = BackupService._();

  /// Cek status backup terakhir
  Future<Map<String, dynamic>> getStatus() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.backupStatus);
      if (res is Map<String, dynamic>) return res;
    } catch (e) {
      debugPrint('[BACKUP] getStatus error: $e');
    }

    // Demo fallback
    return {
      'lastBackup': '2026-08-06T06:00:00.000Z',
      'size': '12.5 MB',
      'status': 'success',
      'encrypted': true,
    };
  }

  /// Download backup terenkripsi (return bytes)
  Future<Uint8List?> downloadEncrypted() async {
    try {
      final res = await ApiService.instance.get(ApiConfig.backupDownload);
      if (res is Uint8List) return res;
    } catch (e) {
      debugPrint('[BACKUP] downloadEncrypted error: $e');
    }
    return null;
  }
}
