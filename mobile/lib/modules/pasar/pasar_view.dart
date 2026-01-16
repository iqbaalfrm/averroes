import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'market_repository.dart';
import 'models/crypto_market_item.dart';
import 'services/coingecko_api_client.dart';
import 'views/coin_detail_view.dart';

class PasarController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString selectedFilter = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  final RxList<CryptoMarketItem> cryptoMarket = <CryptoMarketItem>[].obs;
  final RxString globalMarketCap = '\$1.64T'.obs;
  final RxDouble globalMarketChange = 1.2.obs;
  final RxString volume24h = '\$89.2B'.obs;
  final RxDouble btcDominance = 48.5.obs;

  final List<String> filters = ['Semua', 'Teratas 10', 'Naik', 'Turun'];

  late final CoinGeckoApiClient _apiClient;
  final MarketRepository _repository = MarketRepository();

  @override
  void onInit() {
    super.onInit();
    _apiClient = CoinGeckoApiClient();
    fetchMarket();
  }

  @override
  void onClose() {
    _apiClient.dispose();
    super.onClose();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  Future<void> fetchMarket() async {
    try {
      isLoading.value = true;
      final apiResults = await _repository.fetchMarketCoins();
      if (apiResults.isNotEmpty) {
        cryptoMarket.assignAll(apiResults);
        _updateMarketSummaryFromApi(apiResults);
        return;
      }
    } catch (e) {
      print('[Pasar] API fallback: $e');
    }

    try {
      final results = await _apiClient.fetchMarketData(perPage: 50);
      if (results != null) {
        cryptoMarket.assignAll(results);
        final global = await _apiClient.fetchGlobalData();
        globalMarketCap.value = global.totalMarketCapFormatted;
        volume24h.value = global.totalVolumeFormatted;
        btcDominance.value = double.tryParse(
              global.btcDominanceFormatted.replaceAll('%', ''),
            ) ??
            btcDominance.value;
        globalMarketChange.value = global.marketCapChangePercent24h;
      }
    } catch (e) {
      print('[Pasar] Error fetching market: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMarket() async {
    await fetchMarket();
  }

  List<CryptoMarketItem> get displayedCrypto {
    var list = cryptoMarket.toList();

    if (selectedFilter.value == 'Teratas 10') {
      list = list.take(10).toList();
    } else if (selectedFilter.value == 'Naik') {
      list = list.where((item) => item.isUp).toList();
    } else if (selectedFilter.value == 'Turun') {
      list = list.where((item) => !item.isUp).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.code.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  void _updateMarketSummaryFromApi(List<CryptoMarketItem> items) {
    if (items.isEmpty) return;

    final totalMarketCap = items.fold<double>(
      0,
      (sum, item) => sum + item.marketCap,
    );
    final totalVolume = items.fold<double>(
      0,
      (sum, item) => sum + item.volume24h,
    );
    final btcItem = items.firstWhereOrNull(
      (item) => item.code.toUpperCase() == 'BTC',
    );

    globalMarketCap.value = _formatBigNumber(totalMarketCap, prefix: '\$');
    volume24h.value = _formatBigNumber(totalVolume, prefix: '\$');

    if (btcItem != null && totalMarketCap > 0) {
      btcDominance.value = (btcItem.marketCap / totalMarketCap) * 100;
    }
  }

  String _formatBigNumber(double value, {String prefix = ''}) {
    if (value >= 1e12) {
      return '$prefix${(value / 1e12).toStringAsFixed(2)}T';
    } else if (value >= 1e9) {
      return '$prefix${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '$prefix${(value / 1e6).toStringAsFixed(0)}M';
    } else if (value >= 1e3) {
      return '$prefix${(value / 1e3).toStringAsFixed(0)}K';
    }
    return '$prefix${value.toStringAsFixed(0)}';
  }
}

class PasarView extends StatelessWidget {
  const PasarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasarController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: RefreshIndicator(
        onRefresh: controller.refreshMarket,
        color: MuamalahColors.primaryEmerald,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              backgroundColor: MuamalahColors.backgroundPrimary,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: MuamalahColors.textPrimary,
                ),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: const Text(
                  'Pantau Pasar Kripto',
                  style: TextStyle(
                    color: MuamalahColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                background: Container(color: MuamalahColors.backgroundPrimary),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MuamalahColors.glassBorder),
                  ),
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: const TextStyle(color: MuamalahColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Cari aset...',
                      hintStyle: TextStyle(color: MuamalahColors.textMuted),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: MuamalahColors.textMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(
                    () => Row(
                      children: controller.filters.map((filter) {
                        final isSelected = controller.selectedFilter.value == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              controller.updateFilter(filter);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? MuamalahColors.primaryEmerald
                                    : MuamalahColors.glassWhite,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : MuamalahColors.glassBorder,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : MuamalahColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.show_chart_rounded,
                      size: 16,
                      color: MuamalahColors.primaryEmerald,
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        'Kapitalisasi Global: ${controller.globalMarketCap.value}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MuamalahColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.donut_small_rounded,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Obx(
                      () => Text(
                        'Dominasi BTC: ${controller.btcDominance.value.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MuamalahColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: MuamalahColors.primaryEmerald,
                    ),
                  ),
                );
              }

              final displayedList = controller.displayedCrypto;

              if (displayedList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Tidak ada koin ditemukan',
                      style: TextStyle(
                        color: MuamalahColors.textMuted,
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = displayedList[index];
                    return _buildCryptoCard(item);
                  },
                  childCount: displayedList.length,
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoCard(CryptoMarketItem item) {
    final changeColor = item.isUp ? MuamalahColors.halal : MuamalahColors.haram;
    final changeBgColor = item.isUp ? MuamalahColors.halalBg : MuamalahColors.haramBg;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => CoinDetailView(coin: item),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MuamalahColors.glassBorder),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: MuamalahColors.backgroundPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        item.code.substring(0, 1),
                        style: const TextStyle(
                          color: MuamalahColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.code,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: MuamalahColors.textPrimary,
                              ),
                            ),
                            if (item.id == 'bitcoin' || item.id == 'ethereum') ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: MuamalahColors.halal,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: MuamalahColors.textMuted,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.priceUsdFormatted,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: changeBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isUp
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 12,
                        color: changeColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.change24hFormatted.replaceAll('-', ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: changeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
