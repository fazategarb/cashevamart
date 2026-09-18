import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_theme.dart';
import '../../models/notifikasi.dart';
import '../../providers/notifikasi_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';

/// Screen Notifikasi & Pemberitahuan Real-time
class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notif = context.watch<NotifikasiProvider>();

    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Notifikasi & Pesan',
        actions: [
          if (notif.unreadCount > 0)
            TextButton(
              onPressed: () => notif.markAllAsRead(),
              child: const Text('Tandai Semua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: notif.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 64, color: AppTheme.textMuted),
                  SizedBox(height: 12),
                  Text(
                    'Tidak ada notifikasi baru',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notif.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final item = notif.items[idx];
                Color iconBg;
                Color iconColor;
                IconData iconData;

                switch (item.tipe) {
                  case TipeNotifikasi.sukses:
                    iconBg = const Color(0xFFDCFCE7);
                    iconColor = const Color(0xFF15803D);
                    iconData = Icons.check_circle_rounded;
                    break;
                  case TipeNotifikasi.verifikasi:
                    iconBg = const Color(0xFFE0E7FF);
                    iconColor = const Color(0xFF4338CA);
                    iconData = Icons.verified_user_rounded;
                    break;
                  case TipeNotifikasi.pesanan:
                    iconBg = const Color(0xFFFEF3C7);
                    iconColor = const Color(0xFFB45309);
                    iconData = Icons.local_shipping_rounded;
                    break;
                  default:
                    iconBg = AppTheme.primarySoft;
                    iconColor = AppTheme.primary;
                    iconData = Icons.info_rounded;
                }

                return Material(
                  color: item.isRead ? Colors.white : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: () {
                      notif.markAsRead(item.id);
                      if (item.routeTarget != null) {
                        context.push(item.routeTarget!);
                      }
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: item.isRead ? AppTheme.border : AppTheme.primary.withValues(alpha: 0.3),
                          width: item.isRead ? 1 : 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                            child: Icon(iconData, color: iconColor, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.judul,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      CurrencyFormatter.formatTanggal(item.waktu, includeTime: true),
                                      style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.pesan,
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
