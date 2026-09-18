import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'api_service.dart';

/// Service untuk upload/download dokumen pinjaman (Cloudinary via backend)
class DokumenService {
  DokumenService._();
  static final DokumenService instance = DokumenService._();

  /// Ambil daftar dokumen per pinjaman
  Future<List<Map<String, dynamic>>> getByPinjaman(String pinjamanId) async {
    try {
      final res = await ApiService.instance.get(ApiConfig.dokumenByPinjaman(pinjamanId));
      if (res is List) return res.whereType<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('[DOKUMEN] getByPinjaman error: $e');
    }
    return [];
  }

  /// Upload file dokumen ke pinjaman tertentu
  Future<Map<String, dynamic>?> upload({
    required String pinjamanId,
    required File file,
    required String jenisDokumen,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.dokumenUpload(pinjamanId)}');
      final request = http.MultipartRequest('POST', uri);

      // Add auth header
      final token = ApiService.instance.authToken;
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      
      request.fields['jenisDokumen'] = jenisDokumen;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = response.body.isNotEmpty
            ? (await Future.value(response.body))
            : null;
        if (decoded != null) {
          try {
            final jsonData = Uri.decodeFull(decoded);
            debugPrint('[DOKUMEN] Upload success: $jsonData');
          } catch (_) {
            // ignore parse
          }
        }
        return {'success': true, 'message': 'Dokumen berhasil diupload'};
      }
      throw ApiException('Gagal upload dokumen (${response.statusCode})');
    } catch (e) {
      debugPrint('[DOKUMEN] upload error: $e');
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Download dokumen by URL
  Future<Uint8List?> download(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (e) {
      debugPrint('[DOKUMEN] download error: $e');
    }
    return null;
  }
}
