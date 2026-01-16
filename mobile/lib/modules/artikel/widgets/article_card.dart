import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../../../core/domain/entities/article.dart';
import '../artikel_detail_view.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/news_helpers.dart';

/// =============================================================================
/// ARTICLE CARD WIDGET
/// =============================================================================

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.to(() => ArtikelDetailView(article: article));
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showOptions(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail or Placeholder
            _buildThumbnail(),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag Badge
                  _buildTagBadge(),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MuamalahColors.textPrimary,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Snippet
                  if (article.snippet != null && article.snippet!.isNotEmpty)
                    Text(
                      article.snippet!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MuamalahColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Source & Time
                  Row(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 14,
                        color: MuamalahColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _displaySource(article.source),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MuamalahColors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        relativeTime(article.publishedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: MuamalahColors.textMuted.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (article.imageUrl != null && article.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          article.imageUrl!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    final colors = _getGradientColors();

    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Center(
        child: Icon(
          Icons.article_rounded,
          size: 60,
          color: Colors.white.withAlpha(150),
        ),
      ),
    );
  }

  Widget _buildTagBadge() {
    final color = _getTagColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _displayTag(article.queryTag),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    switch (article.queryTag.toLowerCase()) {
      case 'coinvestasi':
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case 'cryptowave':
      case 'kriptowave':
        return [const Color(0xFFEC4899), const Color(0xFFF472B6)];
      case 'syariah':
        return [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight];
      case 'market':
      case 'pasar':
        return [const Color(0xFFF59E0B), const Color(0xFFFBBF24)];
      default:
        return [MuamalahColors.textMuted, MuamalahColors.textSecondary];
    }
  }

  Color _getTagColor() {
    switch (article.queryTag.toLowerCase()) {
      case 'coinvestasi':
        return const Color(0xFF6366F1);
      case 'cryptowave':
      case 'kriptowave':
        return const Color(0xFFEC4899);
      case 'syariah':
        return MuamalahColors.primaryEmerald;
      case 'market':
      case 'pasar':
        return const Color(0xFFF59E0B);
      default:
        return MuamalahColors.textMuted;
    }
  }

  String _displaySource(String source) {
    final lower = source.toLowerCase();
    if (lower.contains('cryptowave')) return 'Kriptowave';
    return source;
  }

  String _displayTag(String tag) {
    final lower = tag.toLowerCase();
    if (lower == 'market') return 'Pasar';
    if (lower == 'screener') return 'Penyaring';
    if (lower == 'cryptowave') return 'Kriptowave';
    return tag;
  }

  Future<void> _openArticle() async {
    final url = extractOriginalUrl(article.link) ?? article.link;
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.inAppBrowserView,
        );
      }
    } catch (e) {
      print('⚠️ [Article] Failed to open: $e');
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 20),

              // Copy Link
              ListTile(
                leading: const Icon(Icons.copy_rounded, color: MuamalahColors.primaryEmerald),
                title: const Text('Salin Tautan'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: article.link));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tautan tersalin'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),

              // Share Link
              ListTile(
                leading: const Icon(Icons.share_rounded, color: Color(0xFF6366F1)),
                title: const Text('Bagikan'),
                onTap: () {
                  Navigator.pop(context);
                  Share.share(
                    '${article.title}\n\n${article.link}',
                    subject: article.title,
                  );
                },
              ),

              // Open in Browser
              ListTile(
                leading: const Icon(Icons.open_in_browser_rounded, color: Color(0xFFF59E0B)),
                title: const Text('Buka di Peramban'),
                onTap: () {
                  Navigator.pop(context);
                  _openInExternalBrowser();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInExternalBrowser() async {
    final url = extractOriginalUrl(article.link) ?? article.link;
    final uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('⚠️ [Article] Failed to open in browser: $e');
    }
  }
}
