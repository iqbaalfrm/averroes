import '../../../services/api_client.dart';
import '../../../services/app_session_controller.dart';
import '../models/portfolio_holding.dart';
import 'package:get/get.dart';

class PortfolioRepository {
  final AppSessionController _session = Get.find<AppSessionController>();

  bool get isGuest => _session.isGuest.value;

  Future<List<PortfolioHolding>> getHoldings() async {
    if (isGuest) {
      return _getDummyHoldings();
    }

    try {
      final response = await ApiClient.get('/portfolio/assets');
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      return rows.map((json) => PortfolioHolding.fromJson(json)).toList();
    } catch (e) {
      print('Repo: Fetch Error: $e');
      return _getDummyHoldings();
    }
  }

  Future<void> addHolding({
    required String coinCode,
    required String coinName,
    required double amount,
    double? avgBuyPrice,
    String? notes,
  }) async {
    if (isGuest) throw Exception('Login required');

    await ApiClient.post('/portfolio/assets', data: {
      'coin_code': coinCode,
      'coin_name': coinName,
      'network': 'spot',
      'amount': amount,
      'avg_buy_price_usd': avgBuyPrice,
      'notes': notes,
    });
  }

  Future<void> updateHolding(
    String id, {
    required double amount,
    double? avgBuyPrice,
    String? notes,
  }) async {
    if (isGuest) throw Exception('Login required');

    await ApiClient.patch('/portfolio/assets/$id', data: {
      'amount': amount,
      'avg_buy_price_usd': avgBuyPrice,
      'notes': notes,
    });
  }

  Future<void> deleteHolding(String id) async {
    if (isGuest) throw Exception('Login required');

    await ApiClient.delete('/portfolio/assets/$id');
  }

  List<PortfolioHolding> _getDummyHoldings() {
    final now = DateTime.now();
    return [
      PortfolioHolding(
        id: 'dummy_1',
        userId: 'guest',
        coinId: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        network: 'spot',
        amount: 0.15,
        avgBuyPrice: 950000000,
        createdAt: now,
        updatedAt: now,
      ),
      PortfolioHolding(
        id: 'dummy_2',
        userId: 'guest',
        coinId: 'ethereum',
        symbol: 'ETH',
        name: 'Ethereum',
        network: 'spot',
        amount: 2.5,
        avgBuyPrice: 35000000,
        createdAt: now,
        updatedAt: now,
      ),
      PortfolioHolding(
        id: 'dummy_3',
        userId: 'guest',
        coinId: 'cardano',
        symbol: 'ADA',
        name: 'Cardano',
        network: 'spot',
        amount: 1000,
        avgBuyPrice: 5000,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
