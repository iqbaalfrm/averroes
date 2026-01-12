import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/portfolio_holding_model.dart';
import '../../domain/entities/portfolio_holding_entity.dart';

/// =============================================================================
/// PORTFOLIO REMOTE DATA SOURCE
/// =============================================================================
/// Handles all portfolio CRUD operations with Supabase

class PortfolioRemoteDataSource {
  final SupabaseClient _client;
  static const String _tableName = 'portfolio_holdings';

  PortfolioRemoteDataSource(this._client);

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================

  /// Get all holdings for current user
  Future<List<PortfolioHoldingModel>> getHoldings(String userId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('symbol', ascending: true);

      return (response as List)
          .map((json) => PortfolioHoldingModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat portfolio: $e');
    }
  }

  /// Get single holding by id
  Future<PortfolioHoldingModel?> getHoldingById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return PortfolioHoldingModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal memuat aset: $e');
    }
  }

  /// Get holding by symbol for a user
  Future<PortfolioHoldingModel?> getHoldingBySymbol({
    required String userId,
    required String symbol,
  }) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('symbol', symbol.toUpperCase())
          .maybeSingle();

      if (response == null) return null;
      return PortfolioHoldingModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mencari aset: $e');
    }
  }

  // ===========================================================================
  // CREATE OPERATIONS
  // ===========================================================================

  /// Add new holding
  Future<PortfolioHoldingModel> addHolding(PortfolioHoldingEntity holding) async {
    try {
      final model = PortfolioHoldingModel.fromEntity(holding);
      
      final response = await _client
          .from(_tableName)
          .insert(model.toInsertJson())
          .select()
          .single();

      return PortfolioHoldingModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') { // Unique violation
        throw Exception('Aset ${holding.symbol} sudah ada di portfolio');
      }
      throw Exception('Gagal menambahkan aset: ${e.message}');
    }
  }

  // ===========================================================================
  // UPDATE OPERATIONS
  // ===========================================================================

  /// Update existing holding
  Future<PortfolioHoldingModel> updateHolding(PortfolioHoldingEntity holding) async {
    try {
      if (holding.id == null) {
        throw Exception('ID holding tidak valid');
      }

      final model = PortfolioHoldingModel.fromEntity(holding);
      
      final response = await _client
          .from(_tableName)
          .update(model.toUpdateJson())
          .eq('id', holding.id!)
          .select()
          .single();

      return PortfolioHoldingModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('Aset ${holding.symbol} sudah ada di portfolio');
      }
      throw Exception('Gagal memperbarui aset: ${e.message}');
    }
  }

  /// Upsert holding (add if not exists, update if exists)
  Future<PortfolioHoldingModel> upsertHolding(PortfolioHoldingEntity holding) async {
    try {
      final model = PortfolioHoldingModel.fromEntity(holding);
      
      final response = await _client
          .from(_tableName)
          .upsert(
            {
              ...model.toInsertJson(),
              if (holding.id != null) 'id': holding.id,
            },
            onConflict: 'user_id,symbol',
          )
          .select()
          .single();

      return PortfolioHoldingModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menyimpan aset: $e');
    }
  }

  // ===========================================================================
  // DELETE OPERATIONS
  // ===========================================================================

  /// Delete holding by id
  Future<void> deleteHolding(String id) async {
    try {
      await _client
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus aset: $e');
    }
  }

  /// Delete holding by symbol for a user
  Future<void> deleteHoldingBySymbol({
    required String userId,
    required String symbol,
  }) async {
    try {
      await _client
          .from(_tableName)
          .delete()
          .eq('user_id', userId)
          .eq('symbol', symbol.toUpperCase());
    } catch (e) {
      throw Exception('Gagal menghapus aset: $e');
    }
  }

  // ===========================================================================
  // AGGREGATE OPERATIONS
  // ===========================================================================

  /// Get total portfolio value
  Future<double> getTotalValue(String userId) async {
    final holdings = await getHoldings(userId);
    return holdings.fold<double>(
      0,
      (sum, h) => sum + (h.amount * (h.avgBuyPriceIdr ?? 0)),
    );
  }
}
