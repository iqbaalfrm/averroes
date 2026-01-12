import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../theme/app_theme.dart';
import 'reels_controller.dart';
import 'reel_item_model.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller di-inject oleh Binding atau Get.put saat diakses
    final controller = Get.put(ReelsController());

    // NOT a Scaffold, just a container for the Tab content
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Main PageView
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: MuamalahColors.primaryEmerald),
              );
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.white70),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: controller.fetchReels,
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              );
            }

            if (controller.reels.isEmpty) {
              // Should not happen due to fallback, but safe check
              return const Center(child: Text('Konten sedang dipersiapkan...', style: TextStyle(color: Colors.white)));
            }

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.reels.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                return ReelItemWidget(item: controller.reels[index]);
              },
            );
          }),

          // 2. Header Overlay (Gradient top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120, 
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(180),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3. Header Controls
          Positioned(
            top: 50, 
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title / Filter
                GestureDetector(
                  onTap: () => _showFilterDialog(controller),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withAlpha(30)),
                    ),
                    child: Row(
                      children: [
                        Obx(() => Text(
                          controller.selectedCategory.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        )),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70, size: 18),
                      ],
                    ),
                  ),
                ),
                
                // Sound Toggle
                Obx(() => GestureDetector(
                  onTap: controller.toggleSound,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.isSoundEnabled.value 
                            ? MuamalahColors.primaryEmerald 
                            : Colors.white.withAlpha(30),
                      ),
                    ),
                    child: controller.isBuffering.value
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(
                            controller.isSoundEnabled.value 
                                ? Icons.volume_up_rounded 
                                : Icons.volume_off_rounded,
                            color: controller.isSoundEnabled.value 
                                ? MuamalahColors.primaryEmerald 
                                : Colors.white,
                            size: 20,
                          ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(ReelsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Kategori',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['Sabar', 'Fiqh Muamalah', 'Takdir', 'Acak'].map((cat) => 
                Obx(() {
                  final isSelected = controller.selectedCategory.value == cat;
                  return GestureDetector(
                    onTap: () {
                      controller.filterCategory(cat);
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? MuamalahColors.primaryEmerald : Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                           color: isSelected ? MuamalahColors.primaryEmerald : Colors.transparent
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                })
              ).toList(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class ReelItemWidget extends StatelessWidget {
  final ReelItem item;

  const ReelItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getCategoryGradient(item.category),
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern (Optional)
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/ui/backgrounds/islamic_pattern.png',
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) => const SizedBox(),
              ),
            ),
          ),
          
          // Center Content (Scrollable if long)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 120, bottom: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 // Type Icon
                 Container(
                   padding: const EdgeInsets.all(16),
                   decoration: BoxDecoration(
                     color: Colors.white.withAlpha(20),
                     shape: BoxShape.circle,
                   ),
                   child: Icon(
                    _getTypeIcon(item.type),
                    size: 32,
                    color: Colors.white,
                  ),
                 ),
                 const SizedBox(height: 32),
                 
                 // Arabic Text
                 if (item.arabic != null) ...[
                   Text(
                     item.arabic!,
                     textAlign: TextAlign.center,
                     style: const TextStyle(
                       fontFamily: 'Amiri',
                       fontSize: 26,
                       color: Colors.white,
                       height: 1.8,
                       shadows: [
                         Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),
                 ],

                 // Indonesia Text
                 Text(
                   item.indonesia,
                   textAlign: TextAlign.center,
                   style: const TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.w500,
                     color: Colors.white,
                     height: 1.5,
                     letterSpacing: 0.3,
                     fontStyle: FontStyle.italic,
                     shadows: [
                         Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
                     ],
                   ),
                 ),
                 
                 const SizedBox(height: 32),
                 
                 // Source Chip
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(30),
                   ),
                   child: Text(
                     item.source.toUpperCase(),
                     style: const TextStyle(
                       fontSize: 12,
                       fontWeight: FontWeight.bold,
                       color: Colors.black87,
                       letterSpacing: 1,
                     ),
                   ),
                 ),
                 
                 // Attribution for API
                 if (item.type == 'ayat') ...[
                   const SizedBox(height: 8),
                   const Text(
                     'Sumber: Al-Qur’an (myQuran API)',
                     style: TextStyle(
                       fontSize: 10,
                       color: Colors.white54,
                     ),
                   ),
                 ],
              ],
            ),
           ),
          ),

          // Bottom Metadata (Duration)
          if (item.durationSec != null)
            Positioned(
              bottom: 120, // Di atas BottomNav
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(120),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(item.durationSec!),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Color> _getCategoryGradient(String category) {
    switch (category) {
      case 'Fiqh Muamalah': return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)];
      case 'Takdir': return [const Color(0xFF141E30), const Color(0xFF243B55)];
      case 'Sabar': return [const Color(0xFF3E5151), const Color(0xFFDECBA4)];
      case 'Qonaah': return [const Color(0xFF232526), const Color(0xFF414345)];
      default: return [const Color(0xFF000000), const Color(0xFF434343)];
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'ayat': return Icons.auto_stories_rounded;
      case 'hadith': return Icons.format_quote_rounded;
      case 'quote': return Icons.lightbulb_outline_rounded;
      default: return Icons.article_outlined;
    }
  }
  
  String _formatDuration(int sec) {
    if (sec <= 0) return '';
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
