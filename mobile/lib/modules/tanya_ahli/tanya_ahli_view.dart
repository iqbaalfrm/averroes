import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ============================================================================
// TANYA AHLI BINDING
// ============================================================================

class TanyaAhliBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TanyaAhliController>(() => TanyaAhliController());
  }
}

// ============================================================================
// TANYA AHLI CONTROLLER
// ============================================================================

class TanyaAhliController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[
    {
      'role': 'bot',
      'text': 'Assalamualaikum! Saya Averroes AI. Silakan tanya apa saja mengenai Muamalah dan Crypto Syariah.',
      'time': 'Just now'
    },
    {
      'role': 'user',
      'text': 'Apakah staking Ethereum itu halal?',
      'time': 'Just now'
    },
    {
      'role': 'bot',
      'text': 'Waalaikumussalam. Mengenai staking Ethereum, para ahli fiqih memiliki pandangan bahwa mekanisme Proof of Stake (PoS) pada dasarnya diperbolehkan selama tidak mengandung unsur gharar (ketidakjelasan) dan maysir (judi).\n\nNamun, perlu diperhatikan detail protokolnya agar sesuai dengan prinsip Syariah.',
      'time': 'Just now'
    }
  ].obs;

  final RxList<String> suggestedQuestions = [
    'Hukum Bitcoin',
    'Konsep Riba',
    'Emas Digital',
    'NFT Halal?'
  ].obs;

  void sendMessage() {
    if (textController.text.trim().isEmpty) return;
    
    // Add user message
    messages.add({
      'role': 'user',
      'text': textController.text,
      'time': 'Just now'
    });
    
    textController.clear();
    _scrollToBottom();

    // Simulate bot thinking
    Future.delayed(const Duration(seconds: 1), () {
      messages.add({
        'role': 'bot',
        'text': 'Pertanyaan yang bagus! Sedang saya carikan referensinya...',
        'time': 'Just now'
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

// ============================================================================
// TANYA AHLI VIEW
// ============================================================================

class TanyaAhliView extends GetView<TanyaAhliController> {
  const TanyaAhliView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TanyaAhliController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(), 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20)
        ),
        title: Column(
          children: [
            const Text(
              'Tanya Ahli AI',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C853),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: Color(0xFF00C853),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
           IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history_rounded, color: Colors.black87),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: controller.messages.length + 1, // +1 for header disclaimer
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildDisclaimer();
                }
                
                final msg = controller.messages[index - 1];
                return _buildMessageBubble(msg);
              },
            )),
          ),

          // Bottom Area (Chips + Input)
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Suggested Questions
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: controller.suggestedQuestions.map((q) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(q),
                        labelStyle: const TextStyle(
                          fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        avatar: const Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF00C853)),
                        onPressed: () {
                          controller.textController.text = q;
                          controller.sendMessage();
                        },
                      ),
                    )).toList(),
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFF1F5F9)),

                // Input Field
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: controller.textController,
                            decoration: const InputDecoration(
                              hintText: 'Tanya tentang hukum crypto...',
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                              suffixIcon: Icon(Icons.mic_rounded, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: controller.sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C853), // Green
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00C853).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'AI ADVICE - EDUCATIONAL PURPOSES ONLY',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isBot = msg['role'] == 'bot';
    
    if (isBot) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bot Avatar
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87, 
                // Suggestion: could use an image asset here
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const Text(
                  'Averroes AI',
                  style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00C853),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    msg['text'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // User Message
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.7),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                msg['text'],
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
