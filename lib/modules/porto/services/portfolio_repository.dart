import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/portfolio_holding.dart';

class PortfolioRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool get isGuest => _supabase.auth.currentUser == null;
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // READ
  Future<List<PortfolioHolding>> getHoldings() async {
    if (isGuest) {
      return _getDummyHoldings();
    }

    try {
      final response = await _supabase
          .from('portfolio_holdings')
          .select()
          .order('created_at', ascending: true);
          
      final data = List<Map<String, dynamic>>.from(response);
      return data.map((json) => PortfolioHolding.fromJson(json)).toList();
    } catch (e) {
      print('Repo: Fetch Error: $e');
      rethrow;
    }
  }

  // CREATE
  Future<void> addHolding({
    required String coinId,
    required String symbol,
    required String name,
    required double amount,
    double? avgBuyPrice,
    String? notes,
  }) async {
    if (isGuest) throw Exception('Login required');
    if (currentUserId == null) throw Exception('No User ID');

    try {
      await _supabase.from('portfolio_holdings').insert({
        'user_id': currentUserId,
        'coin_id': coinId,
        'symbol': symbol,
        'name': name,
        'amount': amount,
        'avg_buy_price': avgBuyPrice,
        'notes': notes,
      });
    } catch (e) {
      print('Repo: Insert Error: $e');
      rethrow;
    }
  }

  // UPDATE
  Future<void> updateHolding(String id, {
    required double amount,
    double? avgBuyPrice,
    String? notes,
  }) async {
    if (isGuest) throw Exception('Login required');

    try {
      await _supabase.from('portfolio_holdings').update({
        'amount': amount,
        'avg_buy_price': avgBuyPrice,
        'notes': notes,
      }).eq('id', id);
    } catch (e) {
      print('Repo: Update Error: $e');
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteHolding(String id) async {
    if (isGuest) throw Exception('Login required');

    try {
      await _supabase.from('portfolio_holdings').delete().eq('id', id);
    } catch (e) {
      print('Repo: Delete Error: $e');
      rethrow;
    }
  }

  // DUMMY DATA FOR GUEST
  List<PortfolioHolding> _getDummyHoldings() {
    final now = DateTime.now();
    return [
      PortfolioHolding(
        id: 'dummy_1',
        userId: 'guest',
        coinId: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
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
        amount: 1000,
        avgBuyPrice: 5000,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
