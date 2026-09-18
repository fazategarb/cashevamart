import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/toko.dart';
import '../../services/toko_service.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Unit Layanan Gadai & SBG (Surat Bukti Gadai)
class GadaiScreen extends StatefulWidget {
  const GadaiScreen({super.key});

  @override
  State<GadaiScreen> createState() => _GadaiScreenState();
}

class _GadaiScreenState extends State<GadaiScreen> {
  List<GadaiItem> _list = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await TokoService.instance.getGadaiList();
    if (mounted) {
      setState(() {
        _list = res;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCasheva(title: 'Unit Gadai & SBG'),
      drawer: const AppDrawer(currentRoute: '/gadai'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final item = _list[idx];
                Color statusBg = const Color(0xFFDCFCE7);
                Color statusFg = const Color(0xFF15803D);

                if (item.status == StatusGadai.jatuhTempoLelang) {
                  statusBg = const Color(0xFFFEE2E2);
                  statusFg = const Color(0xFFB91C1C);
                } else if (item.status == StatusGadai.barangTerjualLelang) {
                  statusBg = const Color(0xFFE0E7FF);
                  statusFg = const Color(0xFF4338CA);
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.nomorSbg, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                            child: Text(item.status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusFg)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(item.foto, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.namaBarang, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('Nasabah: ${item.anggotaNama} (${item.anggotaNrp})', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                Text(item.spesifikasi, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Nilai Taksiran: ${CurrencyFormatter.formatRp(item.nilaiTaksiran)}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          Text('Pinjaman: ${CurrencyFormatter.formatRp(item.uangPinjaman)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Jasa Titip: ${CurrencyFormatter.formatRp(item.jasaTitipBulan)}/bln', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          Text('Jatuh Tempo: ${item.jatuhTempo}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.danger)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
