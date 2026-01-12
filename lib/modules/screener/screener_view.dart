import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../theme/app_theme.dart';
import 'models/crypto_asset.dart';
import 'services/csv_loader_service.dart';
import 'widgets/screening_notice_dialog.dart';

// ============================================================================
// SCREENER CONTROLLER
// ============================================================================

class ScreenerController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString selectedFilter = 'Semua'.obs;
  final RxString errorMessage = ''.obs;

  // Search Logic
  final TextEditingController searchController = TextEditingController();
  final RxString _searchQuery = ''.obs; // Query aktual yg dipakai filter (debounced)
  final RxString _rawSearchQuery = ''.obs; // Input text mentah

  /// Daftar aset kripto yang dimuat dari CSV
  final RxList<CryptoAsset> cryptoList = <CryptoAsset>[].obs;

  // Storage
  final GetStorage _storage = GetStorage();
  static const String _noticeSeenKey = 'screener_notice_seen';

  @override
  void onInit() {
    super.onInit();
    _loadCryptoData();
    
    // Debounce search input: update _searchQuery hanya setelah 300ms diam
    debounce(_rawSearchQuery, (query) {
      _searchQuery.value = query;
    }, time: const Duration(milliseconds: 300));

    // Check and show notice dialog if first time
    _checkAndShowNotice();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  /// Handle input change
  void onSearchChanged(String val) {
    _rawSearchQuery.value = val;
  }
  
  /// Clear search
  void clearSearch() {
    searchController.clear();
    _rawSearchQuery.value = '';
    _searchQuery.value = '';
  }

  /// Check and show notice dialog if first time
  void _checkAndShowNotice() {
    // Delay to ensure UI is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      final hasSeenNotice = _storage.read<bool>(_noticeSeenKey) ?? false;

      if (!hasSeenNotice) {
        Get.dialog(
          ScreeningNoticeDialog(
            onUnderstood: () {
              _storage.write(_noticeSeenKey, true);
            },
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  /// Muat data crypto dari file CSV
  Future<void> _loadCryptoData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final assets = await CsvLoaderService.loadCryptoAssets();
      cryptoList.assignAll(assets);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data: $e';
      // ignore: avoid_print
      print('Error loading crypto data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data dari CSV
  Future<void> refreshData() async {
    await _loadCryptoData();
  }

  /// Daftar aset yang sudah difilter berdasarkan status DAN search query
  List<CryptoAsset> get filteredList {
    List<CryptoAsset> list = cryptoList;

    // 1. Filter by Status
    if (selectedFilter.value != 'Semua') {
      list = list.where((c) => c.status == selectedFilter.value).toList();
    }
    
    // 2. Filter by Search Query
    if (_searchQuery.value.isNotEmpty) {
      final q = _searchQuery.value.toLowerCase();
      list = list.where((c) {
        return c.name.toLowerCase().contains(q) || 
               c.code.toLowerCase().contains(q);
      }).toList();
    }
    
    return list;
  }

  // ===========================================================================
  // STATS GETTERS
  // ===========================================================================

  /// Jumlah aset dengan status Halal
  int get halalCount => cryptoList.where((c) => c.status == 'Halal').length;

  /// Jumlah aset dengan status Proses
  int get prosesCount => cryptoList.where((c) => c.status == 'Proses').length;

  /// Jumlah aset dengan status Risiko Tinggi
  int get risikoCount => cryptoList.where((c) => c.status == 'Risiko Tinggi').length;

  /// Total semua aset
  int get totalCount => cryptoList.length;
}

// ============================================================================
// SCREENER VIEW
// ============================================================================

class ScreenerView extends StatelessWidget {
  const ScreenerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScreenerController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: MuamalahColors.primaryEmerald,
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
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
                  child: const Icon(Icons.arrow_back_rounded, color: MuamalahColors.textPrimary, size: 20),
                ),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Crypto Screener',
                  style: TextStyle(
                    color: MuamalahColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
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
                    controller: controller.searchController,
                    onChanged: controller.onSearchChanged,
                    style: const TextStyle(color: MuamalahColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Cari kode atau nama aset...',
                      hintStyle: const TextStyle(color: MuamalahColors.textMuted),
                      prefixIcon: const Icon(Icons.search_rounded, color: MuamalahColors.textMuted),
                      suffixIcon: Obx(() => controller._rawSearchQuery.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, color: MuamalahColors.textMuted),
                            onPressed: controller.clearSearch,
                          )
                        : const SizedBox.shrink()
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            // Filter Chips
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Status Syariah',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(controller, 'Semua', null),
                          _buildFilterChip(controller, 'Halal', MuamalahColors.halal),
                          _buildFilterChip(controller, 'Proses', MuamalahColors.proses),
                          _buildFilterChip(controller, 'Risiko Tinggi', MuamalahColors.risikoTinggi),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),

            // Stats Summary
            Obx(() => SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: MuamalahColors.primaryEmerald.withAlpha(77),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Halal', controller.halalCount.toString(), MuamalahColors.halalBg),
                    Container(width: 1, height: 40, color: Colors.white.withAlpha(51)),
                    _buildStatItem('Proses', controller.prosesCount.toString(), MuamalahColors.prosesBg),
                    Container(width: 1, height: 40, color: Colors.white.withAlpha(51)),
                    _buildStatItem('Risiko', controller.risikoCount.toString(), MuamalahColors.risikoTinggiBg),
                  ],
                ),
              ),
            )),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Crypto List
            Obx(() => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final crypto = controller.filteredList[index];
                  return _buildCryptoCard(crypto);
                },
                childCount: controller.filteredList.length,
              ),
            )),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      }),
    );
  }

  Widget _buildFilterChip(ScreenerController controller, String label, Color? color) {
    final isSelected = controller.selectedFilter.value == label;
    return GestureDetector(
      onTap: () => controller.selectedFilter.value = label,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? MuamalahColors.primaryEmerald) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : MuamalahColors.glassBorder,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: (color ?? MuamalahColors.primaryEmerald).withAlpha(77),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : MuamalahColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color bgColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withAlpha(204),
          ),
        ),
      ],
    );
  }

  Widget _buildCryptoCard(CryptoAsset crypto) {
    Color statusColor;
    Color statusBgColor;

    switch (crypto.status) {
      case 'Halal':
        statusColor = MuamalahColors.halal;
        statusBgColor = MuamalahColors.halalBg;
        break;
      case 'Risiko Tinggi':
        statusColor = MuamalahColors.risikoTinggi;
        statusBgColor = MuamalahColors.risikoTinggiBg;
        break;
      default:
        statusColor = MuamalahColors.proses;
        statusBgColor = MuamalahColors.prosesBg;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            spreadRadius: 5,
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    crypto.code,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${crypto.price} • MC: ${crypto.marketCap}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      crypto.status == 'Halal' 
                          ? Icons.check_circle_rounded 
                          : crypto.status == 'Risiko Tinggi'
                              ? Icons.warning_rounded
                              : Icons.help_rounded,
                      size: 14,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      crypto.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analisis Syariah:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  crypto.explanation,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MuamalahColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            crypto.details.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    size: 6,
                    color: statusColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      crypto.details[i],
                      style: const TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textSecondary,
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
}
