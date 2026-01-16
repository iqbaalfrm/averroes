import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';
import '../models/crypto_market_item.dart';
import '../services/coingecko_api_client.dart';

// ============================================================================
// COIN DETAIL CONTROLLER
// ============================================================================

class CoinDetailController extends GetxController {
  final CryptoMarketItem coin;
  
  CoinDetailController({required this.coin});

  final RxBool isChartLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedRange = '24H'.obs;
  final RxList<ChartPoint> chartPoints = <ChartPoint>[].obs;

  /// Cache untuk data chart: key = "coinId_days", value = (data, timestamp)
  static final Map<String, _CacheEntry> _chartCache = {};
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Guard untuk mencegah request ganda
  bool _isFetching = false;

  late final CoinGeckoApiClient _apiClient;

  @override
  void onInit() {
    super.onInit();
    _apiClient = CoinGeckoApiClient();
    fetchChart(selectedRange.value);
  }

  @override
  void onClose() {
    _apiClient.dispose();
    super.onClose();
  }

  /// Mapping timeframe ke days
  int _getDaysFromRange(String range) {
    switch (range) {
      case '24H':
        return 1;
      case '7D':
        return 7;
      case '30D':
        return 30;
      case '1Y':
        return 365;
      default:
        return 7;
    }
  }

  /// Fetch data chart dari API atau cache
  Future<void> fetchChart(String range) async {
    // Guard: cegah request ganda
    if (_isFetching) return;
    _isFetching = true;

    selectedRange.value = range;
    isChartLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final days = _getDaysFromRange(range);
    final cacheKey = '${coin.id}_$days';

    try {
      // Cek cache
      final cachedEntry = _chartCache[cacheKey];
      if (cachedEntry != null && !cachedEntry.isExpired) {
        chartPoints.assignAll(cachedEntry.data);
        isChartLoading.value = false;
        _isFetching = false;
        return;
      }

      // Fetch dari API
      final points = await _apiClient.fetchMarketChart(
        coinId: coin.id,
        days: days,
      );

      // Simpan ke cache
      _chartCache[cacheKey] = _CacheEntry(data: points);

      chartPoints.assignAll(points);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      // ignore: avoid_print
      print('Error fetching chart: $e');
    } finally {
      isChartLoading.value = false;
      _isFetching = false;
    }
  }

  /// Retry fetch setelah error
  void retry() {
    fetchChart(selectedRange.value);
  }

  /// Ubah range dan fetch ulang
  void changeRange(String range) {
    if (range == selectedRange.value) return;
    fetchChart(range);
  }

  // ===========================================================================
  // CHART HELPERS
  // ===========================================================================

  /// Dapatkan min dan max price untuk chart scaling
  double get minPrice {
    if (chartPoints.isEmpty) return 0;
    return chartPoints.map((p) => p.price).reduce((a, b) => a < b ? a : b);
  }

  double get maxPrice {
    if (chartPoints.isEmpty) return 0;
    return chartPoints.map((p) => p.price).reduce((a, b) => a > b ? a : b);
  }

  /// Hitung perubahan harga dari chart
  double get chartPriceChange {
    if (chartPoints.length < 2) return 0;
    final first = chartPoints.first.price;
    final last = chartPoints.last.price;
    return ((last - first) / first) * 100;
  }

  bool get isChartUp => chartPriceChange >= 0;
}

/// Cache entry dengan timestamp expiry
class _CacheEntry {
  final List<ChartPoint> data;
  final DateTime createdAt;

  _CacheEntry({required this.data}) : createdAt = DateTime.now();

  bool get isExpired {
    return DateTime.now().difference(createdAt) > CoinDetailController._cacheDuration;
  }
}

// ============================================================================
// COIN DETAIL VIEW
// ============================================================================

class CoinDetailView extends StatelessWidget {
  final CryptoMarketItem coin;

  const CoinDetailView({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CoinDetailController(coin: coin),
      tag: coin.id,
    );

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: Stack(
        children: [
          // Background decorations
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    MuamalahColors.mint.withAlpha(128),
                    MuamalahColors.mint.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    MuamalahColors.softBlue.withAlpha(102),
                    MuamalahColors.softBlue.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(controller),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildPriceSection(controller),
                        const SizedBox(height: 24),
                        _buildTimeframeChips(controller),
                        const SizedBox(height: 16),
                        _buildChartSection(controller),
                        const SizedBox(height: 24),
                        _buildStatsSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(CoinDetailController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: MuamalahColors.mint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                coin.code,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.primaryEmerald,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                Text(
                  coin.code,
                  style: const TextStyle(
                    fontSize: 13,
                    color: MuamalahColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (coin.marketCapRank != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: MuamalahColors.mint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '#${coin.marketCapRank}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.primaryEmerald,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PRICE SECTION
  // ===========================================================================

  Widget _buildPriceSection(CoinDetailController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Harga Saat Ini',
            style: TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                coin.priceUsdFormatted,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: coin.isUp ? MuamalahColors.halalBg : MuamalahColors.haramBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      coin.isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      size: 16,
                      color: coin.isUp ? MuamalahColors.halal : MuamalahColors.haram,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      coin.change24hFormatted,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: coin.isUp ? MuamalahColors.halal : MuamalahColors.haram,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            coin.priceIdrFormatted,
            style: const TextStyle(
              fontSize: 16,
              color: MuamalahColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TIMEFRAME CHIPS
  // ===========================================================================

  Widget _buildTimeframeChips(CoinDetailController controller) {
    final ranges = ['24H', '7D', '30D', '1Y'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: ranges.map((range) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: range != ranges.last ? 8 : 0,
              ),
              child: Obx(() {
                final isSelected = controller.selectedRange.value == range;
                return GestureDetector(
                  onTap: () => controller.changeRange(range),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? MuamalahColors.primaryEmerald : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? MuamalahColors.primaryEmerald
                            : MuamalahColors.glassBorder,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: MuamalahColors.primaryEmerald.withAlpha(51),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        range,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : MuamalahColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===========================================================================
  // CHART SECTION
  // ===========================================================================

  Widget _buildChartSection(CoinDetailController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Obx(() {
        // Loading state
        if (controller.isChartLoading.value) {
          return _buildChartLoading();
        }

        // Error state
        if (controller.hasError.value) {
          return _buildChartError(controller);
        }

        // Empty state
        if (controller.chartPoints.isEmpty) {
          return _buildChartEmpty();
        }

        // Chart
        return _buildChart(controller);
      }),
    );
  }

  Widget _buildChartLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: MuamalahColors.primaryEmerald,
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Memuat grafik...',
            style: TextStyle(
              fontSize: 13,
              color: MuamalahColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartError(CoinDetailController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: MuamalahColors.haram.withAlpha(128),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gagal memuat grafik',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Periksa koneksi internet Anda',
            style: TextStyle(
              fontSize: 12,
              color: MuamalahColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: controller.retry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: MuamalahColors.primaryEmerald,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartEmpty() {
    return const Center(
      child: Text(
        'Tidak ada data grafik',
        style: TextStyle(
          fontSize: 14,
          color: MuamalahColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildChart(CoinDetailController controller) {
    final points = controller.chartPoints;
    final isUp = controller.isChartUp;
    final lineColor = isUp ? MuamalahColors.halal : MuamalahColors.haram;

    // Buat spots untuk LineChart
    final spots = <FlSpot>[];
    for (int i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].price));
    }

    final minY = controller.minPrice * 0.995; // 0.5% padding
    final maxY = controller.maxPrice * 1.005;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart change indicator
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isUp ? MuamalahColors.halalBg : MuamalahColors.haramBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isUp ? '+' : ''}${controller.chartPriceChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isUp ? MuamalahColors.halal : MuamalahColors.haram,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'dalam ${controller.selectedRange.value}',
                style: const TextStyle(
                  fontSize: 12,
                  color: MuamalahColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: MuamalahColors.glassBorder,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: spots.length.toDouble() - 1,
                minY: minY,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.white,
                    tooltipBorder: BorderSide(color: MuamalahColors.glassBorder),
                    tooltipRoundedRadius: 12,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.x.toInt();
                        if (index >= 0 && index < points.length) {
                          return LineTooltipItem(
                            points[index].priceFormatted,
                            const TextStyle(
                              color: MuamalahColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: lineColor,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          lineColor.withAlpha(51),
                          lineColor.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STATS SECTION
  // ===========================================================================

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('Kapitalisasi Pasar', coin.marketCapFormatted),
          _buildStatRow('Volume 24 Jam', coin.volumeFormatted),
          _buildStatRow('Perubahan 7 Hari', coin.change7dFormatted, 
            isChange: true, isUp: coin.change7d >= 0),
          _buildStatRow('Peringkat', coin.marketCapRank != null ? '#${coin.marketCapRank}' : '-'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isChange = false, bool isUp = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isChange
                  ? (isUp ? MuamalahColors.halal : MuamalahColors.haram)
                  : MuamalahColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
