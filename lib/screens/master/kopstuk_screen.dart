import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../widgets/app_bar_casheva.dart';
import '../../widgets/app_drawer.dart';

/// Screen Pengaturan Kop Surat Dinas Kopstuk & Tajuk TTD Pejabat
class KopstukScreen extends StatefulWidget {
  const KopstukScreen({super.key});

  @override
  State<KopstukScreen> createState() => _KopstukScreenState();
}

class _KopstukScreenState extends State<KopstukScreen> {
  final _satuanCtrl = TextEditingController(text: 'KOMANDO DAERAH MILITER IV/DIPONEGORO');
  final _balakCtrl = TextEditingController(text: 'INFORMASI DAN PENGOLAHAN DATA');
  final _koperasiCtrl = TextEditingController(text: 'PRIMER KOPERASI KARTIKA INFOLAHTADAM IV/DIPONEGORO');
  final _alamatCtrl = TextEditingController(text: 'Jl. Perintis Kemerdekaan, Watugong, Semarang');
  final _telpCtrl = TextEditingController(text: '(024) 7472249');

  final _pejabatKeprimCtrl = TextEditingController(text: 'Dedi Kurnia');
  final _pangkatKeprimCtrl = TextEditingController(text: 'Letnan Kolonel Cba');
  final _nrpKeprimCtrl = TextEditingController(text: '11020033');

  String _selectedLogoType = 'primkop'; // 'primkop', 'emblem'
  bool _showLogo = true;

  @override
  void dispose() {
    _satuanCtrl.dispose();
    _balakCtrl.dispose();
    _koperasiCtrl.dispose();
    _alamatCtrl.dispose();
    _telpCtrl.dispose();
    _pejabatKeprimCtrl.dispose();
    _pangkatKeprimCtrl.dispose();
    _nrpKeprimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCasheva(title: 'Kopstuk & Tajuk TTD'),
      drawer: const AppDrawer(currentRoute: '/kopstuk'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Kop Surat
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Preview Kop Surat Resmi (Kopstuk)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_showLogo) ...[
                          Container(
                            width: 44,
                            height: 44,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Icon(
                              _selectedLogoType == 'primkop'
                                  ? Icons.military_tech_rounded
                                  : (_selectedLogoType == 'emblem'
                                      ? Icons.shield_rounded
                                      : Icons.account_balance_rounded),
                              color: AppTheme.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_satuanCtrl.text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5)),
                              Text(_koperasiCtrl.text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 9.5, letterSpacing: 0.3)),
                              Text('${_alamatCtrl.text}, Telp: ${_telpCtrl.text}', style: const TextStyle(fontSize: 8.5, color: AppTheme.textSecondary)),
                              const SizedBox(height: 6),
                              Container(height: 1.5, color: Colors.black),
                              const SizedBox(height: 1),
                              Container(height: 0.5, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form Pengaturan Logo Dinamis
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Pengaturan Logo Kop Surat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Divider(height: 20),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tampilkan Logo Satuan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Tampilkan lambang di sisi kiri kop dinas', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    value: _showLogo,
                    activeColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _showLogo = val),
                  ),
                  const SizedBox(height: 8),
                  const Text('Pilih Lambang Logo Kop:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLogoOption('primkop', 'Primkop TNI', Icons.military_tech_rounded),
                      const SizedBox(width: 8),
                      _buildLogoOption('emblem', 'Casheva Emblem', Icons.shield_rounded),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form Edit Kopstuk
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2. Format Kop Surat Satuan (Kopstuk)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Divider(height: 20),
                  _buildField('Nama Satuan Komando / Kotama', _satuanCtrl),
                  _buildField('Nama Koperasi Primer', _koperasiCtrl),
                  _buildField('Alamat Kedudukan Dinas', _alamatCtrl),
                  _buildField('Nomor Telepon Dinas', _telpCtrl),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form Tajuk Tanda Tangan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('3. Tajuk Tanda Tangan Keprim', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Divider(height: 20),
                  _buildField('Nama Pejabat Kepala Primkopad', _pejabatKeprimCtrl),
                  _buildField('Pangkat & Korps Resmi', _pangkatKeprimCtrl),
                  _buildField('NRP Pejabat', _nrpKeprimCtrl),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                onPressed: () {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengaturan Kopstuk & Logo berhasil disimpan')),
                  );
                },
                child: const Text('Simpan Pengaturan Kopstuk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoOption(String type, String label, IconData icon) {
    final isSelected = _selectedLogoType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedLogoType = type),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary.withOpacity(0.08) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: isSelected ? AppTheme.primary : AppTheme.textSecondary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }
}
