import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import 'portfolio_controller.dart';
import 'add_edit_holding_view.dart';
import 'models/portfolio_holding.dart';

// ============================================================================
// PORTO PAGE VIEW (Unified)
// ============================================================================

class PortoPageView extends StatelessWidget {
  final bool showBackButton;
  
  const PortoPageView({
    super.key,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(PortfolioController());

    return Container(
      color: MuamalahColors.backgroundPrimary,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: MuamalahColors.primaryEmerald,
            ),
          );
        }

        // Check if guest
        if (controller.isGuest && controller.holdings.isEmpty) {
          return _buildGuestState(controller);
        }

        // Check if empty (but logged in)
        if (controller.holdings.isEmpty) {
           return _buildEmptyState(controller);
        }

        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header
                  _buildHeader(context, controller),

                  // Total Value Section (Clean, Numbers first)
                  _buildTotalValueSection(controller),

                  const SizedBox(height: 24),

                  // Assets Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Aset Kamu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MuamalahColors.textPrimary,
                          ),
                        ),
                        // Refresh Button as icon next to header or separate
                        GestureDetector(
                          onTap: () => controller.refreshPrices(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(12),
                               border: Border.all(color: MuamalahColors.glassBorder),
                            ),
                            child: const Icon(Icons.refresh_rounded, size: 20, color: MuamalahColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Asset List
                  ...controller.holdings.map((asset) => _buildAssetItem(asset, controller)),

                  const SizedBox(height: 24),
                  
                  // Zakat Widget
                  if (controller.totalBalanceIdr.value > 85000000) // Nisab roughly
                     _buildZakatWidget(controller),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Floating Add Button
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                onPressed: () => _openAddAssetSheet(),
                backgroundColor: MuamalahColors.primaryEmerald,
                foregroundColor: Colors.white,
                elevation: 4,
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Catat Aset',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _openAddAssetSheet({PortfolioHolding? holding}) {
     Get.bottomSheet(
        AddEditHoldingView(holding: holding),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
     ).then((_) {
        // Refresh after closing sheet if needed
        final controller = Get.find<PortfolioController>();
        controller.fetchPortfolio();
     });
  }

  Widget _buildHeader(BuildContext context, PortfolioController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
      child: Row(
        children: [
          if (showBackButton) ...[
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_rounded, color: MuamalahColors.textPrimary),
            ),
            const SizedBox(width: 8),
          ],
          const Text(
            'Portofolio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold, // Jakarta Sans Bold
              color: MuamalahColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalValueSection(PortfolioController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Nilai',
            style: TextStyle(
              fontSize: 14,
              color: MuamalahColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // Big Number
          Obx(() => Text(
            _formatCurrency(controller.totalBalanceIdr.value),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800, // Extra Bold
              color: MuamalahColors.textPrimary,
              letterSpacing: -1.5,
              height: 1.1,
            ),
          )),
          const SizedBox(height: 8),
          // Profit/Loss Pill
          Obx(() {
            final pl = controller.totalProfitLossIdr.value; 
            final isProfit = pl >= 0;
            return Container(
               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
               decoration: BoxDecoration(
                 color: isProfit ? MuamalahColors.halalBg : MuamalahColors.haramBg,
                 borderRadius: BorderRadius.circular(20),
               ),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                    Icon(
                      isProfit ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                      size: 16,
                      color: isProfit ? MuamalahColors.halal : MuamalahColors.haram,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${isProfit ? '+' : ''}${_formatCurrency(pl)}', // Simplified for now
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isProfit ? MuamalahColors.halal : MuamalahColors.haram,
                      ),
                    ),
                 ],
               ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAssetItem(PortfolioHolding asset, PortfolioController controller) {
    final isProfit = asset.profitLossIdr >= 0;
    
    return GestureDetector(
       onTap: () => _openAddAssetSheet(holding: asset),
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
             // Icon Placeholder or Network Image
             Container(
               width: 48,
               height: 48,
               decoration: BoxDecoration(
                 color: MuamalahColors.neutralBg,
                 borderRadius: BorderRadius.circular(16),
               ),
               child: Center(
                 child: Text(
                   asset.symbol.substring(0, 1),
                   style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: MuamalahColors.textPrimary,
                   ),
                 ),
               ),
             ),
             const SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     asset.symbol,
                     style: const TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: MuamalahColors.textPrimary,
                     ),
                   ),
                   const SizedBox(height: 2),
                   Text(
                     '${asset.amount} Unit',
                     style: const TextStyle(
                       fontSize: 13,
                       color: MuamalahColors.textMuted,
                     ),
                   ),
                 ],
               ),
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 Text(
                   _formatCurrency(asset.totalValueIdr),
                   style: const TextStyle(
                     fontSize: 15,
                     fontWeight: FontWeight.bold,
                     color: MuamalahColors.textPrimary,
                   ),
                 ),
                 const SizedBox(height: 4),
                 Text(
                   '${isProfit ? '+' : ''}${_formatCurrency(asset.profitLossIdr)}',
                   style: TextStyle(
                     fontSize: 12,
                     fontWeight: FontWeight.w600,
                     color: isProfit ? MuamalahColors.halal : MuamalahColors.haram,
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
    );
  }

   Widget _buildZakatWidget(PortfolioController controller) {
    final zakat = controller.totalBalanceIdr.value * 0.025;
    return Container(
       margin: const EdgeInsets.symmetric(horizontal: 20),
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
          color: MuamalahColors.accentGold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MuamalahColors.accentGold.withOpacity(0.3)),
       ),
       child: Row(
          children: [
             Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                   color: MuamalahColors.accentGold.withOpacity(0.2),
                   shape: BoxShape.circle,
                ),
                child: const Icon(Icons.volunteer_activism_rounded, color: Color(0xFFD97706)),
             ),
             const SizedBox(width: 16),
             Expanded(
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      const Text(
                         "Potensi Zakat Mal",
                         style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                      ),
                      Text(
                         "Harta kamu sudah mencapai nisab.",
                         style: TextStyle(fontSize: 11, color: const Color(0xFFD97706).withOpacity(0.8)),
                      ),
                   ],
                )
             ),
             Text(
                _formatCurrency(zakat),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
             ),
          ],
       ),
    );
  }

  Widget _buildEmptyState(PortfolioController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: MuamalahColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum ada aset',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mulai catat investasi kripto kamu.',
            style: TextStyle(color: MuamalahColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
             onPressed: () => _openAddAssetSheet(),
             icon: const Icon(Icons.add_rounded),
             label: const Text("Catat Aset"),
             style: ElevatedButton.styleFrom(
                backgroundColor: MuamalahColors.primaryEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
             ),
          )
        ],
      ),
    );
  }

  Widget _buildGuestState(PortfolioController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 60, color: MuamalahColors.textMuted),
            const SizedBox(height: 20),
            const Text(
              'Mode Tamu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Masuk untuk mencatat portofolio dan memantau asetmu secara real-time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MuamalahColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.LOGIN),
              style: ElevatedButton.styleFrom(
                backgroundColor: MuamalahColors.primaryEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Masuk Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}
