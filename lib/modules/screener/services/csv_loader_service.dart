
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../models/crypto_asset.dart';

/// Service untuk memuat data CSV dari assets
/// 
/// Fitur:
/// - Support delimiter semicolon (;)
/// - Handle UTF-8 BOM
/// - Handle row kosong dan kolom tidak lengkap
/// - Error handling yang robust
class CsvLoaderService {
  /// Path default untuk file CSV aset kripto syariah
  static const String defaultCsvPath = 'assets/data/crypto_syariah.csv';

  /// Muat data crypto dari file CSV di assets
  /// 
  /// [path] - Path ke file CSV di assets (default: assets/data/crypto_syariah.csv)
  /// 
  /// Returns: List of [CryptoAsset] yang sudah di-parse dan di-filter
  /// 
  /// Throws: Exception jika file tidak ditemukan atau format tidak valid
  static Future<List<CryptoAsset>> loadCryptoAssets({
    String path = defaultCsvPath,
  }) async {
    try {
      // Baca file dari assets
      final String rawData = await rootBundle.loadString(path);

      // Parse CSV dan return hasil
      return _parseCsvData(rawData);
    } catch (e) {
      if (e.toString().contains('Unable to load asset')) {
        throw Exception(
          'File CSV tidak ditemukan: $path. '
          'Pastikan file sudah ditambahkan ke pubspec.yaml.',
        );
      }
      throw Exception('Gagal memuat data CSV: $e');
    }
  }

  /// Parse raw CSV string menjadi List of [CryptoAsset]
  static List<CryptoAsset> _parseCsvData(String rawData) {
    // Handle BOM (Byte Order Mark) untuk UTF-8
    String cleanData = _removeBom(rawData);

    // Normalize line endings
    cleanData = cleanData.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Konfigurasi parser CSV dengan delimiter semicolon
    const csvConverter = CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
      shouldParseNumbers: false, // Biarkan sebagai string untuk parsing manual
    );

    // Parse CSV
    final List<List<dynamic>> rows = csvConverter.convert(cleanData);

    if (rows.isEmpty) {
      return [];
    }

    // Skip header row (baris pertama)
    final dataRows = rows.skip(1);

    // Parse setiap row menjadi CryptoAsset
    final assets = <CryptoAsset>[];

    for (final row in dataRows) {
      // Skip row yang kosong atau tidak memiliki cukup kolom
      if (_isEmptyRow(row)) {
        continue;
      }

      // Pastikan minimal ada 2 kolom (No dan Aset Kripto)
      if (row.length < 2) {
        continue;
      }

      // Skip jika kolom No kosong (baris pemisah atau kosong)
      final noValue = row[0].toString().trim();
      if (noValue.isEmpty || int.tryParse(noValue) == null) {
        continue;
      }

      try {
        final asset = CryptoAsset.fromCsvRow(row);

        // Hanya tambahkan aset yang valid
        if (asset.isValid) {
          assets.add(asset);
        }
      } catch (e) {
        // Log error tapi lanjutkan parsing
        // ignore: avoid_print
        print('Warning: Gagal parse row $row: $e');
        continue;
      }
    }

    return assets;
  }

  /// Hapus BOM (Byte Order Mark) dari awal string
  /// BOM UTF-8: 0xEF 0xBB 0xBF
  static String _removeBom(String data) {
    if (data.isEmpty) return data;

    // UTF-8 BOM character
    const bomChar = '\uFEFF';

    if (data.startsWith(bomChar)) {
      return data.substring(1);
    }

    // Alternatif: cek byte sequence untuk BOM UTF-8
    if (data.codeUnits.isNotEmpty && data.codeUnits.first == 0xFEFF) {
      return data.substring(1);
    }

    return data;
  }

  /// Cek apakah row kosong (semua kolom kosong atau hanya whitespace)
  static bool _isEmptyRow(List<dynamic> row) {
    if (row.isEmpty) return true;

    return row.every((cell) {
      final value = cell?.toString().trim() ?? '';
      return value.isEmpty;
    });
  }

  /// Hitung statistik dari list aset
  static Map<String, int> calculateStats(List<CryptoAsset> assets) {
    int halalCount = 0;
    int prosesCount = 0;
    int risikoCount = 0;

    for (final asset in assets) {
      switch (asset.status) {
        case 'Halal':
          halalCount++;
          break;
        case 'Proses':
          prosesCount++;
          break;
        case 'Risiko Tinggi':
          risikoCount++;
          break;
      }
    }

    return {
      'halal': halalCount,
      'proses': prosesCount,
      'risiko': risikoCount,
      'total': assets.length,
    };
  }
}
