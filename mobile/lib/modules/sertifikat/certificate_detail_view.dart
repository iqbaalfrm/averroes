import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../theme/app_theme.dart';
import '../edukasi/edukasi_models.dart';

class CertificateDetailView extends StatelessWidget {
  final CertificateModel certificate;

  const CertificateDetailView({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Detail Sertifikat'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: MuamalahColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCertificateCard(),
            const SizedBox(height: 20),
            _buildQrSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sertifikat Kelulusan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildRow('Nama Kelas', certificate.classTitle),
          _buildRow('Nomor Sertifikat', certificate.certificateNumber),
          _buildRow('Nilai Akhir', certificate.finalScore.toString()),
          _buildRow(
            'Tanggal Kelulusan',
            certificate.issuedAt != null
                ? _formatDate(certificate.issuedAt!)
                : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildQrSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: Column(
        children: [
          const Text(
            'QR Verifikasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          QrImageView(
            data: certificate.qrPayload,
            size: 160,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Tunjukkan QR ini untuk verifikasi keaslian sertifikat.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: MuamalahColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: MuamalahColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MuamalahColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
