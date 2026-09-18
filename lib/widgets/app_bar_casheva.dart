import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/notifikasi_provider.dart';

/// Top Bar Casheva dengan Branding Militer, Role Switcher (Admin), dan Notifikasi
class AppBarCasheva extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showRoleSwitcher;
  final PreferredSizeWidget? bottom;

  const AppBarCasheva({
    super.key,
    required this.title,
    this.actions,
    this.showRoleSwitcher = true,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notif = context.watch<NotifikasiProvider>();

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          if (auth.currentUser != null)
            Text(
              '${auth.currentUser!.namaLengkap} (${auth.activeRole.shortLabel})',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
        ],
      ),
      actions: [
        if (showRoleSwitcher && auth.isAdmin)
          PopupMenuButton<Role>(
            tooltip: 'Switch Role Preview (Admin)',
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swap_horiz_rounded, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    auth.activeRole.shortLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            onSelected: (Role newRole) {
              auth.switchRole(newRole);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Beralih tampilan ke role: ${newRole.label}'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            itemBuilder: (context) => Role.values.map((role) {
              final isSelected = role == auth.activeRole;
              return PopupMenuItem<Role>(
                value: role,
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      size: 18,
                      color: isSelected ? AppTheme.primary : AppTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      role.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        IconButton(
          icon: Badge(
            isLabelVisible: notif.unreadCount > 0,
            label: Text(
              '${notif.unreadCount}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            child: const Icon(Icons.notifications_outlined, size: 24),
          ),
          onPressed: () {
            context.push('/notifikasi');
          },
        ),
        if (actions != null) ...actions!,
        const SizedBox(width: 4),
      ],
      bottom: bottom,
    );
  }
}
