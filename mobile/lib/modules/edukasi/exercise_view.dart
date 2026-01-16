import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'edukasi_controller.dart';
import 'edukasi_models.dart';

class ExerciseView extends StatefulWidget {
  final ClassModel classModel;
  final LessonModel lessonModel;

  const ExerciseView({
    super.key,
    required this.classModel,
    required this.lessonModel,
  });

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  final EdukasiController controller = Get.find<EdukasiController>();
  final RxBool isLoading = true.obs;
  final Rxn<ExerciseModel> exercise = Rxn<ExerciseModel>();
  final RxString errorMessage = ''.obs;
  final Map<String, String?> selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _loadExercise();
  }

  Future<void> _loadExercise() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await controller.fetchLessonExercise(widget.lessonModel.id);
      exercise.value = data;
      if (data == null) {
        errorMessage.value = 'Latihan belum tersedia.';
      }
    } catch (_) {
      errorMessage.value = 'Gagal memuat latihan.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _submitExercise() async {
    final data = exercise.value;
    if (data == null) return;

    final answers = data.questions.map((q) {
      return {
        'question_id': q.id,
        'option_id': selectedOptions[q.id],
      };
    }).toList();

    final response = await controller.submitLessonExercise(widget.lessonModel.id, answers);
    if (response == null) {
      Get.snackbar(
        'Gagal',
        'Tidak bisa mengirim jawaban.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: MuamalahColors.haramBg,
        colorText: MuamalahColors.haram,
      );
      return;
    }

    final payload = response['data'] as Map<String, dynamic>? ?? {};
    final score = payload['score'] as int? ?? 0;
    final status = payload['status'] as String? ?? 'gagal';

    if (status == 'lulus') {
      controller.markLessonCompleted(widget.classModel, widget.lessonModel, true);
    }

    Get.bottomSheet(
      _ResultSheet(score: score, status: status),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Latihan'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: MuamalahColors.textPrimary,
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: MuamalahColors.primaryEmerald),
          );
        }

        if (errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              errorMessage.value,
              style: const TextStyle(color: MuamalahColors.textSecondary),
            ),
          );
        }

        final data = exercise.value;
        if (data == null) {
          return const SizedBox.shrink();
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),
            if (data.instructions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                data.instructions,
                style: const TextStyle(
                  fontSize: 13,
                  color: MuamalahColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ...data.questions.map(_buildQuestionCard).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: MuamalahColors.primaryEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Kirim Jawaban',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...question.options.map((option) {
            return RadioListTile<String>(
              value: option.id,
              groupValue: selectedOptions[question.id],
              onChanged: (value) {
                setState(() {
                  selectedOptions[question.id] = value;
                });
              },
              title: Text(
                option.text,
                style: const TextStyle(fontSize: 13, color: MuamalahColors.textSecondary),
              ),
              activeColor: MuamalahColors.primaryEmerald,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _ResultSheet extends StatelessWidget {
  final int score;
  final String status;

  const _ResultSheet({required this.score, required this.status});

  @override
  Widget build(BuildContext context) {
    final isPass = status == 'lulus';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPass ? MuamalahColors.halalBg : MuamalahColors.haramBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPass ? Icons.verified_rounded : Icons.error_outline_rounded,
              color: isPass ? MuamalahColors.halal : MuamalahColors.haram,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isPass ? 'Latihan Lulus' : 'Latihan Belum Lulus',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nilai kamu: $score',
            style: const TextStyle(
              fontSize: 14,
              color: MuamalahColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: MuamalahColors.primaryEmerald,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
