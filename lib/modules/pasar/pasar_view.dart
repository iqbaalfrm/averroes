import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../theme/app_theme.dart';
import 'models/crypto_market_item.dart';
import 'services/coingecko_api_client.dart';

// ============================================================================
// PASAR CONTROLLER
// ============================================================================

class PasarController extends GetxController {
  // State
  final RxBool isLoading = true.obs;
  final RxString selectedFilter = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  // Data
  final RxList<CryptoMarketItem> cryptoMarket = <CryptoMarketItem>[].obs;
  final RxString globalMarketCap = '\$1.64T'.obs;
  final RxDouble globalMarketChange = 1.2.obs;
  final RxString volume24h = '\$89.2B'.obs;
  final RxDouble btcDominance = 48.5.obs;

  // Filters
  final List<String> filters = ['Semua', 'Top 10', 'Gainers', 'Losers'];

  late final CoinGeckoApiClient _apiClient;

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
      final results = await _apiClient.fetchMarketData(perPage: 50);
      if (results != null) {
        cryptoMarket.assignAll(results);
      }
    } catch (e) {
      print('⚠️ [Pasar] Error fetching market: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMarket() async {
    await fetchMarket();
  }

  List<CryptoMarketItem> get displayedCrypto {
    var list = cryptoMarket.toList();

    // Apply filter
    if (selectedFilter.value == 'Top 10') {
      list = list.take(10).toList();
    } else if (selectedFilter.value == 'Gainers') {
      list = list.where((item) => item.isUp).toList();
    } else if (selectedFilter.value == 'Losers') {
      list = list.where((item) => !item.isUp).toList();
    }

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.code.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }
}

// ============================================================================
// PASAR VIEW
// ============================================================================

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
            // App Bar with Gradient
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: MuamalahColors.backgroundPrimary,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
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
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: MuamalahColors.textPrimary,
                    size: 20,
                  ),
                ),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pasar Crypto',
                      style: TextStyle(
                        color: MuamalahColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: MuamalahColors.halalBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: MuamalahColors.halal,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Live',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: MuamalahColors.halal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Harga & Kapitalisasi',
                          style: TextStyle(
                            fontSize: 11,
                            color: MuamalahColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MuamalahColors.mint.withAlpha(128),
                        MuamalahColors.backgroundPrimary,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: MuamalahColors.primaryEmerald.withAlpha(20),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: const TextStyle(color: MuamalahColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Cari koin (BTC, ETH, SOL)...',
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

            // Filter Chips
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
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
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? MuamalahColors.primaryEmerald
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : MuamalahColors.glassBorder,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: MuamalahColors.primaryEmerald
                                            .withAlpha(77),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
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
                  )),
                ),
              ),
            ),

            // Market Summary Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Market Cap',
                        controller.globalMarketCap.value,
                        '+${controller.globalMarketChange.value}%',
                        Icons.pie_chart_rounded,
                        MuamalahColors.primaryEmerald,
                        true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() => _buildSummaryCard(
                        'Volume 24h',
                        controller.volume24h.value,
                        'BTC ${controller.btcDominance.value}%',
                        Icons.swap_horiz_rounded,
                        const Color(0xFF6366F1),
                        false,
                      )),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Crypto List
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

  Widget _buildSummaryCard(
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const Spacer(),
              if (isPositive)
                Icon(
                  Icons.trending_up_rounded,
                  size: 16,
                  color: MuamalahColors.halal,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: MuamalahColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: isPositive ? MuamalahColors.halal : MuamalahColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(CryptoMarketItem item) {
    final changeColor = item.isUp ? MuamalahColors.halal : MuamalahColors.haram;
    final changeBgColor = item.isUp ? MuamalahColors.halalBg : MuamalahColors.haramBg;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon & Name
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: MuamalahColors.primaryEmerald.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      item.code.substring(0, 1),
                      style: const TextStyle(
                        color: MuamalahColors.primaryEmerald,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                              fontSize: 15,
                              color: MuamalahColors.textPrimary,
                            ),
                          ),
                          if (item.id == 'bitcoin' ||
                              item.id == 'ethereum' ||
                              item.id == 'solana' ||
                              item.id == 'cardano') ...[
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
                          fontSize: 12,
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

          // Price & Change
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
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: changeBgColor,
                  borderRadius: BorderRadius.circular(8),
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
    );
  }
}
