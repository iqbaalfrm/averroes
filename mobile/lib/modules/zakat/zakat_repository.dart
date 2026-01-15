import '../../services/api_client.dart';

class ZakatRecord {
  final String id;
  final double totalAssetsIdr;
  final double goldPriceIdrPerGram;
  final double nishabIdr;
  final double zakatDueIdr;
  final String method;
  final DateTime createdAt;

  ZakatRecord({
    required this.id,
    required this.totalAssetsIdr,
    required this.goldPriceIdrPerGram,
    required this.nishabIdr,
    required this.zakatDueIdr,
    required this.method,
    required this.createdAt,
  });

  factory ZakatRecord.fromJson(Map<String, dynamic> json) {
    return ZakatRecord(
      id: json['id']?.toString() ?? '',
      totalAssetsIdr: (json['total_assets_idr'] as num?)?.toDouble() ?? 0.0,
      goldPriceIdrPerGram: (json['gold_price_idr_per_gram'] as num?)?.toDouble() ?? 0.0,
      nishabIdr: (json['nishab_idr'] as num?)?.toDouble() ?? 0.0,
      zakatDueIdr: (json['zakat_due_idr'] as num?)?.toDouble() ?? 0.0,
      method: json['method'] as String? ?? 'total_portfolio',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class ZakatRepository {
  Future<List<ZakatRecord>> fetchRecords(String userId) async {
    try {
      final response = await ApiClient.get('/zakat/records');
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      return rows.map(ZakatRecord.fromJson).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> calculate({
    required double totalAssetsIdr,
    required double goldPriceIdrPerGram,
  }) async {
    try {
      final response = await ApiClient.post('/zakat/calculate', data: {
        'total_assets_idr': totalAssetsIdr,
        'gold_price_idr_per_gram': goldPriceIdrPerGram,
      });
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
    } catch (_) {}
    return null;
  }

  Future<void> addRecord({
    required String userId,
    required double totalAssetsIdr,
    required double goldPriceIdrPerGram,
    required double nishabIdr,
    required double zakatDueIdr,
    required String method,
  }) async {
    await ApiClient.post('/zakat/records', data: {
      'total_assets_idr': totalAssetsIdr,
      'gold_price_idr_per_gram': goldPriceIdrPerGram,
      'nishab_idr': nishabIdr,
      'zakat_due_idr': zakatDueIdr,
      'method': method,
    });
  }
}
