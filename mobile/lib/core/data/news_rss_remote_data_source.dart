import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../core/domain/entities/article.dart';
import '../../utils/news_helpers.dart';

/// =============================================================================
/// NEWS RSS REMOTE DATA SOURCE
/// =============================================================================
/// Fetch artikel dari Google News RSS feeds
/// =============================================================================

class NewsRssRemoteDataSource {
  final http.Client client;

  NewsRssRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  /// RSS Feed URLs
  static const String _coinvestasiUrl =
      'https://news.google.com/rss/search?q=site:coinvestasi.com%20kripto&hl=id&gl=ID&ceid=ID:id';
  
  static const String _cryptowaveUrl =
      'https://news.google.com/rss/search?q=site:cryptowave.id%20kripto&hl=id&gl=ID&ceid=ID:id';
  
  static const String _syariahUrl =
      'https://news.google.com/rss/search?q=(kripto%20syariah%20OR%20fiqh%20muamalah%20kripto%20OR%20zakat%20kripto)&hl=id&gl=ID&ceid=ID:id';
  
  static const String _marketUrl =
      'https://news.google.com/rss/search?q=kripto%20indonesia%20harga%20bitcoin&hl=id&gl=ID&ceid=ID:id';

  /// Fetch all articles dengan strategy
  Future<List<Article>> fetchArticles() async {
    final List<Article> allArticles = [];

    try {
      print('🌐 [NewsRSS] Fetching articles from multiple sources...');
      
      // Parallel fetch for speed
      final results = await Future.wait([
        _fetchFromUrl(_coinvestasiUrl, 'Coinvestasi'),
        _fetchFromUrl(_cryptowaveUrl, 'Cryptowave'),
        _fetchFromUrl(_syariahUrl, 'Syariah'),
        _fetchFromUrl(_marketUrl, 'Pasar'),
      ]);

      for (var list in results) {
        allArticles.addAll(list);
      }

      // 3. De-duplicate by ID
      final uniqueArticles = _deduplicateArticles(allArticles);

      // 4. Sort by publishedAt (newest first)
      uniqueArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      print('✅ [NewsRSS] Total unique articles fetched: ${uniqueArticles.length}');
      return uniqueArticles.take(40).toList();
    } catch (e) {
      print('⚠️ [NewsRSS] Error fetching articles: $e');
      return [];
    }
  }

  /// Fetch articles dari single URL
  Future<List<Article>> _fetchFromUrl(String url, String queryTag) async {
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          'Accept': 'application/xml, text/xml, */*',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        print('⚠️ [NewsRSS] Failed to fetch $queryTag: ${response.statusCode}');
        return [];
      }

      final articles = _parseRss(response.body, queryTag);
      print('ℹ️ [NewsRSS] Source $queryTag returned ${articles.length} items');
      return articles;
    } catch (e) {
      print('⚠️ [NewsRSS] Error fetching $queryTag: $e');
      return [];
    }
  }

  /// Parse RSS XML
  List<Article> _parseRss(String xmlString, String queryTag) {
    try {
      final document = XmlDocument.parse(xmlString);
      final items = document.findAllElements('item');

      final articles = <Article>[];

      for (final item in items) {
        try {
          final titleElement = item.findElements('title').firstOrNull;
          final linkElement = item.findElements('link').firstOrNull;
          final pubDateElement = item.findElements('pubDate').firstOrNull;

          if (titleElement == null || linkElement == null) continue;

          final title = titleElement.innerText;
          final link = linkElement.innerText;
          final pubDateStr = pubDateElement?.innerText ?? '';
          
          // Parse source
          String source = queryTag;
          final sourceElement = item.findElements('source').firstOrNull;
          if (sourceElement != null) {
            source = sourceElement.innerText;
          } else if (title.contains(' - ')) {
            source = title.split(' - ').last.trim();
          }

          // Parse description/snippet
          String? snippet;
          final descElement = item.findElements('description').firstOrNull;
          if (descElement != null) {
            snippet = truncate(stripHtml(descElement.innerText), 140);
          }

          // Parse image - Google News format often uses media:content
          String? imageUrl;
          // Try standard media namespace elements
          final mediaContent = item.findElements('media:content').firstOrNull;
          if (mediaContent != null) {
            imageUrl = mediaContent.getAttribute('url');
          }

          // Parse pubDate safely
          final publishedAt = _parseRfc822Date(pubDateStr);

          articles.add(Article(
            id: Article.generateId(link),
            title: title,
            link: link,
            source: source,
            publishedAt: publishedAt,
            snippet: snippet,
            imageUrl: imageUrl,
            queryTag: queryTag,
          ));
        } catch (e) {
          continue;
        }
      }

      return articles;
    } catch (e) {
      print('⚠️ [NewsRSS] Error parsing RSS: $e');
      return [];
    }
  }

  /// De-duplicate articles by ID
  List<Article> _deduplicateArticles(List<Article> articles) {
    final seen = <String>{};
    final unique = <Article>[];
    for (final article in articles) {
      if (seen.add(article.id)) {
        unique.add(article);
      }
    }
    return unique;
  }

  /// Parse RFC 822 date format (used in RSS)
  DateTime _parseRfc822Date(String dateStr) {
    if (dateStr.isEmpty) return DateTime.now();
    try {
      // Step 1: Try common RFC 822/1123 parser via standard intl if possible
      // but manually is often safer for variations
      // "Mon, 12 Jan 2026 07:00:00 GMT" -> "12 Jan 2026 07:00:00"
      
      String cleaned = dateStr.trim();
      // Remove day name if exists: "Mon, "
      if (cleaned.contains(', ')) {
        cleaned = cleaned.split(', ').last;
      }
      
      // Map months
      final months = {'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6, 
                      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12};
      
      final parts = cleaned.split(' ');
      if (parts.length >= 3) {
        final day = int.parse(parts[0]);
        final month = months[parts[1]] ?? 1;
        final year = int.parse(parts[2]);
        
        int hour = 0, min = 0, sec = 0;
        if (parts.length >= 4 && parts[3].contains(':')) {
          final timeParts = parts[3].split(':');
          hour = int.parse(timeParts[0]);
          min = int.parse(timeParts[1]);
          if (timeParts.length > 2) sec = int.parse(timeParts[2]);
        }
        
        return DateTime(year, month, day, hour, min, sec);
      }
      
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }
}

