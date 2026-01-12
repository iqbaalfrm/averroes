import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../theme/app_theme.dart';
import '../../widgets/custom_dialog.dart';
import '../../services/auth_guard.dart';
import '../../services/location_service.dart';
import '../screener/screener_view.dart';
import '../zakat/zakat_view.dart';
import '../pustaka/pustaka_view.dart';
import '../pasar/pasar_view.dart';
import '../fatwa/fatwa_view.dart';
import '../tanya_ahli/tanya_ahli_view.dart';
import '../artikel/artikel_view.dart';
import '../artikel/artikel_controller.dart';
import '../artikel/artikel_detail_view.dart';
import '../psikologi/psikologi_view.dart';
import '../porto/porto_page_view.dart';
import 'prayer_times_controller.dart';
import '../../utils/news_helpers.dart';
import 'beranda_controller.dart';

// ============================================================================
// BERANDA VIEW - CRYPTO SYARIAH HOME
// ============================================================================

// ============================================================================
// BERANDA VIEW - CRYPTO SYARIAH HOME
// ============================================================================

class BerandaView extends StatelessWidget {
  const BerandaView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BerandaController());

    return Obx(() {
      if (controller.isLoading.value) {
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
                'Memuat...',
                style: TextStyle(
                  color: MuamalahColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildGlassHeader(controller),
            const SizedBox(height: 24),
            _buildPrayerTimeCards(controller),
            const SizedBox(height: 28),
            _buildMainMenu(),
            const SizedBox(height: 28),
            _buildLastLearnedProgress(),
            const SizedBox(height: 28),
            _buildLatestNews(),
          ],
        ),
      );
    });
  }


  // ============================================================================
  // GLASS HEADER
  // ============================================================================

  Widget _buildGlassHeader(BerandaController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(230),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withAlpha(180),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 30,
                  spreadRadius: 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        MuamalahColors.primaryEmerald.withAlpha(31),
                        MuamalahColors.mint,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      '🌙',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Assalamu'alaikum",
                        style: TextStyle(
                          fontSize: 14,
                          color: MuamalahColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.getGreeting(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MuamalahColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              MuamalahColors.mint,
                              MuamalahColors.mint.withAlpha(179),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Niat. Ilmu. Amal. 🌙',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MuamalahColors.primaryEmerald,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
                GestureDetector(
                  onTap: () => _showPrayerReminderModal(controller.getCurrentPrayer()),
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MuamalahColors.primaryEmerald.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: MuamalahColors.primaryEmerald,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // PRAYER TIME CARDS - REALTIME LOCATION-BASED
  // ============================================================================

  // ============================================================================
  // PRAYER TIME CARDS - DUAL LAYOUT (JAKARTA & MEKKAH)
  // ============================================================================

  Widget _buildPrayerTimeCards(BerandaController controller) {
    // Initialize PrayerTimesController for Jakarta/Local
    final prayerController = Get.put(PrayerTimesController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use Row for wide screens, Column for very narrow (rare on mobile but safe)
          // For standard mobile, Row with Expanded works if content is minimal.
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. JAKARTA CARD (Realtime/Local)
              Expanded(
                child: Obx(() {
                  if (prayerController.isLoading.value) {
                    return _buildMinimalLoadingCard(label: 'Jakarta');
                  }
                  return _buildStrictColumnCard(
                    title: 'Wib', // Jakarta Timezone
                    location: 'Jakarta',
                    nextPrayer: prayerController.nextPrayerName.value,
                    countdown: prayerController.countdown.value,
                    color: MuamalahColors.primaryEmerald,
                    bgColors: [
                      MuamalahColors.mint.withOpacity(0.9),
                      Colors.white,
                    ],
                  );
                }),
              ),
              
              const SizedBox(width: 12),
              
              // 2. MEKKAH CARD (Dummy/Static for UI Demo)
              Expanded(
                child: _buildStrictColumnCard(
                  title: 'Arab',
                  location: 'Mekkah',
                  nextPrayer: 'Isya',
                  countdown: '01:42:15', // Dummy countdown
                  color: MuamalahColors.accentGold,
                  bgColors: [
                    MuamalahColors.prosesBg,
                    Colors.white,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMinimalLoadingCard({required String label}) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(height: 8),
          Text('Memuat $label...', style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  // STRICT COLUMN CARD - No Rows for text to prevent overflow
  Widget _buildStrictColumnCard({
    required String title,
    required String location,
    required String nextPrayer,
    required String countdown,
    required Color color,
    required List<Color> bgColors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bgColors,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "WIB • Jakarta"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$title • $location',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Line 1: "Menuju..."
          Text(
            'Menuju $nextPrayer',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: MuamalahColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 4),
          
          // Line 2: Countdown (Large, Bold)
          Text(
            countdown,
            style: TextStyle(
              fontSize: 20, // Adjusted for split width
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
               fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimePrayerCard(PrayerTimesController prayerController) {
      return const SizedBox.shrink(); // Deprecated
  } 

  Widget _buildMinimalPrayerCard({
    required String title,
    required String location,
    required String currentTime,
    required String timezone,
    required String nextPrayer,
    required String countdown,
    required Color accentColor,
    required List<Color> bgGradient,
  }) {
      return const SizedBox.shrink(); // Deprecated
  }

  // Prayer Reminder Modal
  void _showPrayerReminderModal(String nextPrayer) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: MuamalahColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: MuamalahColors.primaryEmerald,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Pengingat Sholat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            Text(
              'Aktifkan pengingat untuk waktu sholat',
              style: TextStyle(
                fontSize: 13,
                color: MuamalahColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Reminder Options
            _buildReminderOption('Pengingat $nextPrayer', true),
            const SizedBox(height: 12),
            _buildReminderOption('Pengingat Maghrib', true),
            const SizedBox(height: 12),
            _buildReminderOption('Pengingat Subuh', false),
            const SizedBox(height: 12),
            _buildReminderOption('Pengingat Isya', true),
            
            const SizedBox(height: 24),
            
            // Save Button
            GestureDetector(
              onTap: () {
                Get.back();
                AppDialogs.showSuccess(
                  title: 'Tersimpan',
                  message: 'Pengingat sholat berhasil diperbarui',
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: MuamalahColors.primaryEmerald,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Simpan Pengaturan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderOption(String label, bool isEnabled) {
    final RxBool enabled = isEnabled.obs;
    
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: enabled.value ? MuamalahColors.halalBg : MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: enabled.value ? MuamalahColors.halal.withAlpha(51) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: enabled.value ? MuamalahColors.halal : MuamalahColors.neutral,
            size: 20,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: MuamalahColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: enabled.value,
            onChanged: (v) => enabled.value = v,
            activeColor: MuamalahColors.primaryEmerald,
          ),
        ],
      ),
    ));
  }

  // ============================================================================
  // MAIN MENU (8-GRID) - CRYPTO FOCUSED
  // ============================================================================

  Widget _buildMainMenu() {
    final menuItems = [
      {'icon': Icons.search_rounded, 'label': 'Screener', 'color': MuamalahColors.halal, 'page': const ScreenerView(), 'requireAuth': false},
      {'icon': Icons.volunteer_activism_rounded, 'label': 'Zakat', 'color': const Color(0xFF6366F1), 'page': const ZakatView(), 'requireAuth': false},
      {'icon': Icons.auto_stories_rounded, 'label': 'Pustaka', 'color': MuamalahColors.bitcoin, 'page': const PustakaView(), 'requireAuth': false},
      {'icon': Icons.candlestick_chart_rounded, 'label': 'Pasar', 'color': const Color(0xFFEC4899), 'page': const PasarView(), 'requireAuth': false},
      {'icon': Icons.menu_book_rounded, 'label': 'Fatwa', 'color': MuamalahColors.primaryEmerald, 'page': const FatwaView(), 'requireAuth': false},
      {'icon': Icons.support_agent_rounded, 'label': 'Tanya Ahli', 'color': const Color(0xFF14B8A6), 'page': TanyaAhliView(), 'requireAuth': true},
      {'icon': Icons.psychology_rounded, 'label': 'Psikologi', 'color': const Color(0xFF8B5CF6), 'page': const PsikologiView(), 'requireAuth': false},
      {'icon': Icons.pie_chart_rounded, 'label': 'Porto', 'color': MuamalahColors.ethereum, 'page': const PortoPageView(), 'requireAuth': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Menu Utama',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              final requireAuth = item['requireAuth'] as bool? ?? false;
              final label = item['label'] as String;
              
              return _buildMenuItem(
                icon: item['icon'] as IconData,
                label: label,
                color: item['color'] as Color,
                onTap: () {
                  if (requireAuth) {
                    AuthGuard.requireAuth(
                      featureName: label,
                      onAllowed: () => Get.to(() => item['page'] as Widget),
                    );
                  } else {
                    Get.to(() => item['page'] as Widget);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: MuamalahColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // LAST LEARNED PROGRESS (REPLACES CRYPTO SCREENER)
  // ============================================================================

  Widget _buildLastLearnedProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Lanjutkan Belajar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MuamalahColors.primaryEmerald,
                MuamalahColors.emeraldLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: MuamalahColors.primaryEmerald.withAlpha(77),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                   Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: Colors.white.withAlpha(51),
                       borderRadius: BorderRadius.circular(16),
                     ),
                     child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text(
                           'Hukum Crypto dalam Islam', 
                           style: TextStyle(
                             fontSize: 15,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                         ),
                         const SizedBox(height: 4),
                         Text(
                           'Modul 3 • 12 Materi',
                           style: TextStyle(
                             fontSize: 12,
                             color: Colors.white.withAlpha(200),
                           ),
                         ),
                       ],
                     ),
                   ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   ClipRRect(
                     borderRadius: BorderRadius.circular(8),
                     child: LinearProgressIndicator(
                       value: 0.75, // 75%
                       minHeight: 8,
                       backgroundColor: Colors.white.withAlpha(77),
                       valueColor: const AlwaysStoppedAnimation(Colors.white),
                     ),
                   ),
                   const SizedBox(height: 8),
                   const Text(
                     '75% Selesai',
                     style: TextStyle(
                       fontSize: 12,
                       fontWeight: FontWeight.w600,
                       color: Colors.white,
                     ),
                   ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // LATEST NEWS (REAL DATA FROM RSS)
  // ============================================================================

  Widget _buildLatestNews() {
    final artikelController = Get.put(ArtikelController());

    return Obx(() {
      final latestArticles = artikelController.articles.take(5).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      'Berita Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'TERBARU',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: MuamalahColors.accentGold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const ArtikelView());
                  },
                  child: const Text(
                    'Lihat Semua',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: MuamalahColors.primaryEmerald,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Loading state
          if (artikelController.isLoading.value && latestArticles.isEmpty)
            ...List.generate(3, (index) => _buildNewsCardSkeleton())
          
          // Error state
          else if (artikelController.errorMessage.isNotEmpty && latestArticles.isEmpty)
            _buildNewsErrorState(artikelController)

          // Empty state fallback (no data and not loading)
          else if (latestArticles.isEmpty && !artikelController.isLoading.value)
            _buildNewsEmptyState(artikelController)

          // Articles list
          else
            ...latestArticles.map((article) => _buildNewsCard(article)),
        ],
      );
    });
  }

  Widget _buildNewsErrorState(ArtikelController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, color: MuamalahColors.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: MuamalahColors.textSecondary),
          ),
          TextButton(
            onPressed: () => controller.fetchArticles(forceRefresh: true),
            child: const Text('Coba Lagi'),
          )
        ],
      ),
    );
  }

  Widget _buildNewsEmptyState(ArtikelController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.article_outlined, color: MuamalahColors.textMuted, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Belum ada berita hari ini',
            style: TextStyle(fontSize: 13, color: MuamalahColors.textSecondary),
          ),
          TextButton(
            onPressed: () => controller.fetchArticles(forceRefresh: true),
            child: const Text('Refresh'),
          )
        ],
      ),
    );
  }

  Widget _buildNewsCard(article) {
    // Get color based on query tag
    Color getTagColor() {
      switch (article.queryTag.toLowerCase()) {
        case 'coinvestasi':
          return const Color(0xFF6366F1);
        case 'cryptowave':
          return const Color(0xFFEC4899);
        case 'syariah':
          return MuamalahColors.primaryEmerald;
        case 'market':
          return const Color(0xFFF59E0B);
        default:
          return MuamalahColors.textMuted;
      }
    }

    final color = getTagColor();

    return GestureDetector(
      onTap: () {
        Get.to(() => ArtikelDetailView(article: article));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.article_rounded,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        article.source,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: MuamalahColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: MuamalahColors.textMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        relativeTime(article.publishedAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: MuamalahColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 120,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
