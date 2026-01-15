import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';
import '../../services/auth_guard.dart';
import '../screener/screener_view.dart';
import '../zakat/zakat_view.dart';
import '../pasar/pasar_view.dart'; // Pasar
import '../edukasi/edukasi_page_view.dart'; // Edukasi
import '../tanya_ahli/tanya_ahli_view.dart';
import '../pustaka/pustaka_view.dart';
import '../psikologi/psikologi_view.dart';
import '../fatwa/fatwa_view.dart';
import '../news/news_controller.dart';
import '../news/news_view.dart';
import '../porto/porto_page_view.dart';
import 'prayer_times_controller.dart';
import 'beranda_controller.dart';
import '../../utils/news_helpers.dart'; 

// ============================================================================
// BERANDA VIEW - RESTRUCTURED
// ============================================================================

class BerandaView extends StatelessWidget {
  const BerandaView({super.key});

  static const Color _accentColor = Color(0xFFF2C94C); // Soft gold: one bold accent for key CTAs.

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BerandaController());
    // ignore: unused_local_variable
    final prayerController = Get.put(PrayerTimesController());
    final newsController = Get.put(NewsController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: MuamalahColors.primaryEmerald,
          ),
        );
      }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. GREETING + PRAYER TIME
              _FadeInItem(
                delayMs: 0,
                child: _buildGreetingAndPrayerSection(controller),
              ),
            
              const SizedBox(height: 32),
            
              // 2. 8 FITUR UTAMA
              _FadeInItem(
                delayMs: 160,
                child: _buildFeatureGrid(),
              ),
            
              const SizedBox(height: 32),
            
              // 3. LANJUTKAN PERJALANAN
              _FadeInItem(
                delayMs: 300,
                child: _buildLearningProgressSection(),
              ),
            
              const SizedBox(height: 40),
            
              // 4. BERITA & INSIGHT
              _FadeInItem(
                delayMs: 420,
                child: _buildNewsSection(newsController),
              ),
            
              const SizedBox(height: 40),
            
              // 5. REFLEKSI & PSIKOLOGI
              _FadeInItem(
                delayMs: 520,
                child: _buildHikmahSection(),
              ),
          ],
        ),
      );
    });
  }

  // ============================================================================
  // 1. GREETING + PRAYER (Combined Section)
  // ============================================================================
  Widget _buildGreetingAndPrayerSection(BerandaController controller) {
    final prayerController = Get.find<PrayerTimesController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting
        Text(
          "Assalamu'alaikum, ${controller.getGreeting()}",
          style: const TextStyle(
            fontSize: 16,
            color: MuamalahColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Waktunya produktif & ibadah.",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 24),
        // Prayer Cards (Asymmetric 65/35)
        SizedBox(
          height: 118,
          child: Row(
            children: [
              // Jakarta (Active)
              Expanded(
                flex: 13,
                child: Obx(() => Transform.rotate(
                  angle: 0.015,
                  child: _buildPrayerCard(
                    title: "Jakarta ? ${prayerController.nextPrayerName.value}",
                    time: prayerController.countdown.value,
                    isActive: true,
                    color: MuamalahColors.primaryEmerald,
                    note: "Menuju Dzuhur, rehat dulu.",
                    isPrimary: true,
                  ),
                )),
              ),
              const SizedBox(width: 12),
              // Mekkah (Static Context)
              Expanded(
                flex: 7,
                child: _buildPrayerCard(
                  title: "Mekkah ? Isya",
                  time: "19:45",
                  isActive: false,
                  color: MuamalahColors.neutral,
                  note: "Kiblat hati tenang.",
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerCard({
    required String title,
    required String time,
    required bool isActive,
    required Color color,
    required String note,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isActive ? MuamalahColors.primaryEmerald : MuamalahColors.glassWhite,
        borderRadius: isPrimary
            ? const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(32),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(26),
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(16),
              ),
        border: isActive ? null : Border.all(color: MuamalahColors.glassBorder),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: MuamalahColors.primaryEmerald.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white.withOpacity(0.9) : MuamalahColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : MuamalahColors.textPrimary,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.white.withOpacity(0.8) : MuamalahColors.textMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 3. 8 FITUR UTAMA GRID
  // ============================================================================
  Widget _buildFeatureGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mulai Dari Sini",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Pilih yang paling kamu butuh.",
          style: TextStyle(fontSize: 12, color: MuamalahColors.textMuted),
        ),
        const SizedBox(height: 16),
        // Asymmetric bento layout keeps the grid feeling human, not templated.
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = 12.0;
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 13,
                      child: _buildFeatureTile(
                        title: 'Screener',
                        subtitle: 'Halal tracker',
                        icon: Icons.filter_alt_rounded,
                        color: MuamalahColors.primaryEmerald,
                        height: 170,
                        isPrimary: true,
                        radius: const BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(34),
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Get.to(() => const ScreenerView());
                        },
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      flex: 9,
                      child: Column(
                        children: [
                          _buildFeatureTile(
                            title: 'Zakat',
                            subtitle: 'Hitung nisab',
                            icon: Icons.volunteer_activism_rounded,
                            color: MuamalahColors.proses,
                            height: 78,
                            radius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(22),
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(16),
                            ),
                            onTap: () {
                              AuthGuard.requireAuth(
                                featureName: 'Zakat',
                                onAllowed: () => Get.to(() => const ZakatView()),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureTile(
                            title: 'Pasar',
                            subtitle: 'Harga & tren',
                            icon: Icons.candlestick_chart_rounded,
                            color: const Color(0xFF6366F1),
                            height: 80,
                            radius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(26),
                              bottomRight: Radius.circular(18),
                            ),
                            onTap: () => Get.to(() => const PasarView()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 11,
                      child: _buildFeatureTile(
                        title: 'Pustaka',
                        subtitle: 'E-Library',
                        icon: Icons.menu_book_rounded,
                        color: const Color(0xFF7C3AED),
                        height: 94,
                        radius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                        onTap: () => Get.to(() => const PustakaView()),
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      flex: 11,
                      child: _buildFeatureTile(
                        title: 'Fatwa',
                        subtitle: 'Panduan syariah',
                        icon: Icons.gavel_rounded,
                        color: const Color(0xFF1F2937),
                        height: 94,
                        radius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(18),
                        ),
                        onTap: () => Get.to(() => const FatwaView()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 12,
                      child: _buildFeatureTile(
                        title: 'Tanya Ahli',
                        subtitle: 'Chatbot syariah',
                        icon: Icons.support_agent_rounded,
                        color: const Color(0xFF0EA5E9),
                        height: 110,
                        radius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(30),
                        ),
                        onTap: () {
                          AuthGuard.requireAuth(
                            featureName: 'Tanya Ahli',
                            onAllowed: () => Get.to(() => const TanyaAhliView()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      flex: 10,
                      child: Column(
                        children: [
                          _buildFeatureTile(
                            title: 'Psikologi',
                            subtitle: 'Refleksi ringan',
                            icon: Icons.psychology_alt_rounded,
                            color: const Color(0xFF10B981),
                            height: 78,
                            radius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(14),
                            ),
                            onTap: () => Get.to(() => const PsikologiView()),
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureTile(
                            title: 'Portofolio',
                            subtitle: 'Asetmu',
                            icon: Icons.pie_chart_outline_rounded,
                            color: const Color(0xFF1E293B),
                            height: 78,
                            radius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(26),
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(22),
                            ),
                            onTap: () {
                              AuthGuard.requireAuth(
                                featureName: 'Portofolio',
                                onAllowed: () => Get.to(() => const PortoPageView()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double height,
    required BorderRadius radius,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return _PressableCard(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: Border.all(color: MuamalahColors.glassBorder),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      color: MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildActionTile({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: MuamalahColors.glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MuamalahColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: MuamalahColors.glassBorder),
          ],
        ),
      ),
    );
  }



  // ============================================================================
  // 4. LANJUTKAN BELAJAR
  // ============================================================================
  Widget _buildLearningProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Lanjutkan Perjalananmu",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => const EdukasiHomeView()),
              child: Text(
                "Ke Kelas",
                style: TextStyle(
                  color: _accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: constraints.maxWidth * 0.92,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(18),
                  ),
                  border: Border.all(color: const Color(0xFFFDECC8)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bookmark_added_rounded, color: Color(0xFFB45309), size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Fiqh Muamalah Dasar",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Lanjut yuk, dikit lagi kamu paham soal Reksadana Syariah!",
                            style: TextStyle(fontSize: 11, color: Color(0xFF92400E), height: 1.3),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Modul 2 - Akad Jual Beli",
                            style: TextStyle(fontSize: 10, color: Color(0xFFB45309)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const _CurvedProgressIndicator(progress: 0.3),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewsSection(NewsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Berita & Insight",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => const NewsPage()),
              child: const Text(
                "Intip semua →",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final items = controller.items.take(5).toList();
          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "Memuat berita...",
                  style: TextStyle(color: MuamalahColors.textMuted),
                ),
              ),
            );
          }

          return SizedBox(
            height: 160,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () async {
                    final uri = Uri.tryParse(item.url);
                    if (uri != null) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: MuamalahColors.glassBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: MuamalahColors.neutralBg,
                            borderRadius: BorderRadius.circular(14),
                            image: item.imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(item.imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          '${item.source} - ${relativeTime(item.publishedAt)}',
                          style: const TextStyle(fontSize: 10, color: MuamalahColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHikmahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
           "Refleksi Diri",
           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MuamalahColors.textPrimary),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: MuamalahColors.neutralBg, // Warm Grey
            borderRadius: BorderRadius.circular(24), 
          ),
          child: Column(
            children: [
              const Icon(Icons.psychology_alt_rounded, color: MuamalahColors.textMuted, size: 32), // Brain/Heart icon
              const SizedBox(height: 16),
              const Text(
                "Rezeki itu sudah tertakar, tidak akan tertukar. Fokuslah pada keberkahan cara menjemputnya.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: MuamalahColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.to(() => const PsikologiView()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: MuamalahColors.textMuted),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Baca Refleksi Lainnya",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: MuamalahColors.textSecondary),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}


class _PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressableCard({required this.child, required this.onTap});

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _FadeInItem extends StatefulWidget {
  final Widget child;
  final int delayMs;

  const _FadeInItem({required this.child, required this.delayMs});

  @override
  State<_FadeInItem> createState() => _FadeInItemState();
}

class _FadeInItemState extends State<_FadeInItem> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 420),
      opacity: _visible ? 1 : 0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 420),
        offset: _visible ? Offset.zero : const Offset(0, 0.04),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _CurvedProgressIndicator extends StatelessWidget {
  final double progress;

  const _CurvedProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(80, 80),
      painter: _CurvedProgressPainter(progress: progress),
    );
  }
}

class _CurvedProgressPainter extends CustomPainter {
  final double progress;

  _CurvedProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = MuamalahColors.glassBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = BerandaView._accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(4, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width - 4,
      size.height * 0.4,
    );

    canvas.drawPath(path, basePaint);

    final metric = path.computeMetrics().first;
    final clamped = progress.clamp(0.0, 1.0) as double;
    final progressPath = metric.extractPath(0, metric.length * clamped);
    canvas.drawPath(progressPath, progressPaint);

    // Dots on path to soften the progress look (organic feel).
    final dotPaint = Paint()..color = BerandaView._accentColor.withOpacity(0.7);
    const dots = 6;
    for (int i = 0; i <= dots; i++) {
      final t = (metric.length / dots) * i;
      final tangent = metric.getTangentForOffset(t);
      if (tangent != null) {
        canvas.drawCircle(tangent.position, 2.2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
