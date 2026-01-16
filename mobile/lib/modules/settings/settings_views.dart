import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_dialog.dart';

// ============================================================================
// SETTINGS VIEWS - COMPLETE UI FOR ALL MENU ITEMS
// ============================================================================

// ============================================================================
// SETTINGS HOME
// ============================================================================

class SettingsHomeView extends StatelessWidget {
  const SettingsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Pengaturan', Icons.settings_rounded),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildLinkTile('Preferensi Syariah', Icons.mosque_outlined, onTap: () {
                    Get.to(() => const PreferensiSyariahView());
                  }),
                  _buildLinkTile('Pemberitahuan', Icons.notifications_outlined, onTap: () {
                    Get.to(() => const NotifikasiSettingsView());
                  }),
                  _buildLinkTile('Tentang Aplikasi', Icons.info_outline_rounded, onTap: () {
                    Get.to(() => const TentangAplikasiView());
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 1. PROFIL PENGGUNA
// ============================================================================

class ProfilPenggunaView extends StatelessWidget {
  const ProfilPenggunaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Profil Pengguna', Icons.person_outline_rounded),

            const SizedBox(height: 24),

            // Profile Photo
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: MuamalahColors.primaryEmerald,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'IF',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _showSnackbar('Ubah Foto', 'Membuka galeri...'),
                    child: Text(
                      'Ubah Foto',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.primaryEmerald,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildFormField('Nama Lengkap', 'Iqbal Firmansyah', Icons.person_outline_rounded),
                  _buildFormField('Email', 'iqbalfirmansyah@email.com', Icons.email_outlined),
                  _buildFormField('Nomor Telepon', '+62 812 3456 7890', Icons.phone_outlined),
                  _buildFormField('Tanggal Lahir', '15 Januari 1998', Icons.calendar_today_outlined),

                  const SizedBox(height: 32),

                  // Save Button
                  GestureDetector(
                    onTap: () => _showSnackbar('Tersimpan', 'Profil berhasil diperbarui'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Simpan Perubahan',
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

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. PREFERENSI SYARIAH
// ============================================================================

class PreferensiSyariahView extends StatelessWidget {
  const PreferensiSyariahView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool strictMode = true.obs;
    final RxBool showProses = true.obs;
    final RxBool zakatReminder = true.obs;
    final RxString mazhab = 'Syafi\'i'.obs;

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Preferensi Syariah', Icons.mosque_outlined),

            const SizedBox(height: 16),

            // Explanation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MuamalahColors.halalBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MuamalahColors.halal.withAlpha(51)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: MuamalahColors.halal,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sesuaikan pengaturan sesuai pemahaman syariah Anda. Konsultasikan dengan ulama untuk keputusan penting.',
                        style: TextStyle(
                          fontSize: 12,
                          color: MuamalahColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Obx(() => _buildSwitchTile(
                    'Mode Ketat',
                    'Hanya tampilkan aset yang jelas kehalalannya',
                    Icons.verified_outlined,
                    strictMode.value,
                    (v) => strictMode.value = v,
                  )),
                  Obx(() => _buildSwitchTile(
                    'Tampilkan Proses',
                    'Tampilkan aset dengan status proses',
                    Icons.help_outline_rounded,
                    showProses.value,
                    (v) => showProses.value = v,
                  )),
                  Obx(() => _buildSwitchTile(
                    'Pengingat Zakat',
                    'Ingatkan saat aset mencapai nisab',
                    Icons.notifications_outlined,
                    zakatReminder.value,
                    (v) => zakatReminder.value = v,
                  )),

                  const SizedBox(height: 16),

                  // Mazhab Selection
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preferensi Mazhab',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MuamalahColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Referensi fatwa sesuai mazhab pilihan',
                          style: TextStyle(
                            fontSize: 12,
                            color: MuamalahColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() => Wrap(
                          spacing: 8,
                          children: ['Syafi\'i', 'Hanafi', 'Maliki', 'Hanbali'].map((m) {
                            final isSelected = mazhab.value == m;
                            return GestureDetector(
                              onTap: () => mazhab.value = m,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? MuamalahColors.primaryEmerald : MuamalahColors.neutralBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  m,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.white : MuamalahColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 3. NOTIFIKASI
// ============================================================================

class NotifikasiSettingsView extends StatelessWidget {
  const NotifikasiSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool priceAlert = true.obs;
    final RxBool zakatAlert = true.obs;
    final RxBool newsAlert = false.obs;
    final RxBool prayerReminder = true.obs;

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Pemberitahuan', Icons.notifications_outlined),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferensi Pemberitahuan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Obx(() => _buildSwitchTile(
                    'Peringatan Harga',
                    'Pemberitahuan saat harga mencapai target',
                    Icons.trending_up_rounded,
                    priceAlert.value,
                    (v) => priceAlert.value = v,
                  )),
                  Obx(() => _buildSwitchTile(
                    'Pengingat Zakat',
                    'Pemberitahuan saat waktu bayar zakat',
                    Icons.volunteer_activism_outlined,
                    zakatAlert.value,
                    (v) => zakatAlert.value = v,
                  )),
                  Obx(() => _buildSwitchTile(
                    'Berita & Pembaruan',
                    'Info terbaru tentang kripto syariah',
                    Icons.article_outlined,
                    newsAlert.value,
                    (v) => newsAlert.value = v,
                  )),
                  Obx(() => _buildSwitchTile(
                    'Pengingat Sholat',
                    'Pemberitahuan waktu sholat',
                    Icons.access_time_rounded,
                    prayerReminder.value,
                    (v) => prayerReminder.value = v,
                  )),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 4. TENTANG APLIKASI
// ============================================================================

class TentangAplikasiView extends StatelessWidget {
  const TentangAplikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Tentang Aplikasi', Icons.info_outline_rounded),

            const SizedBox(height: 32),

            // App Logo & Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(12),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/branding/logoutama.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Averroes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(6),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tentang Averroes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Averroes adalah platform edukasi dan panduan investasi aset kripto yang sesuai dengan prinsip-prinsip syariah Islam. Aplikasi ini dikembangkan untuk membantu umat Muslim memahami dan berpartisipasi dalam ekonomi digital dengan tetap menjaga nilai-nilai keislaman.',
                      style: TextStyle(
                        fontSize: 14,
                        color: MuamalahColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fitur utama meliputi penyaring aset syariah, kalkulator zakat, edukasi fikih muamalah, dan panduan investasi yang amanah.',
                      style: TextStyle(
                        fontSize: 14,
                        color: MuamalahColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildLinkTile('Syarat & Ketentuan', Icons.description_outlined),
                  _buildLinkTile('Kebijakan Privasi', Icons.privacy_tip_outlined),
                  _buildLinkTile('Hubungi Kami', Icons.email_outlined),
                  _buildLinkTile('Beri Rating', Icons.star_outline_rounded),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Copyright
            Center(
              child: Text(
                '© 2024 Averroes. Semua hak cipta dilindungi.',
                style: TextStyle(
                  fontSize: 12,
                  color: MuamalahColors.textMuted,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SHARED WIDGETS
// ============================================================================

Widget _buildHeader(String title, IconData icon) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(8),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFormField(String label, String value, IconData icon) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(6),
          blurRadius: 12,
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(icon, color: MuamalahColors.neutral, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: MuamalahColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: MuamalahColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.edit_outlined, color: MuamalahColors.neutral, size: 18),
      ],
    ),
  );
}

Widget _buildSwitchTile(
  String title,
  String subtitle,
  IconData icon,
  bool value,
  Function(bool) onChanged,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(6),
          blurRadius: 12,
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MuamalahColors.neutralBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: MuamalahColors.neutral, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: MuamalahColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
        ),
      ],
    ),
  );
}

Widget _buildLinkTile(String title, IconData icon, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap ?? () => _showSnackbar(title, 'Membuka halaman...'),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: MuamalahColors.neutral, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: MuamalahColors.textPrimary,
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: MuamalahColors.neutral),
        ],
      ),
    ),
  );
}

void _showSnackbar(String title, String message) {
  AppDialogs.showSuccess(title: title, message: message);
}
