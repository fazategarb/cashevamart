import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Exception khusus API Casheva
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

/// HTTP API Client dengan interceptor JWT token dan retry fallback
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  String? _authToken;
  String _baseUrl = ApiConfig.baseUrl;

  String? get authToken => _authToken;
  Map<String, String> get authHeaders => _buildHeaders();

  void setAuthToken(String? token) {
    _authToken = token;
  }

  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  Map<String, String> _buildHeaders([Map<String, String>? extra]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    var cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    var cleanBase = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;

    final uriString = '$cleanBase$cleanEndpoint';
    final uri = Uri.parse(uriString);

    if (queryParams != null && queryParams.isNotEmpty) {
      final stringParams = queryParams.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );
      return uri.replace(queryParameters: stringParams);
    }
    return uri;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        final decoded = jsonDecode(response.body);
        // If response is wrapped in standard NestJS response { data: ... }
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'];
        }
        return decoded;
      } catch (_) {
        return response.body;
      }
    }

    // Error handling
    String errorMessage = 'Terjadi kesalahan sistem (${response.statusCode})';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] != null) {
          if (decoded['message'] is List) {
            errorMessage = (decoded['message'] as List).join(', ');
          } else {
            errorMessage = decoded['message'].toString();
          }
        } else if (decoded['error'] != null) {
          errorMessage = decoded['error'].toString();
        }
      }
    } catch (_) {
      if (response.body.isNotEmpty) {
        errorMessage = response.body;
      }
    }

    throw ApiException(errorMessage, statusCode: response.statusCode);
  }

  /// GET Request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams, Map<String, String>? headers}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      debugPrint('[API GET] $uri');
      final response = await http
          .get(uri, headers: _buildHeaders(headers))
          .timeout(const Duration(seconds: 20));
      return _handleResponse(response);
    } on SocketException catch (e) {
      debugPrint('[API GET ERROR Socket] $e');
      throw const ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet atau status backend.');
    } catch (e) {
      if (e is ApiException) rethrow;
      debugPrint('[API GET ERROR] $e');
      throw ApiException(e.toString());
    }
  }

  /// POST Request
  Future<dynamic> post(String endpoint, {dynamic body, Map<String, dynamic>? queryParams, Map<String, String>? headers}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      debugPrint('[API POST] $uri');
      final response = await http
          .post(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 25));
      return _handleResponse(response);
    } on SocketException catch (e) {
      debugPrint('[API POST ERROR Socket] $e');
      throw const ApiException('Tidak dapat terhubung ke server backend.');
    } catch (e) {
      if (e is ApiException) rethrow;
      debugPrint('[API POST ERROR] $e');
      throw ApiException(e.toString());
    }
  }

  /// PATCH Request
  Future<dynamic> patch(String endpoint, {dynamic body, Map<String, dynamic>? queryParams, Map<String, String>? headers}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      debugPrint('[API PATCH] $uri');
      final response = await http
          .patch(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 20));
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// DELETE Request
  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? queryParams, Map<String, String>? headers}) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      debugPrint('[API DELETE] $uri');
      final response = await http
          .delete(uri, headers: _buildHeaders(headers))
          .timeout(const Duration(seconds: 20));
      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }
}
