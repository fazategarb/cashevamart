/// Algoritma Hierarki Pangkat Militer TNI AD & Format Nama Dinas
/// Ported 1:1 dari website casheva (`casheva-data.ts`)
class MilitaryRanks {
  MilitaryRanks._();

  /// Format Pangkat dan Korps sesuai aturan dinas TNI AD
  /// 1. PATI (Perwira Tinggi) -> Selalu diakhiri "TNI", tidak memakai korps
  /// 2. PAMEN & PAMA (Perwira Menengah & Pertama) -> Digabungkan korps (misal: Kolonel Inf, Kapten Czi)
  /// 3. BA / TA / PNS -> HANYA pangkat saja, korps dihilangkan
  static String formatPangkatKorps(
    String? pangkat,
    String? korps, [
    String? kategori,
  ]) {
    if (pangkat == null || pangkat.trim() == '-' || pangkat.trim().isEmpty) {
      return '-';
    }
    var p = pangkat.trim();
    final c = korps != null && korps.trim() != '-' && korps.trim() != 'NONE'
        ? korps.trim()
        : '';
    final kat = (kategori ?? '').toUpperCase();

    // 1. PATI (Perwira Tinggi) -> Selalu diakhiri "TNI", korps diganti menjadi "TNI"
    final isPati = kat == 'PATI' ||
        [
          'Brigjen',
          'Mayjen',
          'Letjen',
          'Jenderal',
          'Brigadir Jenderal',
          'Mayor Jenderal',
          'Letnan Jenderal'
        ].any((pat) => p.toLowerCase().startsWith(pat.toLowerCase()) || p.toLowerCase().contains(pat.toLowerCase()));

    if (isPati) {
      p = p
          .replaceAll(
            RegExp(
              r'\s+(Inf|Kav|Arm|Arh|Czi|Cpm|Cba|Ckm|Cpl|Cke|Chk|Caj|Cku|Ctp|Cpn|TNI)\b',
              caseSensitive: false,
            ),
            '',
          )
          .trim();
      return '$p TNI';
    }

    // 2. PAMEN & PAMA (Perwira Menengah & Pertama) -> Digabungkan dengan Korps
    final isPerwira = kat == 'PAMEN' ||
        kat == 'PAMA' ||
        [
          'Kolonel',
          'Letkol',
          'Mayor',
          'Kapten',
          'Lettu',
          'Letda',
          'Letnan Kolonel',
          'Letnan Satu',
          'Letnan Dua'
        ].any((per) => p.toLowerCase().startsWith(per.toLowerCase()));

    if (isPerwira) {
      if (c.isEmpty) return p;
      if (!p.toLowerCase().contains(c.toLowerCase())) {
        return '$p $c';
      }
      return p;
    }

    // 3. BA / TA / PNS -> HANYA pangkat saja, hilangkan korps jika ada
    p = p
        .replaceAll(
          RegExp(
            r'\s+(Inf|Kav|Arm|Arh|Czi|Cpm|Cba|Ckm|Cpl|Cke|Chk|Caj|Cku|Ctp|Cpn|TNI)\b',
            caseSensitive: false,
          ),
          '',
        )
        .trim();
    return p;
  }

  /// Membersihkan prefix pangkat dari nama personel
  static String cleanNamaPersonel(String? nama) {
    if (nama == null || nama.trim().isEmpty) return '';
    var n = nama.trim();

    final rankPrefixRegex = RegExp(
      r'^(?:(?:Jenderal|Letnan\s+Jenderal|Letjen|Mayor\s+Jenderal|Mayjen|Brigadir\s+Jenderal|Brigjen|Kolonel|Letnan\s+Kolonel|Letkol|Mayor|Kapten|Letnan\s+Satu|Lettu|Letnan\s+Dua|Letda|Pembantu\s+Letnan\s+Satu|Peltu|Pembantu\s+Letnan\s+Dua|Pelda|Sersan\s+Mayor|Serma|Sersan\s+Kepala|Serka|Sersan\s+Satu|Sertu|Sersan\s+Dua|Serda|Kopral\s+Kepala|Kopka|Kopral\s+Satu|Koptu|Kopral\s+Dua|Kopda|Prajurit\s+Kepala|Praka|Prajurit\s+Satu|Pratu|Prajurit\s+Dua|Prada|PNS(?:\s+(?:IV|III|II|I)\/[A-Ea-e])?|PPPK)\s*(?:(?:TNI\s*AD|TNI|Inf|Kav|Arm|Arh|Czi|Cpm|Cba|Ckm|Cpl|Cke|Chk|Caj|Cku|Ctp|Cpn)\b)?\s*)+',
      caseSensitive: false,
    );

    n = n.replaceAll(rankPrefixRegex, '').trim();
    return n.isNotEmpty ? n : nama.trim();
  }

  /// Format Nama Lengkap Dinas Resmi TNI AD (Pangkat Korps Nama)
  static String formatNamaLengkapDinas(
    String? nama,
    String? pangkat,
    String? korps, [
    String? kategori,
  ]) {
    var cleanNama = cleanNamaPersonel(nama);
    if (cleanNama.isEmpty) return '-';

    if (cleanNama.toLowerCase() == 'anggota koperasi') {
      cleanNama = 'Personel TNI AD';
    }

    final pkt = formatPangkatKorps(pangkat, korps, kategori);
    if (pkt == '-' || pkt.isEmpty) return cleanNama;

    if (cleanNama.toLowerCase().startsWith(pkt.toLowerCase())) {
      return cleanNama;
    }

    return '$pkt $cleanNama'.trim();
  }

  /// Menghitung bobot numerik hierarki pangkat personel militer TNI AD dan PNS/ASN
  /// Dari yang tertinggi (Jenderal: 940) sampai terendah (PNS I/A: 110, PPPK: 100).
  static int getPangkatRankWeight({
    dynamic pangkatInput,
    String? kategoriInput,
    String? namaPersonelInput,
  }) {
    // 1. Jika pangkatInput objek dengan kodePkt numerik resmi TNI AD
    if (pangkatInput is Map) {
      final kode = pangkatInput['kodePkt'];
      if (kode is num) return (kode * 10).toInt();
    }

    // 2. Jika pangkatInput numerik langsung
    if (pangkatInput is num) {
      return (pangkatInput * 10).toInt();
    }

    // 3. Ekstrak string pangkat dan gabungkan petunjuk teks
    final strPangkat = (pangkatInput is String) ? pangkatInput.trim() : '';
    final strKategori = (kategoriInput ?? '').toUpperCase();
    final strNama = (namaPersonelInput ?? '').trim();

    final combined = '$strPangkat $strNama'.trim();
    if (combined.isEmpty && strKategori.isNotEmpty) {
      if (strKategori == 'PATI') return 900;
      if (strKategori == 'PAMEN') return 800;
      if (strKategori == 'PAMA') return 700;
      if (strKategori == 'BINTARA') return 600;
      if (strKategori == 'BATA_ASN' || strKategori == 'TAMTAMA') return 500;
      if (strKategori == 'PNS') return 200;
    }

    // Hierarki Pangkat Berdasarkan Pola Regex (Urutan dari tertinggi ke terendah)
    // Perwira Tinggi (Pati)
    if (RegExp(r'\b(?:Jenderal|Jendral|Jend)\b', caseSensitive: false).hasMatch(combined)) return 940;
    if (RegExp(r'\b(?:Letjen|Letnan\s+Jenderal|Letnan\s+Jendral)\b', caseSensitive: false).hasMatch(combined)) return 930;
    if (RegExp(r'\b(?:Mayjen|Mayor\s+Jenderal|Mayor\s+Jendral)\b', caseSensitive: false).hasMatch(combined)) return 920;
    if (RegExp(r'\b(?:Brigjen|Brigadir\s+Jenderal|Brigadir\s+Jendral)\b', caseSensitive: false).hasMatch(combined)) return 910;

    // Perwira Menengah (Pamen)
    if (RegExp(r'\b(?:Letkol|Letnan\s+Kolonel)\b', caseSensitive: false).hasMatch(combined)) return 820;
    if (RegExp(r'\bKolonel\b', caseSensitive: false).hasMatch(combined)) return 830;
    if (RegExp(r'\b(?:Serma|Sersan\s+Mayor)\b', caseSensitive: false).hasMatch(combined)) return 640;
    if (RegExp(r'\bMayor\b', caseSensitive: false).hasMatch(combined) &&
        !RegExp(r'\b(?:Jenderal|Jendral)\b', caseSensitive: false).hasMatch(combined)) {
      return 810;
    }

    // Perwira Pertama (Pama)
    if (RegExp(r'\b(?:Kapten|Kapt)\b', caseSensitive: false).hasMatch(combined)) return 730;
    if (RegExp(r'\b(?:Lettu|Letnan\s+Satu)\b', caseSensitive: false).hasMatch(combined)) return 720;
    if (RegExp(r'\b(?:Letda|Letnan\s+Dua)\b', caseSensitive: false).hasMatch(combined)) return 710;

    // Bintara
    if (RegExp(r'\b(?:Peltu|Pembantu\s+Letnan\s+Satu)\b', caseSensitive: false).hasMatch(combined)) return 660;
    if (RegExp(r'\b(?:Pelda|Pembantu\s+Letnan\s+Dua)\b', caseSensitive: false).hasMatch(combined)) return 650;
    if (RegExp(r'\b(?:Serka|Sersan\s+Kepala)\b', caseSensitive: false).hasMatch(combined)) return 630;
    if (RegExp(r'\b(?:Sertu|Sersan\s+Satu)\b', caseSensitive: false).hasMatch(combined)) return 620;
    if (RegExp(r'\b(?:Serda|Sersan\s+Dua)\b', caseSensitive: false).hasMatch(combined)) return 610;

    // Tamtama
    if (RegExp(r'\b(?:Kopka|Kopral\s+Kepala)\b', caseSensitive: false).hasMatch(combined)) return 560;
    if (RegExp(r'\b(?:Koptu|Kopral\s+Satu)\b', caseSensitive: false).hasMatch(combined)) return 550;
    if (RegExp(r'\b(?:Kopda|Kopral\s+Dua)\b', caseSensitive: false).hasMatch(combined)) return 540;
    if (RegExp(r'\b(?:Praka|Prajurit\s+Kepala)\b', caseSensitive: false).hasMatch(combined)) return 530;
    if (RegExp(r'\b(?:Pratu|Prajurit\s+Satu)\b', caseSensitive: false).hasMatch(combined)) return 520;
    if (RegExp(r'\b(?:Prada|Prajurit\s+Dua)\b', caseSensitive: false).hasMatch(combined)) return 510;

    // PNS / ASN Golongan IV
    if (RegExp(r'\b(?:PNS\s+IV[\s\/-]*E|Pembina\s+Utama(?!\s+M))\b', caseSensitive: false).hasMatch(combined)) return 450;
    if (RegExp(r'\b(?:PNS\s+IV[\s\/-]*D|Pembina\s+Utama\s+Madya)\b', caseSensitive: false).hasMatch(combined)) return 440;
    if (RegExp(r'\b(?:PNS\s+IV[\s\/-]*C|Pembina\s+Utama\s+Muda)\b', caseSensitive: false).hasMatch(combined)) return 430;
    if (RegExp(r'\b(?:PNS\s+IV[\s\/-]*B|Pembina\s+T(?:k|ingkat)\s+I)\b', caseSensitive: false).hasMatch(combined)) return 420;
    if (RegExp(r'\b(?:PNS\s+IV[\s\/-]*A|Pembina\b)', caseSensitive: false).hasMatch(combined)) return 410;

    // PNS / ASN Golongan III
    if (RegExp(r'\b(?:PNS\s+III[\s\/-]*D|Penata\s+T(?:k|ingkat)\s+I)\b', caseSensitive: false).hasMatch(combined)) return 340;
    if (RegExp(r'\b(?:PNS\s+III[\s\/-]*C|Penata\b)', caseSensitive: false).hasMatch(combined)) return 330;
    if (RegExp(r'\b(?:PNS\s+III[\s\/-]*B|Penata\s+Muda\s+T(?:k|ingkat)\s+I)\b', caseSensitive: false).hasMatch(combined)) return 320;
    if (RegExp(r'\b(?:PNS\s+III[\s\/-]*A|Penata\s+Muda\b)', caseSensitive: false).hasMatch(combined)) return 310;

    // PNS / ASN Golongan II
    if (RegExp(r'\b(?:PNS\s+II[\s\/-]*D|Pengatur\s+T(?:k|ingkat)\s+I)\b', caseSensitive: false).hasMatch(combined)) return 240;
    if (RegExp(r'\b(?:PNS\s+II[\s\/-]*C|Pengatur\b)', caseSensitive: false).hasMatch(combined)) return 230;
    if (RegExp(r'\b(?:PNS\s+II[\s\/-]*B|Pengatur\s+Muda\s+T(?:k|ingkat)\s+I)\b', caseSensitive: false).hasMatch(combined)) return 220;
    if (RegExp(r'\b(?:PNS\s+II[\s\/-]*A|Pengatur\s+Muda\b)', caseSensitive: false).hasMatch(combined)) return 210;

    // PNS / ASN Golongan I
    if (RegExp(r'\b(?:PNS\s+I[\s\/-]*D|Juru\s+T(?:k|ingkat)\s+I)\b', caseSensitive: false).hasMatch(combined)) return 140;
    if (RegExp(r'\b(?:PNS\s+I[\s\/-]*C|Juru\b)', caseSensitive: false).hasMatch(combined)) return 130;
    if (RegExp(r'\b(?:PNS\s+I[\s\/-]*B|Juru\s+Muda\s+T(?:k|ingkat)\s+I)\b', caseSensitive: false).hasMatch(combined)) return 120;
    if (RegExp(r'\b(?:PNS\s+I[\s\/-]*A|Juru\s+Muda\b)', caseSensitive: false).hasMatch(combined)) return 110;

    // PPPK & PNS Umum
    if (RegExp(r'\bPPPK\b', caseSensitive: false).hasMatch(combined)) return 100;
    if (RegExp(r'\b(?:PNS|ASN)\b', caseSensitive: false).hasMatch(combined)) return 200;

    // Fallback kategori
    if (strKategori.contains('PATI')) return 900;
    if (strKategori.contains('PAMEN')) return 800;
    if (strKategori.contains('PAMA')) return 700;
    if (strKategori.contains('BINTARA')) return 600;
    if (strKategori.contains('BATA') || strKategori.contains('TAMTAMA')) return 500;
    if (strKategori.contains('PNS') || strKategori.contains('ASN')) return 200;

    return 0;
  }

  /// Komparator untuk mengurutkan personel dari pangkat tertinggi ke terendah
  static int comparePersonelByPangkat(dynamic a, dynamic b) {
    String getPkt(dynamic x) =>
        x?.pangkat?.toString() ??
        x?.anggota?.pangkat?.toString() ??
        '';
    String getKat(dynamic x) =>
        x?.kategoriPangkat?.toString() ??
        x?.kategori?.toString() ??
        '';
    String getNm(dynamic x) =>
        x?.nama?.toString() ??
        x?.namaLengkap?.toString() ??
        x?.anggota?.nama?.toString() ??
        '';

    final weightA = getPangkatRankWeight(
      pangkatInput: getPkt(a),
      kategoriInput: getKat(a),
      namaPersonelInput: getNm(a),
    );
    final weightB = getPangkatRankWeight(
      pangkatInput: getPkt(b),
      kategoriInput: getKat(b),
      namaPersonelInput: getNm(b),
    );

    if (weightB != weightA) {
      return weightB - weightA; // Tertinggi dulu (descending)
    }

    final nameA = cleanNamaPersonel(getNm(a));
    final nameB = cleanNamaPersonel(getNm(b));
    return nameA.compareTo(nameB);
  }

  /// Mengurutkan list personel berdasarkan hierarki pangkat
  static List<T> sortByPangkat<T>(List<T> list) {
    final copy = List<T>.from(list);
    copy.sort((a, b) => comparePersonelByPangkat(a, b));
    return copy;
  }
}
