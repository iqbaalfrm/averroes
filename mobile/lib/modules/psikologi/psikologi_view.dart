import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

// ============================================================================
// PSIKOLOGI CONTROLLER
// ============================================================================

class PsikologiController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxInt currentMoodIndex = (-1).obs;

  final List<Map<String, dynamic>> moodOptions = [
    {'emoji': '😰', 'label': 'Panik', 'color': MuamalahColors.haram},
    {'emoji': '😟', 'label': 'Cemas', 'color': MuamalahColors.proses},
    {'emoji': '😐', 'label': 'Netral', 'color': MuamalahColors.neutral},
    {'emoji': '😊', 'label': 'Tenang', 'color': MuamalahColors.halal},
    {'emoji': '🤩', 'label': 'Antusias', 'color': MuamalahColors.bitcoin},
  ];

  final List<Map<String, dynamic>> insightList = [
    {
      'title': 'Mengatasi FOMO dalam Trading Crypto',
      'icon': Icons.trending_up_rounded,
      'color': MuamalahColors.haram,
      'content': 'FOMO (Fear of Missing Out) adalah musuh utama trader. Ketika melihat coin naik drastis, godaan untuk ikut membeli sangat besar. Ingat, setiap keputusan investasi harus didasari riset, bukan emosi.',
      'tips': [
        'Tetapkan rencana trading sebelum pasar buka',
        'Jangan membeli hanya karena melihat orang lain profit',
        'Ingat bahwa volatilitas tinggi = risiko tinggi',
        'Berdoa dan istikharah sebelum keputusan besar',
      ],
      'islamicWisdom': '"Tidak ada kebaikan dalam banyak dari bisikan-bisikan mereka..." (QS. An-Nisa: 114)',
    },
    {
      'title': 'Melawan Keserakahan (Greed)',
      'icon': Icons.monetization_on_rounded,
      'color': MuamalahColors.proses,
      'content': 'Keserakahan membuat kita mengabaikan risiko dan terus mengejar profit. Padahal dalam Islam, qana\'ah (menerima dengan cukup) adalah kunci keberkahan.',
      'tips': [
        'Tetapkan target profit yang realistis',
        'Ambil profit secara berkala, jangan serakah',
        'Ingat bahwa rezeki sudah ditentukan Allah',
        'Hindari leverage berlebihan',
      ],
      'islamicWisdom': '"Bukanlah kekayaan itu dengan banyaknya harta, tetapi kekayaan yang sebenarnya adalah kekayaan jiwa." (HR. Bukhari)',
    },
    {
      'title': 'Sabar dalam Volatilitas Market',
      'icon': Icons.waves_rounded,
      'color': MuamalahColors.halal,
      'content': 'Pasar crypto sangat volatile. Harga bisa turun 20% dalam sehari dan naik 30% keesokannya. Kesabaran adalah kunci untuk tidak panik selling.',
      'tips': [
        'Jangan cek harga terlalu sering',
        'Investasi hanya uang yang siap hilang',
        'Fokus pada fundamental, bukan daily movement',
        'Ingat bahwa ujian adalah jalan menuju kesabaran',
      ],
      'islamicWisdom': '"Sungguh, Allah beserta orang-orang yang sabar." (QS. Al-Baqarah: 153)',
    },
    {
      'title': 'Menghindari Panic Selling',
      'icon': Icons.sentiment_very_dissatisfied_rounded,
      'color': MuamalahColors.risikoTinggi,
      'content': 'Ketika harga turun drastis, naluri pertama adalah menjual semua. Ini adalah respons emosional yang sering kali merugikan.',
      'tips': [
        'Buat rencana exit strategy sebelumnya',
        'Tanyakan: Apakah fundamentalnya berubah?',
        'Jangan trading saat emosi tidak stabil',
        'Istirahat dari layar jika perlu',
      ],
      'islamicWisdom': '"Orang yang kuat bukanlah yang menang dalam perkelahian, tetapi orang yang dapat mengendalikan dirinya saat marah." (HR. Bukhari)',
    },
    {
      'title': 'Menjaga Keseimbangan Hidup',
      'icon': Icons.balance_rounded,
      'color': MuamalahColors.primaryEmerald,
      'content': 'Trading tidak boleh mengganggu ibadah dan kehidupan sosial. Jika kamu terobsesi dengan chart hingga lupa sholat, itu tanda bahaya.',
      'tips': [
        'Tetapkan jam trading yang jelas',
        'Prioritaskan sholat 5 waktu',
        'Luangkan waktu untuk keluarga',
        'Jangan bawa "chart" ke tempat tidur',
      ],
      'islamicWisdom': '"Tidak bergeser kaki seorang hamba di hari kiamat sampai ditanya tentang umurnya untuk apa dihabiskan..." (HR. Tirmidzi)',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
  }
}

// ============================================================================
// PSIKOLOGI VIEW
// ============================================================================

class PsikologiView extends StatelessWidget {
  const PsikologiView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PsikologiController());

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

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF8B5CF6).withAlpha(31),
                      MuamalahColors.backgroundPrimary,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        const Expanded(
                          child: Text(
                            'Psikologi Trading',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MuamalahColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kelola emosi, trading dengan tenang',
                      style: TextStyle(
                        fontSize: 14,
                        color: MuamalahColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Mood Check
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withAlpha(31),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.psychology_alt_rounded,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Bagaimana mood tradingmu hari ini?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: MuamalahColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        controller.moodOptions.length,
                        (index) => _buildMoodOption(
                          controller.moodOptions[index],
                          index,
                          controller,
                        ),
                      ),
                    )),
                    Obx(() {
                      if (controller.currentMoodIndex.value >= 0) {
                        final mood = controller.moodOptions[controller.currentMoodIndex.value];
                        String message;
                        if (controller.currentMoodIndex.value <= 1) {
                          message = 'Mungkin sebaiknya tidak trading dulu. Istirahat sejenak, berdoa, dan tenangkan pikiranmu. 🤲';
                        } else if (controller.currentMoodIndex.value == 2) {
                          message = 'Kondisi netral adalah kondisi ideal untuk trading. Tetap tenang dan ikuti rencana! ✨';
                        } else {
                          message = 'Mood baik! Tapi tetap waspada terhadap overconfidence. Tetap rendah hati. 🌙';
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: (mood['color'] as Color).withAlpha(15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: (mood['color'] as Color).withAlpha(51)),
                          ),
                          child: Row(
                            children: [
                              Text(mood['emoji'], style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  message,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: MuamalahColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Today's Reminder
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withAlpha(77),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Pengingat Hari Ini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '"Rezeki sudah diatur oleh Allah. Tugasmu hanya berikhtiar dengan cara yang halal dan tawakal pada hasilnya."',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withAlpha(230),
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '— Pengingat dari CryptoSyaria',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Insights Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Insight Psikologi Trading',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Insight Cards
              ...controller.insightList.map((insight) => _buildInsightCard(insight)),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMoodOption(Map<String, dynamic> mood, int index, PsikologiController controller) {
    final isSelected = controller.currentMoodIndex.value == index;

    return GestureDetector(
      onTap: () => controller.currentMoodIndex.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? (mood['color'] as Color).withAlpha(31) : MuamalahColors.neutralBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? (mood['color'] as Color) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(mood['emoji'], style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              mood['label'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? (mood['color'] as Color) : MuamalahColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(Map<String, dynamic> insight) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (insight['color'] as Color).withAlpha(31),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              insight['icon'] as IconData,
              color: insight['color'] as Color,
              size: 24,
            ),
          ),
          title: Text(
            insight['title'],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          children: [
            Text(
              insight['content'],
              style: const TextStyle(
                fontSize: 13,
                color: MuamalahColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: MuamalahColors.mint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tips Praktis:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.primaryEmerald,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    (insight['tips'] as List).length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: MuamalahColors.primaryEmerald)),
                          Expanded(
                            child: Text(
                              insight['tips'][i],
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
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withAlpha(15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF8B5CF6).withAlpha(51)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🕌 ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      insight['islamicWisdom'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textSecondary,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
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
}
