import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';

// ============================================================================
// DISKUSI VIEW - AI CRYPTO SYARIAH CHAT
// ============================================================================

class DiskusiController extends GetxController {
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final TextEditingController textController = TextEditingController();
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    messages.addAll([
      {
        'isUser': false,
        'message': 'Assalamu\'alaikum! 👋\n\nSaya adalah AI CryptoSyaria yang siap membantu kamu memahami cryptocurrency dari perspektif syariah Islam.\n\nAda yang ingin kamu tanyakan tentang crypto halal?',
        'time': '12:30',
      },
      {
        'isUser': true,
        'message': 'Waalaikumsalam. Apakah Bitcoin itu halal atau haram menurut syariah?',
        'time': '12:31',
      },
      {
        'isUser': false,
        'message': 'Pertanyaan yang sangat bagus! 🌟\n\nStatus Bitcoin dalam perspektif syariah masih menjadi perdebatan ulama:\n\n**Pendapat yang membolehkan:**\n• Bitcoin memiliki nilai tukar yang diakui\n• Tidak mengandung riba secara langsung\n• Bisa digunakan sebagai alat tukar\n\n**Pendapat yang melarang:**\n• Volatilitas tinggi (gharar)\n• Tidak memiliki underlying asset\n• Potensi spekulasi berlebihan\n\n**Kesimpulan:**\nMUI Indonesia mengkategorikan crypto sebagai **Proses** - boleh digunakan dengan syarat:\n1. Bukan untuk spekulasi\n2. Untuk tujuan investasi jangka panjang\n3. Dengan niat yang benar\n\nMau tahu lebih detail tentang kriteria crypto halal?',
        'time': '12:32',
      },
      {
        'isUser': true,
        'message': 'Bagaimana cara menghitung zakat dari aset crypto yang saya punya?',
        'time': '12:33',
      },
      {
        'isUser': false,
        'message': 'Untuk menghitung zakat crypto, berikut panduannya:\n\n📊 **Syarat Wajib Zakat Crypto:**\n1. Kepemilikan sudah 1 tahun (haul)\n2. Nilai mencapai nisab (85 gram emas)\n\n💰 **Cara Menghitung:**\n1. Hitung total nilai crypto saat haul\n2. Pastikan melebihi nisab (~Rp 85 juta)\n3. Bayar zakat 2.5% dari total nilai\n\n📱 **Contoh:**\nNilai portofolio: Rp 100.000.000\nZakat = 2.5% × Rp 100.000.000\n**= Rp 2.500.000**\n\nKamu bisa gunakan fitur "Zakat Crypto" di aplikasi ini untuk menghitung otomatis! ✨',
        'time': '12:34',
      },
    ]);
  }

  void sendMessage() {
    if (textController.text.trim().isEmpty) return;
    
    messages.add({
      'isUser': true,
      'message': textController.text.trim(),
      'time': '12:35',
    });
    textController.clear();
    
    isTyping.value = true;
    Future.delayed(const Duration(milliseconds: 1500), () {
      isTyping.value = false;
      messages.add({
        'isUser': false,
        'message': 'Terima kasih atas pertanyaanmu! Saya sedang memproses informasi terkait crypto syariah.\n\nUntuk pertanyaan lebih spesifik, kamu juga bisa menggunakan fitur "Tanya Ahli" untuk berkonsultasi langsung dengan pakar crypto syariah.\n\nAda pertanyaan lain? 🌙',
        'time': '12:36',
      });
    });
  }
}

class DiskusiView extends StatelessWidget {
  const DiskusiView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiskusiController());

    return Column(
      children: [
        const SizedBox(height: 60),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MuamalahColors.primaryEmerald,
                      MuamalahColors.emeraldLight,
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI CryptoSyaria',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: MuamalahColors.halal,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Online • Ahli Crypto Syariah',
                          style: TextStyle(
                            fontSize: 13,
                            color: MuamalahColors.textSecondary,
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
        const SizedBox(height: 16),
        
        // Chat Messages
        Expanded(
          child: Obx(() => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.messages.length && controller.isTyping.value) {
                return _buildTypingIndicator();
              }
              final message = controller.messages[index];
              return _buildMessageBubble(message);
            },
          )),
        ),
        
        // Input Area
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 110),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  decoration: const InputDecoration(
                    hintText: 'Tanya tentang crypto syariah...',
                    hintStyle: TextStyle(color: MuamalahColors.textMuted),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MuamalahColors.primaryEmerald,
                        MuamalahColors.emeraldLight,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MuamalahColors.primaryEmerald,
                    MuamalahColors.emeraldLight,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? MuamalahColors.primaryEmerald
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 6),
                  bottomRight: Radius.circular(isUser ? 6 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message['message'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : MuamalahColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['time'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: isUser
                          ? Colors.white.withAlpha(179)
                          : MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MuamalahColors.primaryEmerald,
                  MuamalahColors.emeraldLight,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: MuamalahColors.textMuted.withAlpha(128),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
