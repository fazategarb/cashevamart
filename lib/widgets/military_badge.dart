import 'package:flutter/material.dart';
import '../models/pinjaman.dart';
import '../config/app_theme.dart';

/// Badge Pangkat Militer TNI AD
class MilitaryRankBadge extends StatelessWidget {
  final String pangkat;
  final String? korps;
  final String? kategori;

  const MilitaryRankBadge({
    super.key,
    required this.pangkat,
    this.korps,
    this.kategori,
  });

  @override
  Widget build(BuildContext context) {
    final kat = (kategori ?? '').toUpperCase();
    Color bg = AppTheme.primarySoft;
    Color fg = AppTheme.primaryDark;

    if (kat == 'PATI' || pangkat.toLowerCase().contains('jenderal') || pangkat.toLowerCase().contains('brigjen')) {
      bg = const Color(0xFFFEF3C7); // Gold / Amber soft
      fg = const Color(0xFFB45309);
    } else if (kat == 'PAMEN' || pangkat.toLowerCase().contains('kolonel') || pangkat.toLowerCase().contains('mayor')) {
      bg = const Color(0xFFDCFCE7); // Emerald soft
      fg = const Color(0xFF15803D);
    } else if (kat == 'PAMA' || pangkat.toLowerCase().contains('kapten') || pangkat.toLowerCase().contains('let')) {
      bg = const Color(0xFFE0E7FF); // Indigo soft
      fg = const Color(0xFF4338CA);
    } else if (kat == 'PNS') {
      bg = const Color(0xFFF3E8FF); // Purple soft
      fg = const Color(0xFF7E22CE);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Text(
        korps != null && korps!.isNotEmpty && korps != '-' ? '$pangkat $korps' : pangkat,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

/// Badge Status Pinjaman
class LoanStatusBadge extends StatelessWidget {
  final StatusPinjaman status;

  const LoanStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label = status.label;

    switch (status) {
      case StatusPinjaman.diajukan:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF475569);
        break;
      case StatusPinjaman.verifikasiPrimkop:
      case StatusPinjaman.verifikasiJuruBayar:
        bg = AppTheme.primarySoft;
        fg = AppTheme.primaryDark;
        break;
      case StatusPinjaman.rekomendasiPimpinan:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        break;
      case StatusPinjaman.setujuKeprim:
      case StatusPinjaman.setujuKaprim:
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF4338CA);
        break;
      case StatusPinjaman.menungguDokumen:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF7E22CE);
        break;
      case StatusPinjaman.dicairkan:
      case StatusPinjaman.lunas:
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF15803D);
        break;
      case StatusPinjaman.ditolak:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFB91C1C);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
