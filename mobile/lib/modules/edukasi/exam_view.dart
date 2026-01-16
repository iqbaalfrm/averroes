import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'edukasi_controller.dart';
import 'edukasi_models.dart';
import '../sertifikat/certificate_detail_view.dart';

class ExamView extends StatefulWidget {
  final ClassModel classModel;

  const ExamView({super.key, required this.classModel});

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  final EdukasiController controller = Get.find<EdukasiController>();
  final RxBool isLoading = true.obs;
  final Rxn<ExamModel> exam = Rxn<ExamModel>();
  final RxString errorMessage = ''.obs;
  final Map<String, String?> selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _loadExam();
  }

  Future<void> _loadExam() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await controller.fetchClassExam(widget.classModel.id);
      exam.value = data;
      if (data == null) {
        errorMessage.value = 'Ujian belum tersedia.';
      }
    } catch (_) {
      errorMessage.value = 'Gagal memuat ujian.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _submitExam() async {
    final data = exam.value;
    if (data == null) return;

    final answers = data.questions.map((q) {
      return {
        'question_id': q.id,
        'option_id': selectedOptions[q.id],
      };
    }).toList();

    final response = await controller.submitClassExam(widget.classModel.id, answers);
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
    final cert = payload['certificate'] as Map<String, dynamic>?;

    Get.bottomSheet(
      _ExamResultSheet(
        score: score,
        status: status,
        certificate: cert,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Ujian Akhir'),
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

        final data = exam.value;
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
            if (data.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                data.description,
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
              onPressed: _submitExam,
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

class _ExamResultSheet extends StatelessWidget {
  final int score;
  final String status;
  final Map<String, dynamic>? certificate;

  const _ExamResultSheet({
    required this.score,
    required this.status,
    required this.certificate,
  });

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
            isPass ? 'Ujian Lulus' : 'Ujian Belum Lulus',
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
          if (isPass && certificate != null) ...[
            ElevatedButton(
              onPressed: () {
                final model = CertificateModel(
                  id: certificate?['id'] as String? ?? '',
                  classId: certificate?['class_id'] as String? ?? '',
                  classTitle: certificate?['class_title'] as String? ?? '',
                  certificateNumber: certificate?['certificate_number'] as String? ?? '',
                  finalScore: certificate?['final_score'] as int? ?? score,
                  issuedAt: certificate?['issued_at'] != null
                      ? DateTime.tryParse(certificate?['issued_at'] as String)
                      : null,
                  qrPayload: certificate?['qr_payload'] as String? ?? '',
                );
                Get.back();
                Get.to(() => CertificateDetailView(certificate: model));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MuamalahColors.primaryEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Lihat Sertifikat'),
            ),
            const SizedBox(height: 8),
          ],
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
