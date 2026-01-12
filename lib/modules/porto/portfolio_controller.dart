
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/portfolio_holding.dart';
import 'services/portfolio_repository.dart';
import '../../services/coingecko_service.dart';

class PortfolioController extends GetxController {
  final PortfolioRepository _repository = PortfolioRepository();
  final CoinGeckoService _priceService = CoinGeckoService();

  // State
  final RxList<PortfolioHolding> holdings = <PortfolioHolding>[].obs;
  final RxMap<String, CoinPrice> prices = <String, CoinPrice>{}.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  // Total Portfolio Stats
  final RxDouble totalBalanceIdr = 0.0.obs;
  final RxDouble totalBalanceUsd = 0.0.obs;
  final RxDouble totalProfitLossIdr = 0.0.obs;

  bool get isGuest => _repository.isGuest;

  @override
  void onInit() {
    super.onInit();
    fetchPortfolio();
  }

  Future<void> fetchPortfolio() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // 1. Fetch Holdings
      final result = await _repository.getHoldings();
      holdings.value = result;
      
      // 2. Fetch Prices
      await refreshPrices();

      _calculateTotals();
    } catch (e) {
      print('PortfolioController Error: $e');
      errorMessage.value = 'Gagal memuat portofolio.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPrices() async {
    if (holdings.isEmpty) return;
    
    try {
      final symbols = holdings.map((e) => e.symbol).toList();
      final priceMap = await _priceService.fetchPrices(symbols);
      
      prices.addAll(priceMap);

      // 3. Inject Prices to holdings for UI helpers
      for (var h in holdings) {
        final cp = prices[h.symbol.toUpperCase()];
        if (cp != null) {
          h.currentPriceIdr = cp.priceIdr;
          h.currentPriceUsd = cp.priceUsd;
        }
      }
      
      holdings.refresh();
      _calculateTotals();
    } catch (e) {
      print('Error refreshing prices: $e');
    }
  }
  
  void _calculateTotals() {
    double idr = 0;
    double usd = 0;
    double pl = 0;
    
    for (var h in holdings) {
      idr += h.totalValueIdr;
      usd += h.totalValueUsd;
      pl += h.profitLossIdr;
    }
    
    totalBalanceIdr.value = idr;
    totalBalanceUsd.value = usd;
    totalProfitLossIdr.value = pl;
  }

  // ACTIONS
  
  Future<void> addHolding(String coinId, String symbol, String name, double amount, double? price, String? notes) async {
    if (isGuest) {
      _showLoginDialog();
      return;
    }
    
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _repository.addHolding(
        coinId: coinId,
        symbol: symbol,
        name: name,
        amount: amount,
        avgBuyPrice: price,
        notes: notes,
      );
      Get.back(); // close loading
      if (Get.isBottomSheetOpen ?? false) Get.back(); // close sheet
      Get.snackbar('Sukses', 'Aset berhasil ditambahkan', backgroundColor: Colors.green, colorText: Colors.white);
      fetchPortfolio();
    } catch (e) {
      Get.back(); // close loading
      Get.snackbar('Error', 'Gagal menambahkan aset: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> updateHolding(String id, double amount, double? price, String? notes) async {
    if (isGuest) {
      _showLoginDialog();
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _repository.updateHolding(id, amount: amount, avgBuyPrice: price, notes: notes);
      Get.back(); // close loading
      if (Get.isBottomSheetOpen ?? false) Get.back(); // close sheet
      Get.snackbar('Sukses', 'Aset berhasil diperbarui', backgroundColor: Colors.green, colorText: Colors.white);
      fetchPortfolio();
    } catch (e) {
      Get.back(); // close loading
      Get.snackbar('Error', 'Gagal update aset: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteHolding(String id) async {
    if (isGuest) {
      _showLoginDialog();
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await _repository.deleteHolding(id);
      Get.back(); // close loading
      Get.snackbar('Sukses', 'Aset dihapus', backgroundColor: Colors.green, colorText: Colors.white);
      fetchPortfolio();
    } catch (e) {
      Get.back(); // close loading
      Get.snackbar('Error', 'Gagal hapus aset: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
  
  void _showLoginDialog() {
    Get.defaultDialog(
      title: 'Akses Terbatas',
      middleText: 'Anda harus login untuk mengubah portofolio.',
      textConfirm: 'Login',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        // Navigasi ke Login
        Get.toNamed('/login'); 
      }
    );
  }
  
  Future<List<Map<String, dynamic>>> searchCoins(String query) {
    return _priceService.searchCoins(query);
  }
}
