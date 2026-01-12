/// =============================================================================
/// PORTFOLIO HOLDING ENTITY - Domain Layer
/// =============================================================================

class PortfolioHoldingEntity {
  final String? id;
  final String userId;
  final String symbol;
  final String? name;
  final double amount;
  final double? avgBuyPriceIdr;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PortfolioHoldingEntity({
    this.id,
    required this.userId,
    required this.symbol,
    this.name,
    required this.amount,
    this.avgBuyPriceIdr,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  /// Hitung total nilai holding (amount * avgBuyPrice)
  double get totalValueIdr => amount * (avgBuyPriceIdr ?? 0);

  /// Symbol harus uppercase
  String get symbolFormatted => symbol.toUpperCase();

  PortfolioHoldingEntity copyWith({
    String? id,
    String? userId,
    String? symbol,
    String? name,
    double? amount,
    double? avgBuyPriceIdr,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PortfolioHoldingEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      avgBuyPriceIdr: avgBuyPriceIdr ?? this.avgBuyPriceIdr,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PortfolioHoldingEntity(symbol: $symbol, amount: $amount)';
  }
}
