/// Model untuk Aset Kripto dengan status syariah
/// Digunakan oleh Screener untuk menampilkan daftar aset kripto
/// yang sudah dianalisis berdasarkan prinsip syariah.
class CryptoAsset {
  final int no;
  final String code;
  final String name;
  final String status;
  final String price;
  final String marketCap;
  final String explanation;
  final List<String> details;

  const CryptoAsset({
    required this.no,
    required this.code,
    required this.name,
    required this.status,
    required this.price,
    required this.marketCap,
    required this.explanation,
    required this.details,
  });

  /// Factory constructor untuk membuat CryptoAsset dari row CSV
  /// 
  /// Format kolom CSV:
  /// 0: No
  /// 1: Aset Kripto (contoh: "Ethereum (ETH)")
  /// 2: Underlying
  /// 3: Nilai yang Jelas
  /// 4: Bisakah Diserah-terimakan
  /// 5: Yes/No Sharia
  factory CryptoAsset.fromCsvRow(List<dynamic> row) {
    // Parse nomor urut
    final no = int.tryParse(row[0].toString().trim()) ?? 0;

    // Parse nama aset dan kode
    final asetKripto = row[1].toString().trim();
    final (parsedName, parsedCode) = _parseNameAndCode(asetKripto);

    // Parse data kolom lainnya dengan null-safe
    final underlying = row.length > 2 ? row[2].toString().trim() : '';
    final nilaiYangJelas = row.length > 3 ? row[3].toString().trim() : '';
    final bisaSerahTerima = row.length > 4 ? row[4].toString().trim() : '';
    final shariahValue = row.length > 5 ? row[5].toString().trim() : '';

    // Map status syariah
    final status = _mapShariahStatus(shariahValue);

    // Buat explanation dari gabungan kolom
    final explanation = _buildExplanation(
      underlying: underlying,
      nilaiYangJelas: nilaiYangJelas,
      bisaSerahTerima: bisaSerahTerima,
    );

    // Buat details sebagai bullet points
    final details = _buildDetails(
      underlying: underlying,
      nilaiYangJelas: nilaiYangJelas,
      bisaSerahTerima: bisaSerahTerima,
    );

    return CryptoAsset(
      no: no,
      code: parsedCode,
      name: parsedName,
      status: status,
      price: '-', // Placeholder untuk market data
      marketCap: '-', // Placeholder untuk market data
      explanation: explanation,
      details: details,
    );
  }

  /// Parse nama dan kode dari string format "Nama (CODE)"
  static (String name, String code) _parseNameAndCode(String asetKripto) {
    // Pattern: "Nama Aset (CODE)" atau "Nama Aset"
    final regExp = RegExp(r'^(.+?)\s*\(([^)]+)\)\s*$');
    final match = regExp.firstMatch(asetKripto);

    if (match != null) {
      final name = match.group(1)?.trim() ?? asetKripto;
      final code = match.group(2)?.trim().toUpperCase() ?? '';
      return (name, code);
    }

    // Jika tidak ada tanda kurung, gunakan nama sebagai code juga
    return (asetKripto, asetKripto.toUpperCase());
  }

  /// Map nilai Yes/No/Grey ke status tampilan
  static String _mapShariahStatus(String value) {
    final cleanValue = value.trim().toLowerCase();

    if (cleanValue.startsWith('yes')) {
      return 'Halal';
    } else if (cleanValue.startsWith('no')) {
      return 'Risiko Tinggi'; // No = mengandung unsur riba/derivatif
    } else if (cleanValue == 'grey' || cleanValue == '?' || cleanValue == 'syubhat') {
      return 'Proses'; // Masih dalam kajian
    }

    return 'Proses'; // Default jika tidak jelas
  }

  /// Buat penjelasan singkat dari data CSV
  static String _buildExplanation({
    required String underlying,
    required String nilaiYangJelas,
    required String bisaSerahTerima,
  }) {
    final parts = <String>[];

    if (underlying.isNotEmpty) {
      parts.add(underlying);
    }
    if (nilaiYangJelas.isNotEmpty) {
      parts.add(nilaiYangJelas);
    }

    return parts.isNotEmpty
        ? parts.join('. ')
        : 'Informasi detail belum tersedia.';
  }

  /// Buat daftar detail sebagai bullet points
  static List<String> _buildDetails({
    required String underlying,
    required String nilaiYangJelas,
    required String bisaSerahTerima,
  }) {
    final details = <String>[];

    if (underlying.isNotEmpty) {
      details.add('Dasar: $underlying');
    }
    if (nilaiYangJelas.isNotEmpty) {
      details.add('Nilai: $nilaiYangJelas');
    }
    if (bisaSerahTerima.isNotEmpty) {
      details.add('Serah-terima: $bisaSerahTerima');
    }

    // Pastikan minimal ada satu detail
    if (details.isEmpty) {
      details.add('Informasi detail belum tersedia');
    }

    return details;
  }

  /// Cek apakah aset memiliki data yang valid
  bool get isValid => code.isNotEmpty && name.isNotEmpty;

  @override
  String toString() {
    return 'CryptoAsset(no: $no, code: $code, name: $name, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CryptoAsset && other.code == code && other.no == no;
  }

  @override
  int get hashCode => code.hashCode ^ no.hashCode;
}
