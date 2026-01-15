import '../../services/api_client.dart';
import 'models/crypto_market_item.dart';

class MarketRepository {
  Future<List<CryptoMarketItem>> fetchMarketCoins() async {
    try {
      final response = await ApiClient.get('/market');
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);

      return rows.map(CryptoMarketItem.fromSupabaseRow).toList();
    } catch (_) {
      return [];
    }
  }
}
