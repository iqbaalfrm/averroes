import '../../services/api_client.dart';
import 'models/crypto_asset.dart';

class ScreenerRepository {
  Future<List<CryptoAsset>> fetchAssets() async {
    try {
      final response = await ApiClient.get('/screener');
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      if (rows.isEmpty) return [];

      final assets = <CryptoAsset>[];
      for (var i = 0; i < rows.length; i++) {
        assets.add(_mapRow(rows[i], i + 1));
      }
      return assets;
    } catch (_) {
      return [];
    }
  }

  CryptoAsset _mapRow(Map<String, dynamic> row, int index) {
    final priceUsd = _formatUsd(row['price_usd']);
    final marketCap = _formatBigNumber(row['market_cap_usd']);
    final explanation = row['explanation'] as String? ?? 'Informasi detail belum tersedia.';

    return CryptoAsset(
      no: index,
      code: (row['code'] as String? ?? '').toUpperCase(),
      name: row['name'] as String? ?? '',
      status: row['status'] as String? ?? 'Proses',
      price: priceUsd,
      marketCap: marketCap,
      explanation: explanation,
      details: _parseDetails(row['details']),
    );
  }

  String _formatUsd(dynamic value) {
    if (value == null) return '-';
    final numVal = (value as num?)?.toDouble();
    if (numVal == null) return '-';
    if (numVal >= 1) {
      return '\$${numVal.toStringAsFixed(numVal < 10 ? 2 : 0)}';
    }
    if (numVal >= 0.01) {
      return '\$${numVal.toStringAsFixed(2)}';
    }
    return '\$${numVal.toStringAsFixed(6)}';
  }

  String _formatBigNumber(dynamic value) {
    if (value == null) return '-';
    final numVal = (value as num?)?.toDouble();
    if (numVal == null) return '-';
    if (numVal >= 1e12) {
      return '\$${(numVal / 1e12).toStringAsFixed(2)}T';
    } else if (numVal >= 1e9) {
      return '\$${(numVal / 1e9).toStringAsFixed(1)}B';
    } else if (numVal >= 1e6) {
      return '\$${(numVal / 1e6).toStringAsFixed(0)}M';
    } else if (numVal >= 1e3) {
      return '\$${(numVal / 1e3).toStringAsFixed(0)}K';
    }
    return '\$${numVal.toStringAsFixed(0)}';
  }

  List<String> _parseDetails(dynamic details) {
    if (details is List) {
      return details.map((item) => item.toString()).toList();
    }
    if (details is Map) {
      return details.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .toList();
    }
    if (details is String && details.trim().isNotEmpty) {
      return [details];
    }
    return ['Informasi detail belum tersedia'];
  }
}
