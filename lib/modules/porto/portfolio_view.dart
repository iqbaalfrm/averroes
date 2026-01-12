import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import 'portfolio_controller.dart';
import 'models/portfolio_holding.dart';
import 'add_edit_holding_view.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PortfolioController());

    return Scaffold(
      backgroundColor: MuamalahColors.neutralBlack,
      body: RefreshIndicator(
        onRefresh: controller.fetchPortfolio,
        color: MuamalahColors.primaryEmerald,
        child: CustomScrollView(
          slivers: [
            // AppBar
            SliverAppBar(
              backgroundColor: MuamalahColors.neutralBlack,
              floating: true,
              pinned: true,
              title: const Text('Portofolio', style: TextStyle(color: Colors.white)),
              actions: [
                if (controller.isGuest)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Chip(
                      label: const Text('Tamu', style: TextStyle(fontSize: 10)),
                      backgroundColor: Colors.white10,
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                  )
              ],
            ),

            // Summary Card
            SliverToBoxAdapter(
              child: _buildSummaryCard(controller),
            ),

            // Holdings List
            Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (controller.holdings.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Belum ada aset.', style: TextStyle(color: Colors.white54))),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final holding = controller.holdings[index];
                    return _HoldingsItem(
                      holding: holding,
                      onTap: () => _showOptions(context, controller, holding),
                    );
                  },
                  childCount: controller.holdings.length,
                ),
              );
            }),
            
            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(
          const AddEditHoldingView(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: MuamalahColors.primaryEmerald,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(PortfolioController controller) {
    final fmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E1E1E),
            MuamalahColors.primaryEmerald.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Nilai Aset', style: TextStyle(color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 8),
          Obx(() => Text(
                fmt.format(controller.totalBalanceIdr.value),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              )),
          const SizedBox(height: 16),
          _buildProfitLoss(controller, fmt),
        ],
      ),
    );
  }

  Widget _buildProfitLoss(PortfolioController controller, NumberFormat fmt) {
    return Obx(() {
      final pl = controller.totalProfitLossIdr.value;
      final isPos = pl >= 0;
      final color = isPos ? MuamalahColors.primaryEmerald : Colors.redAccent;
      final prefix = isPos ? '+' : '';
      
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPos ? Icons.trending_up : Icons.trending_down,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '$prefix${fmt.format(pl)}',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text('Est. P/L', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      );
    });
  }

  void _showOptions(BuildContext context, PortfolioController controller, PortfolioHolding item) {
    Get.bottomSheet(
      Container(
        color: const Color(0xFF1E1E1E),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blueAccent),
              title: const Text('Edit', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                Get.bottomSheet(
                  AddEditHoldingView(holding: item),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                _confirmDelete(context, controller, item);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PortfolioController controller, PortfolioHolding item) {
    Get.defaultDialog(
      title: 'Hapus Aset?',
      middleText: 'Apakah Anda yakin ingin menghapus ${item.name} from portofolio?',
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteHolding(item.id);
      },
    );
  }
}

class _HoldingsItem extends StatelessWidget {
  final PortfolioHolding holding;
  final VoidCallback onTap;

  const _HoldingsItem({required this.holding, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final priceFmt = NumberFormat.currency(locale: 'en_US', symbol: '\$ ', decimalDigits: 2);
    
    final priceUsd = holding.currentPriceUsd;
    final total = holding.totalValueIdr;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: Text(holding.symbol[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(holding.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(fmt.format(total), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${holding.amount} ${holding.symbol} • ${priceUsd != null ? priceFmt.format(priceUsd) : "--"}',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          if (holding.profitLossIdr != 0)
            Text(
              '${holding.profitLossIdr >= 0 ? "+" : ""}${NumberFormat.compact(locale: "id").format(holding.profitLossIdr)}',
              style: TextStyle(
                color: holding.profitLossIdr >= 0 ? MuamalahColors.primaryEmerald : Colors.redAccent,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
