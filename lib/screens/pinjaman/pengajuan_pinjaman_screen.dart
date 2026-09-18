import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/pinjaman.dart';
import '../../providers/auth_provider.dart';
import '../../providers/pinjaman_provider.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Pengajuan Pinjaman USIPA dengan Simulator Interaktif
class PengajuanPinjamanScreen extends StatefulWidget {
  const PengajuanPinjamanScreen({super.key});

  @override
  State<PengajuanPinjamanScreen> createState() => _PengajuanPinjamanScreenState();
}

class _PengajuanPinjamanScreenState extends State<PengajuanPinjamanScreen> {
  final _nominalController = TextEditingController(text: '10000000');
  final _catatanController = TextEditingController();
  int _selectedTenor = 12;
  double _nominal = 10000000;
  bool _setujuSyarat = true;

  final List<int> _tenorOptions = [6, 12, 18, 24, 30, 36];

  @override
  void initState() {
    super.initState();
    _nominalController.addListener(() {
      final val = double.tryParse(_nominalController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      if (val != _nominal) {
        setState(() {
          _nominal = val;
        });
      }
    });
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _submitPengajuan() async {
    if (_nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal pinjaman harus lebih dari Rp 0')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final pinjaman = context.read<PinjamanProvider>();
    final anggotaId = auth.currentUser?.anggota?.id ?? auth.currentUser?.id ?? 'ANG-001';

    final success = await pinjaman.createLoan(
      anggotaId: anggotaId,
      nominal: _nominal,
      tenorBulan: _selectedTenor,
      catatan: _catatanController.text.trim().isNotEmpty ? _catatanController.text.trim() : null,
    );

    if (success && mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.success),
              SizedBox(width: 8),
              Text('Pengajuan Terkirim'),
            ],
          ),
          content: Text(
            'Pengajuan USIPA sebesar ${CurrencyFormatter.formatRp(_nominal)} dengan tenor $_selectedTenor bulan berhasil diajukan dan masuk ke antrean verifikasi Juru Bayar.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/pinjaman');
              },
              child: const Text('Lihat Riwayat'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinjaman = context.watch<PinjamanProvider>();
    final simulasi = SimulasiPinjaman(nominal: _nominal, tenorBulan: _selectedTenor);

    return Scaffold(
      appBar: const AppBarCasheva(title: 'Pengajuan USIPA'),
      drawer: const AppDrawer(currentRoute: '/pengajuan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Plafon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A2F), Color(0xFF2D5A43)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Formulir Pengajuan Pinjaman USIPA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Plafon maksimal sesuai golongan kepangkatan TNI AD dengan suku bunga 1% flat/bulan (12%/tahun).',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form Input
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nominal Pinjaman (Rp)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nominalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.monetization_on_outlined, size: 20),
                      hintText: '10.000.000',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [5000000, 10000000, 15000000, 20000000, 30000000].map((quickNom) {
                      return ActionChip(
                        label: Text(CurrencyFormatter.formatRp(quickNom), style: const TextStyle(fontSize: 11)),
                        onPressed: () {
                          _nominalController.text = quickNom.toString();
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Jangka Waktu / Tenor (Bulan)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tenorOptions.map((t) {
                      final isSelected = _selectedTenor == t;
                      return ChoiceChip(
                        label: Text('$t Bulan'),
                        selected: isSelected,
                        selectedColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedTenor = t);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Keperluan Pinjaman (Opsional)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _catatanController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Biaya pendidikan anak / renovasi rumah dinas',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card Hasil Simulasi Pinjaman
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calculate_rounded, color: AppTheme.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Rincian Simulasi Angsuran',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildSimulasiRow('Pokok Bulanan', CurrencyFormatter.formatRp(simulasi.pokokBulanan)),
                  _buildSimulasiRow('Jasa / Bunga Bulanan (1%)', CurrencyFormatter.formatRp(simulasi.bungaBulanan)),
                  const Divider(height: 16),
                  _buildSimulasiRow(
                    'Total Angsuran per Bulan',
                    CurrencyFormatter.formatRp(simulasi.totalBulanan),
                    isHighlight: true,
                  ),
                  _buildSimulasiRow('Total Pembayaran', CurrencyFormatter.formatRp(simulasi.totalBayar)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Checkbox Persetujuan Potong Gaji
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _setujuSyarat,
              onChanged: (v) => setState(() => _setujuSyarat = v ?? false),
              title: const Text(
                'Saya menyetujui pemotongan gaji pokok & tunkin secara otomatis oleh Juru Bayar satuan setiap tanggal gajian.',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 20),

            // Tombol Kirim Pengajuan
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _setujuSyarat && !pinjaman.isLoading ? _submitPengajuan : null,
                child: pinjaman.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Kirim Pengajuan Pinjaman',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulasiRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlight ? 13 : 12,
              fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w500,
              color: isHighlight ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 15 : 12,
              fontWeight: FontWeight.w800,
              color: isHighlight ? AppTheme.primary : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
