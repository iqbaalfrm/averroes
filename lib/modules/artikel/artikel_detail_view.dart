import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../core/domain/entities/article.dart';
import '../../utils/news_helpers.dart';

class ArtikelDetailView extends StatelessWidget {
  final Article article;

  const ArtikelDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildContent(),
                  const SizedBox(height: 40),
                  _buildFooter(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      elevation: 0,
      backgroundColor: MuamalahColors.primaryEmerald,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (article.imageUrl != null)
              Image.network(
                article.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
              )
            else
              _buildPlaceholderImage(),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: MuamalahColors.primaryEmerald.withOpacity(0.8),
      child: const Icon(Icons.article_rounded, size: 80, color: Colors.white24),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: MuamalahColors.primaryEmerald.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            article.queryTag.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.primaryEmerald,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          article.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: MuamalahColors.mint,
              child: const Icon(Icons.person_rounded, size: 14, color: MuamalahColors.primaryEmerald),
            ),
            const SizedBox(width: 8),
            Text(
              article.source,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MuamalahColors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              relativeTime(article.publishedAt),
              style: const TextStyle(
                fontSize: 12,
                color: MuamalahColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    // For dummy articles, we show more text. For RSS, we show the snippet.
    final contentText = article.snippet ?? "Konten artikel tidak tersedia dalam ringkasan RSS.";
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contentText,
          style: const TextStyle(
            fontSize: 16,
            color: MuamalahColors.textPrimary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Aset kripto saat ini menjadi salah satu instrumen investasi yang paling banyak diperbincangkan di seluruh dunia, termasuk di Indonesia. Namun, bagi seorang muslim, aspek kepatuhan syariah merupakan pertimbangan utama sebelum memutuskan untuk berinvestasi. \n\nPrinsip-prinsip dasar seperti menghindari Riba (bunga), Gharar (ketidakpastian yang berlebihan), dan Maysir (perjudian) menjadi fondasi dalam menilai apakah sebuah aset digital dapat dikategorikan sebagai harta yang halal untuk dimiliki dan diperdagangkan.",
          style: TextStyle(
            fontSize: 16,
            color: MuamalahColors.textPrimary,
            height: 1.6,
          ),
        ),
        if (article.id.startsWith('dummy')) ...[
           const SizedBox(height: 16),
           const Text(
            "Beberapa ulama dan dewan syariah di berbagai negara telah mulai mengeluarkan panduan terkait teknologi blockchain. Kesimpulan umumnya menunjukkan bahwa blockchain sebagai teknologi adalah netral, namun penggunaannya (seperti jenis token dan mekanisme konsensus) itulah yang menentukan status hukumnya. \n\nOleh karena itu, sangat penting bagi para investor untuk melakukan 'Self-Screening' atau menggunakan platform yang menyediakan filter syariah terpercaya seperti Averroes untuk memastikan setiap aset yang dibeli sesuai dengan koridor Fiqh Muamalah.",
            style: TextStyle(
              fontSize: 16,
              color: MuamalahColors.textPrimary,
              height: 1.6,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline_rounded, color: MuamalahColors.primaryEmerald),
          const SizedBox(height: 12),
          const Text(
             "Artikel ini disadur dari sumber terkait untuk tujuan edukasi. Keputusan investasi sepenuhnya ada di tangan pengguna.",
             textAlign: TextAlign.center,
             style: TextStyle(
               fontSize: 12,
               fontStyle: FontStyle.italic,
               color: MuamalahColors.textSecondary,
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(article.link);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MuamalahColors.primaryEmerald,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Baca Artikel Selengkapnya',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: MuamalahColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.share_rounded, color: MuamalahColors.primaryEmerald),
                onPressed: () {
                   // Share logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
