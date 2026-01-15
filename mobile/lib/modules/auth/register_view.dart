import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../theme/app_theme.dart';
import 'auth_controller.dart';
import 'login_view.dart';

/// =============================================================================
/// REGISTER VIEW - Username + Email + Password
/// =============================================================================

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
  }

  void _toggleTerms() {
    setState(() => _agreedToTerms = !_agreedToTerms);
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      Get.snackbar(
        'Peringatan',
        'Mohon setujui prinsip muamalah syariah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: MuamalahColors.proses.withAlpha(200),
        colorText: Colors.white,
      );
      return;
    }

    final controller = Get.find<AuthController>();
    await controller.signUp(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim().isNotEmpty 
          ? _fullNameController.text.trim() 
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inject AuthController
    Get.put(AuthController());
    
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: Stack(
        children: [
          // Background decorations
          _buildBackgroundDecorations(),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Back button
                    _buildBackButton(),

                    const SizedBox(height: 32),

                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/branding/logoutama.png',
                          width: 72,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Register Card
                    _buildRegisterCard(),

                    const SizedBox(height: 32),

                    // Login link
                    _buildLoginLink(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  MuamalahColors.mint.withAlpha(128),
                  MuamalahColors.mint.withAlpha(0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withAlpha(77),
                  const Color(0xFF8B5CF6).withAlpha(0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back_rounded, size: 22),
      ),
    );
  }

  Widget _buildRegisterCard() {
    final controller = Get.find<AuthController>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(230),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withAlpha(180),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mulai perjalanan crypto syariahmu 🌙',
                style: TextStyle(
                  fontSize: 15,
                  color: MuamalahColors.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              // Username field
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                hint: 'contoh: ahmad123',
                icon: Icons.alternate_email_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  if (value.length < 3) {
                    return 'Username minimal 3 karakter';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                    return 'Username hanya boleh huruf, angka, dan underscore';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Full Name field (optional)
              _buildTextField(
                controller: _fullNameController,
                label: 'Nama Lengkap (Opsional)',
                hint: 'Masukkan nama lengkap',
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'nama@email.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Password field
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Minimal 6 karakter',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onTogglePassword: _togglePasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Confirm Password field
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Konfirmasi Password',
                hint: 'Ulangi password',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                onTogglePassword: _toggleConfirmPasswordVisibility,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  if (value != _passwordController.text) {
                    return 'Password tidak sama';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Terms checkbox
              GestureDetector(
                onTap: _toggleTerms,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _agreedToTerms
                            ? MuamalahColors.primaryEmerald
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _agreedToTerms
                              ? MuamalahColors.primaryEmerald
                              : MuamalahColors.glassBorder,
                          width: 2,
                        ),
                      ),
                      child: _agreedToTerms
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Saya setuju dengan prinsip muamalah syariah dan berkomitmen untuk berinvestasi secara halal',
                        style: TextStyle(
                          fontSize: 13,
                          color: MuamalahColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Register button
              Obx(() => GestureDetector(
                onTap: controller.isLoading.value ? null : _handleRegister,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        MuamalahColors.primaryEmerald,
                        MuamalahColors.emeraldLight,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: MuamalahColors.primaryEmerald.withAlpha(77),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Daftar Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: MuamalahColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: MuamalahColors.neutralBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MuamalahColors.glassBorder),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword && !isPasswordVisible,
            validator: validator,
            style: const TextStyle(
              fontSize: 15,
              color: MuamalahColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: MuamalahColors.textMuted,
              ),
              prefixIcon: Icon(icon, color: MuamalahColors.textMuted, size: 22),
              suffixIcon: isPassword
                  ? GestureDetector(
                      onTap: onTogglePassword,
                      child: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: MuamalahColors.textMuted,
                        size: 22,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sudah punya akun? ',
            style: TextStyle(
              fontSize: 14,
              color: MuamalahColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: () => Get.off(() => const LoginView()),
            child: const Text(
              'Masuk',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.primaryEmerald,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
