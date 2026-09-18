import 'package:intl/intl.dart';

/// Formatting utilities matching website formatting
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final _numberFormat = NumberFormat('#,##0', 'id_ID');

  /// Format angka ke Rupiah resmi (misal: "Rp 15.000.000")
  static String formatRp(dynamic number) {
    if (number == null) return 'Rp 0';
    final n = (number is num) ? number : double.tryParse(number.toString()) ?? 0;
    return _currencyFormat.format(n).replaceAll(',00', '');
  }

  /// Alias formatRupiah
  static String formatRupiah(dynamic number) => formatRp(number);

  /// Format angka dengan pemisah ribuan (misal: "15.000")
  static String formatNumber(dynamic number) {
    if (number == null) return '0';
    final n = (number is num) ? number : double.tryParse(number.toString()) ?? 0;
    return _numberFormat.format(n);
  }

  /// Format kemasan toko: Box & Pcs
  static String formatBoxPcs(
    int totalPcs, {
    int pcsPerUnit = 1,
    String? satuanBesar,
    String satuanKecil = 'Pcs',
  }) {
    if (satuanBesar == null || pcsPerUnit <= 1) {
      return '$totalPcs $satuanKecil';
    }
    final box = totalPcs ~/ pcsPerUnit;
    final sisaPcs = totalPcs % pcsPerUnit;
    if (box == 0) return '$sisaPcs $satuanKecil';
    if (sisaPcs == 0) return '$box $satuanBesar';
    return '$box $satuanBesar, $sisaPcs $satuanKecil';
  }

  /// Format tanggal Indonesia (misal: "06 Agu 2026")
  static String formatTanggal(DateTime? date, {bool includeTime = false}) {
    if (date == null) return '-';
    if (includeTime) {
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
    }
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }
}
