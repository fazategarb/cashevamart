import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';
import 'dashboard_admin.dart';
import 'dashboard_pimpinan.dart';
import 'dashboard_keprim.dart';
import 'dashboard_bendahara.dart';
import 'dashboard_jurbay.dart';
import 'dashboard_kasir.dart';
import 'dashboard_anggota.dart';
import 'dashboard_pengawas.dart';

/// Screen Utama Dashboard yang otomatis menampilkan UI spesifik sesuai Role yang aktif
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final activeRole = auth.activeRole;

    Widget dashboardContent;
    switch (activeRole) {
      case Role.adminKoperasi:
        dashboardContent = const DashboardAdmin();
        break;
      case Role.pimpinan:
        dashboardContent = const DashboardPimpinan();
        break;
      case Role.keprim:
        dashboardContent = const DashboardKeprim();
        break;
      case Role.bendahara:
        dashboardContent = const DashboardBendahara();
        break;
      case Role.juruBayar:
        dashboardContent = const DashboardJurbay();
        break;
      case Role.kasirToko:
        dashboardContent = const DashboardKasir();
        break;
      case Role.anggota:
        dashboardContent = const DashboardAnggota();
        break;
      case Role.pengawas:
        dashboardContent = const DashboardPengawas();
        break;
    }

    return Scaffold(
      appBar: AppBarCasheva(
        title: 'Dashboard ${activeRole.shortLabel}',
      ),
      drawer: const AppDrawer(currentRoute: '/'),
      body: SafeArea(child: dashboardContent),
    );
  }
}
