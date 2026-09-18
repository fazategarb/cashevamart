import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'config/router.dart';
import 'providers/auth_provider.dart';
import 'providers/pinjaman_provider.dart';
import 'providers/simpanan_provider.dart';
import 'providers/toko_provider.dart';
import 'providers/notifikasi_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style matching dark military theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CashevaApp());
}

class CashevaApp extends StatelessWidget {
  const CashevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PinjamanProvider()),
        ChangeNotifierProvider(create: (_) => SimpananProvider()),
        ChangeNotifierProvider(create: (_) => TokoProvider()),
        ChangeNotifierProvider(create: (_) => NotifikasiProvider()),
      ],
      child: MaterialApp.router(
        title: 'Casheva — Koperasi Simpan Pinjam TNI AD',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
