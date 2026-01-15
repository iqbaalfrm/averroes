import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/auth_guard.dart';
import 'diskusi_controller.dart';
import 'diskusi_models.dart';

class DiskusiDetailView extends StatefulWidget {
  final DiskusiThread thread;

  const DiskusiDetailView({super.key, required this.thread});

  @override
  State<DiskusiDetailView> createState() => _DiskusiDetailViewState();
}

class _DiskusiDetailViewState extends State<DiskusiDetailView> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<DiskusiController>();
    controller.loadReplies(widget.thread);
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiskusiController>();
    final thread = widget.thread;
    final replies = controller.repliesFor(thread.id);

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Diskusi'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDisclaimerBanner(),
                  const SizedBox(height: 16),
                  _buildThreadCard(thread),
                  const SizedBox(height: 18),
                  Obx(() {
                    return Row(
                      children: [
                        Text(
                          'Jawaban (${replies.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: MuamalahColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _replyFocus.requestFocus();
                          },
                          child: const Text(
                            'Balas',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: MuamalahColors.primaryEmerald,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 12),
                  Obx(() {
                    if (replies.isEmpty) {
                      return _buildEmptyReply();
                    }
                    return Column(
                      children: replies.map((reply) {
                        final isNew = controller.lastReplyId.value == reply.id;
                        return _buildReplyCard(
                          controller,
                          thread,
                          reply,
                          isNew: isNew,
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
          _buildReplyComposer(controller, thread),
        ],
      ),
    );
  }

  Widget _buildDisclaimerBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: MuamalahColors.textMuted),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Diskusi ini bersifat edukatif. Jawaban bukan fatwa resmi.',
              style: TextStyle(
                fontSize: 12,
                color: MuamalahColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadCard(DiskusiThread thread) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MuamalahColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryChip(label: thread.category),
          const SizedBox(height: 10),
          Text(
            thread.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            thread.description,
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (thread.isModerated) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MuamalahColors.prosesBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Topik ini diarahkan kembali ke pembahasan edukatif.',
                style: TextStyle(
                  fontSize: 12,
                  color: MuamalahColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                thread.author.displayName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '•',
                style: TextStyle(color: MuamalahColors.textMuted),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTime(thread.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: MuamalahColors.textMuted,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.forum_outlined, size: 16, color: MuamalahColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${thread.replyCount} balasan',
                    style: const TextStyle(
                      fontSize: 12,
                      color: MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  AuthGuard.requireAuth(
                    featureName: 'Diskusi',
                    onAllowed: () => Get.find<DiskusiController>()
                        .toggleThreadLike(thread),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border_rounded, size: 16, color: MuamalahColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      '${thread.helpfulCount} apresiasi',
                      style: const TextStyle(fontSize: 11, color: MuamalahColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplyCard(
    DiskusiController controller,
    DiskusiThread thread,
    DiskusiReply reply, {
    bool isNew = false,
  }) {
    final isOwner = controller.isOwner(thread);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: isNew ? 0.0 : 1.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: MuamalahColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  reply.author.displayName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(reply.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: MuamalahColors.textMuted,
                  ),
                ),
                if (reply.isAccepted) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.verified_rounded, size: 14, color: MuamalahColors.halal),
                  const SizedBox(width: 4),
                  const Text(
                    'Membantu',
                    style: TextStyle(fontSize: 11, color: MuamalahColors.halal),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            _MarkdownLite(text: reply.content),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    AuthGuard.requireAuth(
                      featureName: 'Diskusi',
                      onAllowed: () => controller.toggleReplyLike(reply),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border_rounded, size: 16, color: MuamalahColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        '${reply.helpfulCount} membantu',
                        style: const TextStyle(fontSize: 11, color: MuamalahColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isOwner)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      AuthGuard.requireAuth(
                        featureName: 'Diskusi',
                        onAllowed: () => controller.markAccepted(thread, reply),
                      );
                    },
                    child: const Text(
                      'Tandai sebagai membantu',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.primaryEmerald,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyReply() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Belum ada jawaban. Jadi yang pertama membantu ya.',
        style: TextStyle(fontSize: 12, color: MuamalahColors.textSecondary),
      ),
    );
  }

  Widget _buildReplyComposer(DiskusiController controller, DiskusiThread thread) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: MuamalahColors.glassBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balas dengan sopan dan jelas',
            style: TextStyle(fontSize: 12, color: MuamalahColors.textMuted),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: MuamalahColors.glassBorder),
            ),
            child: TextField(
              controller: _replyController,
              focusNode: _replyFocus,
              minLines: 2,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tulis jawabanmu di sini...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Markdown ringan: **bold**, - bullet',
                style: TextStyle(fontSize: 11, color: MuamalahColors.textMuted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  AuthGuard.requireAuth(
                    featureName: 'Diskusi',
                    onAllowed: () async {
                      final text = _replyController.text.trim();
                      if (text.isEmpty) return;
                      if (!await controller.addReply(thread: thread, content: text)) {
                        Get.snackbar(
                          'Diarahkan',
                          'Topik ini diarahkan kembali ke pembahasan edukatif.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: MuamalahColors.prosesBg,
                          colorText: MuamalahColors.textPrimary,
                        );
                        return;
                      }
                      HapticFeedback.lightImpact();
                      _replyController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: MuamalahColors.primaryEmerald,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Kirim Jawaban',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    }
    return '${diff.inDays} hari lalu';
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: MuamalahColors.textSecondary,
        ),
      ),
    );
  }
}

class _MarkdownLite extends StatelessWidget {
  final String text;

  const _MarkdownLite({required this.text});

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().startsWith('- ')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: MuamalahColors.primaryEmerald,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: _BoldTextSpan(text: line.replaceFirst('- ', ''))),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _BoldTextSpan(text: line),
        );
      }).toList(),
    );
  }
}

class _BoldTextSpan extends StatelessWidget {
  final String text;

  const _BoldTextSpan({required this.text});

  @override
  Widget build(BuildContext context) {
    final parts = text.split('**');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      final isBold = i.isOdd;
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: MuamalahColors.textSecondary,
            height: 1.5,
          ),
        ),
      );
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 13),
        children: spans,
      ),
    );
  }
}
