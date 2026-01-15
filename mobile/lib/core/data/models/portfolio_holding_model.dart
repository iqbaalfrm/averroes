import '../../domain/entities/portfolio_holding_entity.dart';

/// =============================================================================
/// PORTFOLIO HOLDING MODEL - Data Layer
/// =============================================================================
/// Model untuk mapping data dari/ke Supabase portfolio_holdings table

class PortfolioHoldingModel extends PortfolioHoldingEntity {
  const PortfolioHoldingModel({
    super.id,
    required super.userId,
    required super.symbol,
    super.name,
    required super.amount,
    super.avgBuyPriceIdr,
    super.note,
    super.createdAt,
    super.updatedAt,
  });

  /// Factory dari Supabase JSON
  factory PortfolioHoldingModel.fromJson(Map<String, dynamic> json) {
    return PortfolioHoldingModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      symbol: (json['symbol'] ?? '').toString().toUpperCase(),
      name: json['name'],
      amount: (json['amount'] ?? 0).toDouble(),
      avgBuyPriceIdr: json['avg_buy_price_idr'] != null 
          ? (json['avg_buy_price_idr']).toDouble() 
          : null,
      note: json['note'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  /// Convert ke Map untuk insert (tanpa id, created_at, updated_at)
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'symbol': symbol.toUpperCase(),
      'name': name,
      'amount': amount,
      'avg_buy_price_idr': avgBuyPriceIdr,
      'note': note,
    };
  }

  /// Convert ke Map untuk update (tanpa user_id, created_at)
  Map<String, dynamic> toUpdateJson() {
    return {
      'symbol': symbol.toUpperCase(),
      'name': name,
      'amount': amount,
      'avg_buy_price_idr': avgBuyPriceIdr,
      'note': note,
    };
  }

  /// Factory dari Entity
  factory PortfolioHoldingModel.fromEntity(PortfolioHoldingEntity entity) {
    return PortfolioHoldingModel(
      id: entity.id,
      userId: entity.userId,
      symbol: entity.symbol.toUpperCase(),
      name: entity.name,
      amount: entity.amount,
      avgBuyPriceIdr: entity.avgBuyPriceIdr,
      note: entity.note,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
