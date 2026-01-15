import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/auth_guard.dart';
import 'create_thread_view.dart';
import 'diskusi_controller.dart';
import 'diskusi_detail_view.dart';
import 'diskusi_models.dart';

class DiskusiView extends StatelessWidget {
  const DiskusiView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiskusiController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SafeArea(
        child: Obx(() {
          final threads = controller.filteredThreads;
          if (controller.isLoading.value && threads.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: MuamalahColors.primaryEmerald),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              _buildHeader(controller),
              const SizedBox(height: 16),
              _buildDisclaimer(),
              const SizedBox(height: 12),
              if (controller.errorMessage.value.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MuamalahColors.prosesBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(fontSize: 12, color: MuamalahColors.textSecondary),
                  ),
                ),
              const SizedBox(height: 16),
              _buildTabRow(controller),
              const SizedBox(height: 16),
              ...threads.asMap().entries.map((entry) {
                final index = entry.key;
                final thread = entry.value;
                return _ThreadCard(
                  thread: thread,
                  variant: index % 3,
                  highlight: controller.lastThreadId.value == thread.id,
                );
              }),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          AuthGuard.requireAuth(
            featureName: 'Diskusi',
            onAllowed: () => Get.to(() => const CreateThreadView()),
          );
        },
        backgroundColor: MuamalahColors.primaryEmerald,
        label: const Text('Ajukan Pertanyaan'),
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(DiskusiController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: MuamalahColors.primaryEmerald.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.forum_rounded,
            color: MuamalahColors.primaryEmerald,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Diskusi Komunitas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Ruang tanya jawab yang hangat dan aman.',
                style: TextStyle(
                  fontSize: 13,
                  color: MuamalahColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
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

  Widget _buildTabRow(DiskusiController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.tabs.map((tab) {
          final isActive = controller.activeTab.value == tab;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              controller.activeTab.value = tab;
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? MuamalahColors.primaryEmerald.withOpacity(0.12)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive
                      ? MuamalahColors.primaryEmerald
                      : MuamalahColors.glassBorder,
                ),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? MuamalahColors.primaryEmerald
                      : MuamalahColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ThreadCard extends StatelessWidget {
  final DiskusiThread thread;
  final int variant;
  final bool highlight;

  const _ThreadCard({
    required this.thread,
    required this.variant,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = variant == 1
        ? MuamalahColors.neutralBg
        : Colors.white;
    final borderRadius = variant == 2 ? 26.0 : 20.0;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.to(() => DiskusiDetailView(thread: thread));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: highlight ? MuamalahColors.primaryEmerald : MuamalahColors.glassBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(variant == 1 ? 0.03 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CategoryChip(label: thread.category),
                const Spacer(),
                if (!thread.isAnswered)
                  const Text(
                    'Belum terjawab',
                    style: TextStyle(fontSize: 11, color: MuamalahColors.textMuted),
                  )
                else
                  const Icon(Icons.verified_rounded, size: 16, color: MuamalahColors.halal),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              thread.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              thread.description,
              maxLines: variant == 1 ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: MuamalahColors.textSecondary,
                height: 1.4,
              ),
            ),
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
                const Text('?', style: TextStyle(color: MuamalahColors.textMuted)),
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
                    const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: MuamalahColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${thread.replyCount} balasan',
                      style: const TextStyle(fontSize: 12, color: MuamalahColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            if (thread.isModerated)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Topik ini diarahkan kembali ke pembahasan edukatif.',
                  style: TextStyle(
                    fontSize: 11,
                    color: MuamalahColors.proses,
                  ),
                ),
              ),
          ],
        ),
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
