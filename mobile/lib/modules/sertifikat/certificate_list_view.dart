import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../edukasi/edukasi_controller.dart';
import '../edukasi/edukasi_models.dart';
import 'certificate_detail_view.dart';

class CertificateListView extends StatefulWidget {
  const CertificateListView({super.key});

  @override
  State<CertificateListView> createState() => _CertificateListViewState();
}

class _CertificateListViewState extends State<CertificateListView> {
  late final EdukasiController controller;
  final RxBool isLoading = true.obs;
  final RxList<CertificateModel> certificates = <CertificateModel>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<EdukasiController>()
        ? Get.find<EdukasiController>()
        : Get.put(EdukasiController());
    _loadCertificates();
  }

  Future<void> _loadCertificates() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final items = await controller.fetchCertificates();
      certificates.assignAll(items);
    } catch (_) {
      errorMessage.value = 'Gagal memuat sertifikat.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Sertifikat'),
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

        if (certificates.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada sertifikat',
              style: TextStyle(color: MuamalahColors.textSecondary),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemBuilder: (context, index) {
            final item = certificates[index];
            return GestureDetector(
              onTap: () => Get.to(() => CertificateDetailView(certificate: item)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: MuamalahColors.glassBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MuamalahColors.halalBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.verified_rounded, color: MuamalahColors.halal),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.classTitle.isNotEmpty ? item.classTitle : 'Kelas',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MuamalahColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.certificateNumber,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MuamalahColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: MuamalahColors.textMuted),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: certificates.length,
        );
      }),
    );
  }
}
