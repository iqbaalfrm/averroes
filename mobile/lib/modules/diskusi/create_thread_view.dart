import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/auth_guard.dart';
import 'diskusi_controller.dart';

class CreateThreadView extends StatefulWidget {
  const CreateThreadView({super.key});

  @override
  State<CreateThreadView> createState() => _CreateThreadViewState();
}

class _CreateThreadViewState extends State<CreateThreadView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final RxString _selectedCategory = 'Fiqh'.obs;
  final RxBool _isAnonymous = false.obs;

  final List<String> _categories = const [
    'Fiqh',
    'Crypto',
    'Zakat',
    'Edukasi',
    'Pustaka',
    'Refleksi',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiskusiController>();

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Ajukan Pertanyaan'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tanya dengan jelas, biar jawabannya nyambung.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Gunakan bahasa yang sopan dan jelas. Diskusi ini bersifat edukatif.',
                style: TextStyle(fontSize: 12, color: MuamalahColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _buildField(
                label: 'Judul pertanyaan',
                hint: 'Contoh: Apakah akad ini sesuai syariah?',
                controller: _titleController,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              _buildField(
                label: 'Deskripsi (opsional)',
                hint: 'Tambah konteks supaya lebih jelas',
                controller: _descController,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih kategori',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory.value == category;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _selectedCategory.value = category;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? MuamalahColors.primaryEmerald.withOpacity(0.12)
                              : MuamalahColors.neutralBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? MuamalahColors.primaryEmerald
                                : MuamalahColors.glassBorder,
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? MuamalahColors.primaryEmerald
                                : MuamalahColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 18),
              Obx(() {
                return SwitchListTile(
                  value: _isAnonymous.value,
                  onChanged: (value) => _isAnonymous.value = value,
                  title: const Text(
                    'Post sebagai Anonim',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Nama kamu tidak akan tampil di thread ini.',
                    style: TextStyle(fontSize: 11),
                  ),
                  activeColor: MuamalahColors.primaryEmerald,
                  contentPadding: EdgeInsets.zero,
                );
              }),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  AuthGuard.requireAuth(
                    featureName: 'Diskusi',
                    onAllowed: () async {
                      final title = _titleController.text.trim();
                      final desc = _descController.text.trim();
                      if (title.isEmpty) {
                        Get.snackbar(
                          'Judul kosong',
                          'Judul pertanyaan wajib diisi.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: MuamalahColors.neutralBg,
                          colorText: MuamalahColors.textPrimary,
                        );
                        return;
                      }
                      final added = await controller.addThread(
                        title: title,
                        description: desc,
                        category: _selectedCategory.value,
                        anonymous: _isAnonymous.value,
                      );
                      if (!added) {
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
                      Get.back();
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: MuamalahColors.primaryEmerald,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Kirim Pertanyaan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: MuamalahColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MuamalahColors.glassBorder),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
