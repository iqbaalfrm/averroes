import '../../../core/domain/entities/portfolio_holding_entity.dart';

class PortfolioHolding {
  final String id;
  final String userId;
  final String coinId;
  final String symbol;
  final String name;
  final double amount;
  final double? avgBuyPrice;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Local fields for UI (not in DB)
  double? currentPriceUsd;
  double? currentPriceIdr;

  PortfolioHolding({
    required this.id,
    required this.userId,
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.amount,
    this.avgBuyPrice,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.currentPriceUsd,
    this.currentPriceIdr,
  });

  // Mapper from Supabase JSON
  factory PortfolioHolding.fromJson(Map<String, dynamic> json) {
    return PortfolioHolding(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      coinId: json['coin_id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      avgBuyPrice: (json['avg_buy_price'] as num?)?.toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // To JSON for API (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'coin_id': coinId,
      'symbol': symbol,
      'name': name,
      'amount': amount,
      'avg_buy_price': avgBuyPrice,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper for UI
  double get totalValueIdr => amount * (currentPriceIdr ?? 0);
  double get totalValueUsd => amount * (currentPriceUsd ?? 0);
  
  double get profitLossIdr {
    if (avgBuyPrice == null || currentPriceIdr == null) return 0;
    // Assuming avgBuyPrice is in IDR for simplicity or we need currency field. 
    // Usually manual input implies local currency. Using IDR as default for avgBuyPrice.
    return (currentPriceIdr! - avgBuyPrice!) * amount;
  }

  /// Convert to Entity for backward compatibility (e.g. Zakat calculation)
  PortfolioHoldingEntity toEntity() {
    return PortfolioHoldingEntity(
      id: id,
      userId: userId,
      symbol: symbol,
      name: name,
      amount: amount,
      avgBuyPriceIdr: avgBuyPrice,
      note: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
